#!/usr/bin/env python3
"""Capture one natural CODE32 composition calculation with its table inputs."""
import argparse,hashlib,json,re,struct
from pathlib import Path
from gdb_remote import Remote
from qmp_session import command

def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--output',type=Path,required=True);p.add_argument('--loaded-direct',action='store_true');a=p.parse_args()
    command('stop');r=Remote();r.sock.settimeout(60);points=set()
    def read(addr,n):return bytes.fromhex(r.command(f'm{addr:x},{n:x}'))
    def regs():return struct.unpack('>18I',bytes.fromhex(r.command('g')))
    def run(addr):
        assert r.command(f'Z0,{addr:x},2')=='OK';points.add(addr);r.command('c');assert regs()[17]==addr
        assert r.command(f'z0,{addr:x},2')=='OK';points.remove(addr)
    try:
        r.command('?');assert read(0x40800000,16).hex()=='f1acad130000002a067c4efa00804efa'
        xml=r.command('qXfer:features:read:m68k-core.xml:0,fff')
        assert re.findall(r'<reg name="([^"]+)"',xml)==[f'd{i}' for i in range(8)]+[f'a{i}' for i in range(6)]+['fp','sp','ps','pc']
        a5=int.from_bytes(read(0x904,4),'big');code0=Path('resources/CODE/0_0.bin').read_bytes();slots={}
        for i in range((len(code0)-16)//8):
            offset,push,rid,trap=struct.unpack_from('>4H',code0,16+8*i)
            if rid==32:slots[a5+34+8*i]=offset+4
        if a.loaded_direct:
            slot=next(address for address in slots if read(address,2)==bytes.fromhex('4ef9'))
            print('Waiting for next direct composition call',flush=True)
        else:
            print('Waiting for first natural CODE32 entry before composition cache warms',flush=True)
            for address in slots:
                assert r.command(f'Z0,{address:x},2')=='OK';points.add(address)
            r.command('c');slot=regs()[17];assert slot in slots
            for address in list(points):assert r.command(f'z0,{address:x},2')=='OK';points.remove(address)
        stub=read(slot,6)
        if stub==bytes.fromhex('3f3c0020a9f0'):
            r.command('s');r.command('s');run(slot);stub=read(slot,6)
        assert stub[:2]==bytes.fromhex('4ef9');base=int.from_bytes(stub[2:],'big')-slots[slot]
        code=Path('resources/CODE/32_32.bin').read_bytes();assert read(base+0xdb0,0xefa-0xdb0)==code[0xdb0:0xefa]
        run(base+0xdb0);caller,*args=struct.unpack('>I5h',read(regs()[15],14));total=args[4];assert 0<=total<=7
        table=int.from_bytes(read(a5-0x2a94+total*4,4),'big');raw=read(table,24+28*total+4)
        terminal=[int.from_bytes(raw[24+28*i:28+28*i],'big') for i in range(total+1)]
        run(caller);result=regs()[0]
        report=dict(scope='One natural composition call; exact CODE32[0xdb0,0xefa) and ROM/register identity; no game-data injection; tables supplied by original runtime',a5=a5,code32_sha256=hashlib.sha256(code).hexdigest(),verified_range_sha256=hashlib.sha256(code[0xdb0:0xefa]).hexdigest(),args=args,table_address=table,raw_table=raw.hex(),terminal_scores=terminal,result_bits=result)
        a.output.write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(dict(args=args,result_bits=result),indent=2))
    finally:
        command('stop')
        for addr in points:r.command(f'z0,{addr:x},2')
        r.close()
if __name__=='__main__':main()
