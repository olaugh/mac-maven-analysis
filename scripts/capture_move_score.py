#!/usr/bin/env python3
"""Capture one natural CODE32 move-score call, without changing arguments."""
import argparse,hashlib,json,re,struct
from pathlib import Path
from gdb_remote import Remote
from qmp_session import command

def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--output',type=Path,required=True);p.add_argument('--application-state',action='store_true');a=p.parse_args()
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
        a5=int.from_bytes(read(0x904,4),'big');slot=a5+0x98a
        print('Waiting for natural move score',flush=True);run(slot);stub=read(slot,6)
        if stub==bytes.fromhex('3f3c0020a9f0'):
            r.command('s');r.command('s');run(slot);stub=read(slot,6)
        assert stub[:2]==bytes.fromhex('4ef9');base=int.from_bytes(stub[2:],'big')-4
        code=Path('resources/CODE/32_32.bin').read_bytes();assert read(base,len(code))==code
        run(base+4);caller,move,rack,out=struct.unpack('>4I',read(regs()[15],16))
        before={name:read(a5-d,n).hex() for name,d,n in [('board',0x4302,544),('values',0x40e2,1088),('word_multipliers',0x684e,544),('letter_multipliers',0x6a6e,544),('letter_values',0x6bee,256),('letter_class',0x428,128)]}
        before['move']=read(move,34).hex();before['rack']=read(rack,8).hex();before['alphabet']=read(int.from_bytes(read(a5-0x662e,4),'big'),28).hex()
        run(caller);result=dict(score_bits=regs()[0],remaining_rack=read(out,8).hex(),new_tiles=int.from_bytes(read(a5-0x4e2a,2),'big',signed=True),zero_value_row=[int.from_bytes(read(a5-d,2),'big',signed=True) for d in (0x430a,0x430c)],zero_value_column=[int.from_bytes(read(a5-d,2),'big',signed=True) for d in (0x4306,0x4308)])
        report=dict(scope='One natural CODE32 scoring invocation; full loaded resource match and ROM/register handshake; no state/argument injection',a5=a5,code32_sha256=hashlib.sha256(code).hexdigest(),initial=before,result=result)
        if a.application_state:
            stub31=read(a5+0x942,6);assert stub31[:2]==bytes.fromhex('4ef9')
            base31=int.from_bytes(stub31[2:],'big')-0x184
            code31=Path('resources/CODE/31_31.bin').read_bytes();assert read(base31,len(code31))==code31
            assert caller==base31+0x2cc
            run(base31+0x63a)
            report['application_code31_sha256']=hashlib.sha256(code31).hexdigest()
            report['application_state']={name:read(a5-d,n).hex() for name,d,n in [('board',0x4302,544),('values',0x40e2,1088),('undo',0xaca,33),('counts',0x5ab2,128)]}
            report['application_state'].update(rack=read(rack,8).hex(),row_zero_count=int.from_bytes(read(a5-0x4c0e,2),'big',signed=True),new_tiles=int.from_bytes(read(a5-0x4e2a,2),'big',signed=True))
        a.output.write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(result,indent=2))
    finally:
        command('stop')
        for addr in points:r.command(f'z0,{addr:x},2')
        r.close()
if __name__=='__main__':main()
