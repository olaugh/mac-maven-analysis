#!/usr/bin/env python3
"""Observe a normal Save action. Start while Maven is idle, then use guest UI."""
import argparse
import hashlib
import json
import re
from pathlib import Path
import struct
from gdb_remote import Remote
from qmp_session import command

def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--output',type=Path,required=True)
    args=p.parse_args();command('stop');r=Remote();r.sock.settimeout(60);points=set()
    def read(a,n):return b''.join(bytes.fromhex(r.command(f'm{a+i:x},{min(4096,n-i):x}')) for i in range(0,n,4096))
    def regs():return struct.unpack('>18I',bytes.fromhex(r.command('g')))
    def arm(a):assert r.command(f'Z0,{a:x},2')=='OK';points.add(a)
    def remove(a):assert r.command(f'z0,{a:x},2')=='OK';points.remove(a)
    def run(a):arm(a);r.command('c');assert regs()[17]==a;remove(a)
    try:
        r.command('?');assert read(0x40800000,16).hex()=='f1acad130000002a067c4efa00804efa'
        xml=r.command('qXfer:features:read:m68k-core.xml:0,fff')
        assert re.findall(r'<reg name="([^"]+)"',xml)==[f'd{i}' for i in range(8)]+[f'a{i}' for i in range(6)]+['fp','sp','ps','pc']
        a5=int.from_bytes(read(0x904,4),'big');slot=a5+0x5a2
        print('Waiting for normal Save action',flush=True);run(slot);stub=read(slot,6)
        if stub==bytes.fromhex('3f3c0016a9f0'):
            r.command('s');r.command('s');run(slot);stub=read(slot,6)
        assert stub[:2]==bytes.fromhex('4ef9');base=int.from_bytes(stub[2:],'big')-0x166
        code=Path('resources/CODE/22_22.bin').read_bytes();assert read(base,len(code))==code
        run(base+0x166);g=regs();caller,volume,nameptr=struct.unpack('>IhI',read(g[15],10))
        name=read(nameptr+1,read(nameptr,1)[0]).decode('mac_roman')
        writes=[];results=[];mutations=[]
        for off in (0x220,0x224,0x246,0x24a,0x252,0x278,0x27c,0x28e,0x2a0):arm(base+off)
        arm(caller)
        while True:
            r.command('c');g=regs();pc=g[17];assert pc in points
            if pc==caller:remove(pc);break
            off=pc-base;remove(pc)
            if off in (0x220,0x246,0x278):
                ptr,countptr,ref=struct.unpack('>IIh',read(g[15],10));count=struct.unpack('>i',read(countptr,4))[0]
                assert 0<=count<=65535
                writes.append(dict(offset=off,reference=ref,count=count,bytes_hex=read(ptr,count).hex()))
            elif off in (0x252,0x28e):
                tag=struct.unpack('>h',read(g[14]-4,2))[0]
                if tag==1:mutations.append(dict(offset=off,word_hex=read(g[10]+4,2).hex()))
            else:results.append(dict(offset=off,error=struct.unpack('>h',read(g[15],2))[0]))
            r.command('s');arm(pc)
        report=dict(scope='Natural Save UI action; original code identity and FSWrite inputs/results observed',
                    a5=a5,code22_base=base,code22_sha256=hashlib.sha256(code).hexdigest(),
                    complete_loaded_code_matches=True,name=name,volume=volume,writes=writes,results=results,
                    return_value=g[0]&65535,tag1_mutations=mutations)
        args.output.write_text(json.dumps(report,indent=2)+'\n');print(json.dumps({k:v for k,v in report.items() if k!='writes'},indent=2))
    finally:
        command('stop')
        for a in points:r.command(f'z0,{a:x},2')
        r.close()

if __name__=='__main__':main()
