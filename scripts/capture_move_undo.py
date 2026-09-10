#!/usr/bin/env python3
"""Capture one naturally invoked CODE31 undo helper, including all affected state."""
import argparse,hashlib,json,re,struct
from pathlib import Path
from gdb_remote import Remote
from qmp_session import command

def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--output',type=Path,required=True);a=p.parse_args()
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
        a5=int.from_bytes(read(0x904,4),'big');slot=a5+0x94a
        print('Waiting for natural move undo',flush=True);run(slot);stub=read(slot,6)
        if stub==bytes.fromhex('3f3c001fa9f0'):
            r.command('s');r.command('s');run(slot);stub=read(slot,6)
        assert stub[:2]==bytes.fromhex('4ef9');base=int.from_bytes(stub[2:],'big')-0x642
        code=Path('resources/CODE/31_31.bin').read_bytes();assert read(base,len(code))==code
        run(base+0x642);caller,rack=struct.unpack('>2I',read(regs()[15],8))
        def state():
            data={name:read(a5-d,n).hex() for name,d,n in [('board',0x4302,544),('values',0x40e2,1088),('undo',0xaca,33),('counts',0x5ab2,128)]}
            data['rack']=read(rack,8).hex();data['row_zero_count']=int.from_bytes(read(a5-0x4c0e,2),'big',signed=True)
            return data
        before=state();run(caller);after=state()
        report=dict(scope='One naturally invoked CODE31 undo helper; full loaded resource match and ROM/register handshake; no state/argument injection; not necessarily a user Undo command',a5=a5,caller_address=caller,code31_sha256=hashlib.sha256(code).hexdigest(),initial=before,result=after)
        a.output.write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(dict(undo=before['undo'],rack_before=before['rack'],rack_after=after['rack']),indent=2))
    finally:
        command('stop')
        for addr in points:r.command(f'z0,{addr:x},2')
        r.close()
if __name__=='__main__':main()
