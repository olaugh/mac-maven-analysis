#!/usr/bin/env python3
"""Capture state after normal Open of a saved game. Leaves the VM paused."""
import argparse
import hashlib
import json
from pathlib import Path
import re
import struct
from gdb_remote import Remote
from qmp_session import command

def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--output',type=Path,required=True)
    args=p.parse_args();command('stop');r=Remote();r.sock.settimeout(60);points=set()
    def read(a,n):return b''.join(bytes.fromhex(r.command(f'm{a+i:x},{min(4096,n-i):x}')) for i in range(0,n,4096))
    def regs():return struct.unpack('>18I',bytes.fromhex(r.command('g')))
    def run(a):
        assert r.command(f'Z0,{a:x},2')=='OK';points.add(a);r.command('c');assert regs()[17]==a
        assert r.command(f'z0,{a:x},2')=='OK';points.remove(a)
    try:
        r.command('?');assert read(0x40800000,16).hex()=='f1acad130000002a067c4efa00804efa'
        xml=r.command('qXfer:features:read:m68k-core.xml:0,fff')
        assert re.findall(r'<reg name="([^"]+)"',xml)==[f'd{i}' for i in range(8)]+[f'a{i}' for i in range(6)]+['fp','sp','ps','pc']
        a5=int.from_bytes(read(0x904,4),'big');slot=a5+0x5aa
        print('Waiting for normal saved-game Open',flush=True);run(slot);stub=read(slot,6)
        if stub==bytes.fromhex('3f3c0016a9f0'):
            r.command('s');r.command('s');run(slot);stub=read(slot,6)
        assert stub[:2]==bytes.fromhex('4ef9');base=int.from_bytes(stub[2:],'big')-0x2cc
        code=Path('resources/CODE/22_22.bin').read_bytes();assert read(base,len(code))==code
        run(base+0x2cc);caller,volume,nameptr=struct.unpack('>IhI',read(regs()[15],10))
        name=read(nameptr+1,read(nameptr,1)[0]).decode('mac_roman');run(caller)
        identities=[]
        for rid,slot_offset,offset in [(7,0x162,4),(31,0x942,0x184)]:
            stub=read(a5+slot_offset,6);assert stub[:2]==bytes.fromhex('4ef9')
            b=int.from_bytes(stub[2:],'big')-offset;c=Path(f'resources/CODE/{rid}_{rid}.bin').read_bytes()
            assert read(b,len(c))==c;identities.append(dict(code_resource=rid,base=b,sha256=hashlib.sha256(c).hexdigest()))
        state={name:read(a5-d,n).hex() for name,d,n in [('board',0x4302,544),('values',0x40e2,1088),
               ('rack0',0x3c9a,8),('rack1',0x3ca2,8),('counts',0x5ab2,128),('undo',0xaca,33),('letter_values',0x6bee,256)]}
        state['totals']=[int.from_bytes(read(a5-d,4),'big',signed=True) for d in (0x3c8e,0x3c92)]
        state['row_zero_count']=int.from_bytes(read(a5-0x4c0e,2),'big',signed=True)
        state['selected_rack']=int.from_bytes(read(a5-0x3c8a,4),'big')-a5
        report=dict(scope='Natural saved-game Open; verified loaded CODE22/7/31; post-reader-return state, no argument or data injection',
                    name=name,volume=volume,a5=a5,return_value=regs()[0]&65535,code22_sha256=hashlib.sha256(code).hexdigest(),
                    identities=identities,state=state)
        args.output.write_text(json.dumps(report,indent=2)+'\n');print(json.dumps({k:v for k,v in report.items() if k!='state'},indent=2))
    finally:
        command('stop')
        for a in points:r.command(f'z0,{a:x},2')
        r.close()

if __name__=='__main__':main()
