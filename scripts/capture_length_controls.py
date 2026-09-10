#!/usr/bin/env python3
"""Observe a natural Word List length read; submit the query via the guest UI.

Stops before/after its two sscanf calls and at final control return. Never
writes arguments, registers or application memory. Leaves the guest paused.
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


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output',type=Path,required=True)
    args=parser.parse_args()
    command('stop'); r=Remote(); r.sock.settimeout(60); points=set()
    def read(address,count):
        return b''.join(bytes.fromhex(r.command(f'm{address+i:x},{min(4096,count-i):x}'))
                        for i in range(0,count,4096))
    def regs(): return struct.unpack('>18I',bytes.fromhex(r.command('g')))
    def word(address): return struct.unpack('>h',read(address,2))[0]
    def string(address):
        out=bytearray()
        for i in range(256):
            byte=read(address+i,1)[0]
            if not byte:return bytes(out)
            out.append(byte)
        raise ValueError('Unterminated field')
    def arm(address):
        assert r.command(f'Z0,{address:x},2')=='OK'; points.add(address)
    def disarm(address):
        assert r.command(f'z0,{address:x},2')=='OK'; points.remove(address)
    def run_to(address):
        arm(address); r.command('c'); assert regs()[17]==address; disarm(address)
    try:
        r.command('?')
        assert read(0x40800000,16).hex()=='f1acad130000002a067c4efa00804efa'
        xml=r.command('qXfer:features:read:m68k-core.xml:0,fff')
        assert re.findall(r'<reg name="([^"]+)"',xml)==([f'd{i}' for i in range(8)]+[f'a{i}' for i in range(6)]+['fp','sp','ps','pc'])
        a5=int.from_bytes(read(0x904,4),'big'); stub=read(a5+0x232,6)
        if stub[:2]==b'\x4e\xf9':base=int.from_bytes(stub[2:],'big')-0x686
        else:
            slots={a5+0x242:0x66e,a5+0x24a:0x67a}
            for slot in slots:arm(slot)
            print('Waiting for Word List action',flush=True);r.command('c')
            slot=regs()[17];assert slot in slots
            for point in list(points):disarm(point)
            stub=read(slot,6)
            if stub==bytes.fromhex('3f3c000ca9f0'):
                r.command('s');r.command('s');run_to(slot);stub=read(slot,6)
            assert stub[:2]==b'\x4e\xf9'
            base=int.from_bytes(stub[2:],'big')-slots[slot]
        code=Path('resources/CODE/12_12.bin').read_bytes();assert read(base,len(code))==code
        rows=[]
        print('Length parser breakpoints ready',flush=True)
        for before,after in [(0x852,0x856),(0x878,0x87c)]:
            run_to(base+before);sp=regs()[15]
            text,fmt,destination=struct.unpack('>III',read(sp,12))
            assert string(fmt)==b'%d'
            row=dict(text_hex=string(text).hex(),initial_value=word(destination),
                     errno_before=word(a5-0xbc0),call_offset=before)
            classes=read(a5-0x428,256)
            run_to(base+after)
            row.update(value=word(destination),errno_after=word(a5-0xbc0),
                       return_value=C.c_int16(regs()[0]&65535).value)
            stub=read(a5+0x81a,6);assert stub[:2]==b'\x4e\xf9'
            scanner_base=int.from_bytes(stub[2:],'big')-0x16fa
            scanner=Path('resources/CODE/24_24.bin').read_bytes()
            assert read(scanner_base,len(scanner))==scanner
            row['character_classes_hex']=classes.hex();rows.append(row)
        run_to(base+0x890)
        limits=[word(a5-0x25e8),word(a5-0x25e6)]
        with tempfile.TemporaryDirectory() as temp:
            library=Path(temp)/'scan.dylib'
            subprocess.run(['cc','-std=c99','-Wall','-Wextra','-Werror','-dynamiclib',
                            'reconstruction/decimal_scan.c','-o',str(library)],check=True)
            lib=C.CDLL(str(library));fn=lib.maven_scan_decimal_word
            fn.argtypes=[C.c_char_p,C.POINTER(C.c_int16),C.POINTER(C.c_int16),C.c_char_p]
            fn.restype=C.c_int16
            for row in rows:
                value=C.c_int16(row['initial_value']);error=C.c_int16(row['errno_before'])
                result=fn(bytes.fromhex(row['text_hex']),C.byref(value),C.byref(error),bytes.fromhex(row['character_classes_hex']))
                row['reconstructed']=[result,value.value,error.value]
                row['matches']=row['reconstructed']==[row['return_value'],row['value'],row['errno_after']]
        expected=[rows[0]['value'],rows[1]['value']]
        if expected[1]<expected[0]:expected[1]=15
        report=dict(a5=a5,code12_base=base,code12_sha256=hashlib.sha256(code).hexdigest(),
                    code24_base=scanner_base,code24_sha256=hashlib.sha256(scanner).hexdigest(),
                    complete_loaded_code_matches=True,calls=rows,limits=limits,
                    expected_limits=expected,limits_match=limits==expected,
                    reconstruction_sha256=hashlib.sha256(Path('reconstruction/decimal_scan.c').read_bytes()).hexdigest(),
                    scope='Natural UI length-control calls; no guest call/argument/register injection')
        args.output.write_text(json.dumps(report,indent=2)+'\n')
        print(json.dumps(dict(calls=rows,limits=limits,limits_match=limits==expected),indent=2))
        assert all(row['matches'] for row in rows) and limits==expected
    finally:
        command('stop')
        for point in points:r.command(f'z0,{point:x},2')
        r.close()


if __name__=='__main__':main()
