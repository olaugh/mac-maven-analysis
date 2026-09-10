#!/usr/bin/env python3
"""Capture natural pattern lookups at the shared construction/lookup boundary."""
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
        a5=int.from_bytes(read(0x904,4),'big');stub=read(a5+0x98a,6);assert stub[:2]==bytes.fromhex('4ef9');base=int.from_bytes(stub[2:],'big')-4
        code=Path('resources/CODE/32_32.bin').read_bytes();assert read(base+0x16c0,0x224)==code[0x16c0:0x18e4]
        cache=int.from_bytes(read(a5-0x98c,4),'big');count=int.from_bytes(read(a5-0x97e,2),'big',signed=True);assert cache and 0<count<9842
        entries=[]
        for i in range(count):
            pointer,accumulator,index=struct.unpack('>IIh',read(cache+10*i,10));letters=read(pointer,64).split(b'\0')[0].decode('ascii')
            entries.append(dict(letters=letters,accumulator=accumulator,table_index=index))
        table=int.from_bytes(read(a5-0x2a9c,4),'big');size=28*(1+max(e['table_index'] for e in entries));raw=b''.join(read(table+i,min(2048,size-i)) for i in range(0,size,2048))
        calls=[];print('Capturing 64 natural pattern lookups',flush=True)
        for i in range(64):
            if regs()[17]!=base+0x1872:run(base+0x1872)
            frame=regs()[14];caller,query,out=struct.unpack('>III',read(frame+4,12));letters=read(query,64).split(b'\0')[0].decode('ascii')
            run(caller);pointer=int.from_bytes(read(out,4),'big');index=None
            if pointer:assert (pointer-cache-4)%10==0;index=(pointer-cache-4)//10;assert 0<=index<count
            score=regs()[0]&65535;score=score if score<32768 else score-65536
            calls.append(dict(letters=letters,score=score,entry_index=index))
        report=dict(scope='64 original lookups during normal first-game engine execution; exact CODE32 construction/lookup range; no debugger memory injection',code32_sha256=hashlib.sha256(code).hexdigest(),entries=entries,score_records=raw.hex(),calls=calls)
        a.output.write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(dict(calls=len(calls),hits=sum(c['entry_index'] is not None for c in calls),zero_score_hits=sum(c['entry_index'] is not None and c['score']==0 for c in calls)),indent=2))
    finally:
        command('stop')
        for addr in points:r.command(f'z0,{addr:x},2')
        r.close()
if __name__=='__main__':main()
