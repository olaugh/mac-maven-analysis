#!/usr/bin/env python3
"""Capture original adjacent-premium penalty calculations."""
import argparse,hashlib,json,re,struct
from pathlib import Path
from gdb_remote import Remote
from qmp_session import command

def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--output',type=Path,required=True);p.add_argument('--count',type=int,default=16);a=p.parse_args()
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
            if rid==35:slots[a5+34+8*i]=offset+4
        if False:
            slot=next(address for address in slots if read(address,2)==bytes.fromhex('4ef9'))
            print('Waiting for next direct pattern call',flush=True)
        else:
            print('Waiting for first natural CODE35 entry before pattern cache warms',flush=True)
            for address in slots:
                assert r.command(f'Z0,{address:x},2')=='OK';points.add(address)
            r.command('c');slot=regs()[17];assert slot in slots
            for address in list(points):assert r.command(f'z0,{address:x},2')=='OK';points.remove(address)
        stub=read(slot,6)
        if stub==bytes.fromhex('3f3c0023a9f0'):
            r.command('s');r.command('s');run(slot);stub=read(slot,6)
        assert stub[:2]==bytes.fromhex('4ef9');base=int.from_bytes(stub[2:],'big')-slots[slot]
        code=Path('resources/CODE/35_35.bin').read_bytes();assert read(base+0x3d8,0x6a6-0x3d8)==code[0x3d8:0x6a6]
        calls=[];print('Waiting for adjacent-premium calculations',flush=True)
        for attempt in range(a.count):
            run(base+0x3d8);move=int.from_bytes(read(regs()[14]+8,4),'big');raw_move=read(move,34)
            if not raw_move[32]:continue
            initial={name:read(a5-d,n).hex() for name,d,n in [('board',0x4302,544),('word_multipliers',0x684e,544),('letter_multipliers',0x6a6e,544),('letter_class',0x428,128),('penalties',0x976,80)]};initial['move']=raw_move.hex()
            run(base+0x690);bits=regs()[3];calls.append(dict(initial=initial,result_bits=bits));print(json.dumps(dict(attempt=attempt+1,move=raw_move.split(b'\0')[0].decode('ascii'),result_bits=bits)),flush=True)
            if bits:break
        report=dict(scope='Original collector subrange CODE35[0x3d8,0x6a6) observed before move application; exact code, ROM and register identity; no memory injection',code35_sha256=hashlib.sha256(code).hexdigest(),calls=calls)
        a.output.write_text(json.dumps(report,indent=2)+'\n')
    finally:
        command('stop')
        for addr in points:r.command(f'z0,{addr:x},2')
        r.close()
if __name__=='__main__':main()
