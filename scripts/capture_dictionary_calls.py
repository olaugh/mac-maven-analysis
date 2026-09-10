#!/usr/bin/env python3
"""Compare natural CODE 15 section-lookup calls with compiled readable C.

Launch Maven first, then arm this capture before a UI word lookup. Guest table
bytes and loaded code must match preserved originals. No calls are injected.
"""
import argparse
import ctypes
import hashlib
import json
from pathlib import Path
import re
import struct
import subprocess
import tempfile
from gdb_remote import Remote
from qmp_session import command


class Section(ctypes.Structure):
    _fields_=[('records',ctypes.c_void_p),('root_index',ctypes.c_int32)]


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--calls',type=int,default=1)
    parser.add_argument('--data-file',type=Path,required=True)
    parser.add_argument('--output',type=Path,required=True)
    args=parser.parse_args()
    data=args.data_file.read_bytes()
    manifest=json.loads(Path('analysis/toolchain/dictionary-snapshot.json').read_text())
    tables=manifest['sections'];buffers={};rows=[];points=set()
    command('stop');r=Remote();r.sock.settimeout(60)
    def read(address,count):
        result=bytearray()
        for offset in range(0,count,8192):
            size=min(8192,count-offset)
            reply=r.command(f'm{address+offset:x},{size:x}')
            if reply.startswith('E') or len(reply)!=size*2:
                raise RuntimeError(f'Guest read failed at {address+offset:#x}: {reply[:80]}')
            result.extend(bytes.fromhex(reply))
        return bytes(result)
    def registers():return struct.unpack('>18I',bytes.fromhex(r.command('g')))
    def arm(address):
        assert r.command(f'Z0,{address:x},2')=='OK';points.add(address)
    def disarm(address):
        assert r.command(f'z0,{address:x},2')=='OK';points.remove(address)
    try:
        r.command('?')
        assert read(0x40800000,16).hex()=='f1acad130000002a067c4efa00804efa'
        xml=r.command('qXfer:features:read:m68k-core.xml:0,fff')
        assert re.findall(r'<reg name="([^"]+)"',xml)==(
            [f'd{i}' for i in range(8)]+[f'a{i}' for i in range(6)]+['fp','sp','ps','pc'])
        a5=int.from_bytes(read(0x904,4),'big')
        stub=read(a5+0x30a,6)
        if stub[:2]==b'\x4e\xf9':
            base=int.from_bytes(stub[2:],'big')-0x4d2
        else:
            assert stub==bytes.fromhex('3f3c000fa9f0')
            wrapper_slots={a5+0x31a:0x23e,a5+0x322:0x198}
            for slot in wrapper_slots:arm(slot)
            print('Waiting for a dictionary wrapper to load CODE 15',flush=True)
            r.command('c');slot=registers()[17];assert slot in wrapper_slots
            for point in list(points):disarm(point)
            stub=read(slot,6)
            if stub==bytes.fromhex('3f3c000fa9f0'):
                r.command('s');r.command('s');arm(slot);r.command('c')
                assert registers()[17]==slot;disarm(slot);stub=read(slot,6)
            assert stub[:2]==b'\x4e\xf9'
            base=int.from_bytes(stub[2:],'big')-wrapper_slots[slot]
        code=Path('resources/CODE/15_15.bin').read_bytes()
        assert read(base,len(code))==code
        entry=base+0x1c8
        with tempfile.TemporaryDirectory() as temp:
            library_path=Path(temp)/'lookup.dylib'
            subprocess.run(['cc','-std=c99','-Wall','-Wextra','-Werror','-dynamiclib',
                            'reconstruction/dictionary_lookup.c','-o',str(library_path)],check=True)
            lib=ctypes.CDLL(str(library_path));lookup=lib.maven_section_contains
            lookup.argtypes=[ctypes.POINTER(Section),ctypes.c_char_p]
            lookup.restype=ctypes.c_uint32
            for _ in range(args.calls):
                arm(entry);print('Lookup breakpoint armed',flush=True);r.command('c')
                incoming=registers();assert incoming[17]==entry;disarm(entry)
                caller,index,word_ptr=struct.unpack('>IiI',read(incoming[15],12))
                assert 0<=index<len(tables)
                word=read(word_ptr,256).split(b'\0',1)[0]
                assert len(word)<256
                table_base,root=struct.unpack('>Ii',read(a5-11960+8*index,8))
                metadata=tables[index];start=metadata['file_offset'];size=metadata['byte_count']
                blob=data[start:start+size]
                if (table_base,size) not in buffers:
                    assert read(table_base,size)==blob
                    buffers[(table_base,size)]=ctypes.create_string_buffer(blob)
                buffer=buffers[(table_base,size)]
                section=Section(ctypes.addressof(buffer),root)
                expected=lookup(ctypes.byref(section),word)
                arm(caller);r.command('c');outgoing=registers()
                assert outgoing[17]==caller;disarm(caller)
                row=dict(word_hex=word.hex(),word=word.decode('mac_roman'),section=index,
                         root_index=root,table_base=table_base,table_bytes_verified=size,
                         table_sha256=hashlib.sha256(blob).hexdigest(),
                         original_result=outgoing[0],reconstructed_result=expected,
                         stack_advance=outgoing[15]-incoming[15],
                         saved_registers_preserved=all(incoming[n]==outgoing[n] for n in [5,6,7,12]))
                rows.append(row);print(json.dumps(row),flush=True)
                assert outgoing[0]==expected
        report=dict(code15_base=base,code15_exact_match=True,a5=a5,
                    code15_sha256=hashlib.sha256(code).hexdigest(),calls=rows,
                    scope='Natural original section-lookup calls compared with compiled C on byte-identical live tables')
        args.output.parent.mkdir(parents=True,exist_ok=True)
        args.output.write_text(json.dumps(report,indent=2)+'\n')
    finally:
        command('stop')
        for address in points:r.command(f'z0,{address:x},2')
        r.close()


if __name__=='__main__':main()
