#!/usr/bin/env python3
"""Trace CODE 15's natural startup file check after capture_startup.

The prior capture leaves Maven paused before main. Catch its A5 stub, allow
LoadSeg to resolve it, verify all loaded bytes, then observe calls and return.
"""
import argparse
import hashlib
import json
from pathlib import Path
import re
import struct
from gdb_remote import Remote
from qmp_session import command


def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--data-file',type=Path,required=True)
    p.add_argument('--output',type=Path,required=True)
    args=p.parse_args()
    before=args.data_file.read_bytes()
    command('stop');r=Remote();points=set()
    def read(address,count):
        return bytes.fromhex(r.command(f'm{address:x},{count:x}'))
    def registers():
        return struct.unpack('>18I',read_regs())
    def read_regs():
        return bytes.fromhex(r.command('g'))
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
        regs=registers();a5=regs[13]
        slot=a5+0x30a
        arm(slot);r.command('c');regs=registers()
        assert regs[17]==slot;disarm(slot)
        stub=read(slot,6)
        if stub==bytes.fromhex('3f3c000fa9f0'):
            r.command('s') # PUSH segment number.
            r.command('s') # Enter the original LoadSeg trap handler.
            arm(slot);r.command('c');regs=registers()
            assert regs[17]==slot;disarm(slot)
            stub=read(slot,6)
        assert stub[:2]==b'\x4e\xf9','LoadSeg did not resolve CODE 15 startup slot'
        base=int.from_bytes(stub[2:],'big')-0x4d2
        code=Path('resources/CODE/15_15.bin').read_bytes()
        assert read(base,len(code))==code
        entry=base+0xd4c;arm(entry);r.command('c')
        regs=registers();assert regs[17]==entry;disarm(entry)
        entry_sp=regs[15]
        caller,name_pointer,volume=struct.unpack('>IIh',read(entry_sp,10))
        name=read(name_pointer+1,read(name_pointer,1)[0]).decode('mac_roman')
        assert name==args.data_file.name
        stages={0xd6a:'FSOpen',0xd80:'GetEOF',0xd9a:'FSRead',
                0xdbc:'FSWrite',0xdd2:'SetEOF',0xde4:'FSClose'}
        for offset in stages:arm(base+offset)
        arm(caller)
        rows=[]
        while True:
            r.command('c');regs=registers();pc=regs[17]
            assert pc in points;disarm(pc)
            if pc==caller:break
            offset=pc-base;fp=regs[14]
            row=dict(operation=stages[offset],resource_offset=offset,
                     result=struct.unpack('>h',read(regs[15],2))[0],
                     file_refnum=struct.unpack('>h',read(fp-38,2))[0])
            if offset>=0xd80:row['original_eof']=int.from_bytes(read(fp-42,4),'big')
            if offset>=0xd9a:
                count=int.from_bytes(read(fp-36,4),'big');row['count']=count
                row['buffer_hex']=read(fp-32,min(count,32)).hex() if count else ''
            rows.append(row)
        after=args.data_file.read_bytes()
        result=struct.unpack('>h',struct.pack('>H',regs[0]&0xffff))[0]
        report=dict(code15_base=base,code15_exact_match=True,
                    code15_sha256=hashlib.sha256(code).hexdigest(),a5=a5,
                    filename=name,filename_pointer=name_pointer,volume_reference=volume,
                    calls=rows,return_value=result,stack_advance=regs[15]-entry_sp,
                    data_bytes=len(after),before_sha256=hashlib.sha256(before).hexdigest(),
                    after_sha256=hashlib.sha256(after).hexdigest(),data_unchanged=before==after,
                    scope='Natural startup success path; no argument/register/memory injection')
        args.output.parent.mkdir(parents=True,exist_ok=True)
        args.output.write_text(json.dumps(report,indent=2)+'\n')
        print(json.dumps(report,indent=2))
    finally:
        command('stop')
        for address in points:r.command(f'z0,{address:x},2')
        r.close()


if __name__=='__main__':
    main()
