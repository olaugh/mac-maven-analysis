#!/usr/bin/env python3
"""Capture a complete normal Word List enumeration and compare native C.

Open Word List first, arm this script, then click All Words or Bingos.
Captures original globals before the section loop, exact append order, and
restored workspaces after the loop. Only debugger reads/breakpoints are used.
"""
import argparse
import ctypes as C
import hashlib
import json
from pathlib import Path
import re
import struct
import subprocess
import tempfile
from gdb_remote import Remote
from qmp_session import command


class Section(C.Structure):
    _fields_=[('records',C.c_void_p),('root_index',C.c_int32)]


Append=C.CFUNCTYPE(None,C.c_void_p,C.c_void_p)


class State(C.Structure):
    _fields_=[('sections',C.POINTER(Section)),('current_section',C.c_int16),
              ('available',C.c_int16*128),('blanks_used',C.c_int16),
              ('minimum_length',C.c_int16),('maximum_length',C.c_int16),
              ('result_count',C.c_int16),('prefix',C.c_void_p),('suffix',C.c_void_p),
              ('required_letters',C.c_void_p),('suffix_length',C.c_int16),
              ('required_counts',C.c_int16*128),('occurrences',C.c_int16*128),
              ('word',C.c_uint8*32),('length',C.c_size_t),('append_word',Append),
              ('user',C.c_void_p)]


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--data-file',type=Path,required=True)
    parser.add_argument('--output',type=Path,required=True)
    args=parser.parse_args()
    data=args.data_file.read_bytes()
    metadata=json.loads(Path('analysis/toolchain/dictionary-snapshot.json').read_text())['sections']
    command('stop');r=Remote();r.sock.settimeout(60);points=set()
    def read(address,count):
        result=bytearray()
        for offset in range(0,count,8192):
            size=min(8192,count-offset);reply=r.command(f'm{address+offset:x},{size:x}')
            if reply.startswith('E') or len(reply)!=size*2:
                raise RuntimeError(f'Guest read failed: {address+offset:#x}: {reply[:80]}')
            result.extend(bytes.fromhex(reply))
        return bytes(result)
    def regs():return struct.unpack('>18I',bytes.fromhex(r.command('g')))
    def arm(address):
        assert r.command(f'Z0,{address:x},2')=='OK';points.add(address)
    def disarm(address):
        assert r.command(f'z0,{address:x},2')=='OK';points.remove(address)
    def string(address):return read(address,32).split(b'\0',1)[0]
    def snapshot(a5):
        result={}
        for name,offset in [('available',-0x22e2),('required_counts',-0x23e2),('occurrences',-0x1eb8)]:
            result[name]=list(struct.unpack('>128h',read(a5+offset,256)))
        for name,offset in [('blanks_used',-0x21de),('minimum_length',-0x25e8),
                            ('maximum_length',-0x25e6),('result_count',-0x25e4),('suffix_length',-0x21e2)]:
            result[name]=struct.unpack('>h',read(a5+offset,2))[0]
        for name,offset in [('prefix',-0x2640),('suffix',-0x2630),('required_letters',-0x2600)]:
            result[name]=string(a5+offset).hex()
        result['word']=read(a5-0x2620,32).hex()
        result['length']=int.from_bytes(read(a5-0x25ec,4),'big')-(a5-0x2620)
        return result
    try:
        r.command('?');assert read(0x40800000,16).hex()=='f1acad130000002a067c4efa00804efa'
        xml=r.command('qXfer:features:read:m68k-core.xml:0,fff')
        assert re.findall(r'<reg name="([^"]+)"',xml)==(
            [f'd{i}' for i in range(8)]+[f'a{i}' for i in range(6)]+['fp','sp','ps','pc'])
        a5=int.from_bytes(read(0x904,4),'big');stub=read(a5+0x232,6)
        if stub[:2]==b'\x4e\xf9':base=int.from_bytes(stub[2:],'big')-0x686
        else:
            slots={a5+0x242:0x66e,a5+0x24a:0x67a}
            for slot in slots:arm(slot)
            print('Waiting for CODE 12 query entry',flush=True);r.command('c')
            slot=regs()[17];assert slot in slots
            for address in list(points):disarm(address)
            stub=read(slot,6)
            if stub==bytes.fromhex('3f3c000ca9f0'):
                r.command('s');r.command('s');arm(slot);r.command('c')
                assert regs()[17]==slot;disarm(slot);stub=read(slot,6)
            assert stub[:2]==b'\x4e\xf9';base=int.from_bytes(stub[2:],'big')-slots[slot]
        code=Path('resources/CODE/12_12.bin').read_bytes();assert read(base,len(code))==code
        arm(base+0x2d8);print('Enumeration start breakpoint armed',flush=True);r.command('c')
        assert regs()[17]==base+0x2d8;disarm(base+0x2d8)
        before=snapshot(a5);sections=[];buffers=[];table_records=[]
        for index,item in enumerate(metadata):
            address,root=struct.unpack('>Ii',read(a5-11960+8*index,8))
            if not root:break
            start=item['file_offset'];size=item['byte_count'];blob=data[start:start+size]
            assert read(address,size)==blob
            buffer=C.create_string_buffer(blob);buffers.append(buffer)
            sections.append(Section(C.addressof(buffer),root))
            table_records.append(dict(index=index,base=address,root=root,bytes=size,sha256=hashlib.sha256(blob).hexdigest()))
        assert read(a5-11960+8*len(sections)+4,4)==bytes(4)
        original=[];emit=base+0x3a2;finish=base+0x314
        arm(emit);arm(finish)
        while True:
            r.command('c');registers=regs();pc=registers[17]
            assert pc in (emit,finish)
            if pc==finish:break
            pointer=int.from_bytes(read(registers[15],4),'big')
            original.append(string(pointer).decode('mac_roman'))
            disarm(emit);r.command('s');arm(emit)
        after=snapshot(a5)
        with tempfile.TemporaryDirectory() as temp:
            helper=Path(temp)/'size.c';helper.write_text('#include "word_enumerator.h"\nsize_t state_size(void){return sizeof(MavenWordEnumeration);}\n')
            library=Path(temp)/'enumerator.dylib'
            subprocess.run(['cc','-std=c99','-Wall','-Wextra','-Werror','-dynamiclib',
                            '-I','reconstruction',str(helper),'reconstruction/word_enumerator.c',
                            'reconstruction/dictionary_lookup.c','-o',str(library)],check=True)
            lib=C.CDLL(str(library));lib.state_size.restype=C.c_size_t
            assert lib.state_size()==C.sizeof(State)
            state=State();section_array=(Section*(len(sections)+1))(*sections,Section(None,0))
            state.sections=section_array;string_buffers=[]
            for name,value in before.items():
                if name in ('available','required_counts','occurrences'):
                    getattr(state,name)[:]=value
                elif name in ('prefix','suffix','required_letters'):
                    buffer=C.create_string_buffer(bytes.fromhex(value));string_buffers.append(buffer)
                    setattr(state,name,C.addressof(buffer))
                elif name=='word':state.word[:]=bytes.fromhex(value)
                else:setattr(state,name,value)
            expected=[]
            callback=Append(lambda user,word:expected.append(C.string_at(word).decode('mac_roman')))
            state.append_word=callback
            fn=lib.maven_enumerate_section;fn.argtypes=[C.POINTER(State)];fn.restype=None
            for index in range(len(sections)):
                state.current_section=index;fn(C.byref(state))
            reconstructed={name:list(getattr(state,name)) for name in ('available','required_counts','occurrences')}
            reconstructed.update({name:getattr(state,name) for name in ('blanks_used','minimum_length','maximum_length','result_count','suffix_length','length')})
            reconstructed['word']=bytes(state.word).hex()
            for name in ('prefix','suffix','required_letters'):reconstructed[name]=before[name]
        report=dict(code12_base=base,code12_sha256=hashlib.sha256(code).hexdigest(),code12_exact_match=True,
                    a5=a5,tables=table_records,before=before,after=after,reconstructed_after=reconstructed,
                    original_words=original,reconstructed_words=expected,word_order_matches=original==expected,
                    final_state_matches=after==reconstructed,
                    scope='One natural normal enumeration; core state and exact emission order; UI storage/rendering external')
        args.output.parent.mkdir(parents=True,exist_ok=True);args.output.write_text(json.dumps(report,indent=2)+'\n')
        print(json.dumps({k:report[k] for k in ('original_words','reconstructed_words','word_order_matches','final_state_matches')},indent=2))
        assert original==expected and after==reconstructed
    finally:
        command('stop')
        for address in points:r.command(f'z0,{address:x},2')
        r.close()


if __name__=='__main__':main()
