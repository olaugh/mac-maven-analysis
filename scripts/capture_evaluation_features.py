#!/usr/bin/env python3
"""Capture one natural evaluated move and its feature-vector inputs."""
import argparse,hashlib,json,re,struct
from pathlib import Path
from gdb_remote import Remote
from qmp_session import command

def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--output',type=Path,required=True);a=p.parse_args()
    command('stop');r=Remote();r.sock.settimeout(60);points=set()
    def read(addr,n):return b''.join(bytes.fromhex(r.command(f'm{addr+i:x},{min(4096,n-i):x}')) for i in range(0,n,4096))
    def regs():return struct.unpack('>18I',bytes.fromhex(r.command('g')))
    def run(addr):
        assert r.command(f'Z0,{addr:x},2')=='OK';points.add(addr);r.command('c');assert regs()[17]==addr
        assert r.command(f'z0,{addr:x},2')=='OK';points.remove(addr)
    try:
        r.command('?');assert read(0x40800000,16).hex()=='f1acad130000002a067c4efa00804efa'
        xml=r.command('qXfer:features:read:m68k-core.xml:0,fff')
        assert re.findall(r'<reg name="([^"]+)"',xml)==[f'd{i}' for i in range(8)]+[f'a{i}' for i in range(6)]+['fp','sp','ps','pc']
        a5=int.from_bytes(read(0x904,4),'big');slot=a5+0x942
        print(f'Waiting for natural evaluated move, A5={a5:#x}',flush=True);stub=read(slot,6)
        if stub[:2]!=bytes.fromhex('4ef9'):run(slot);stub=read(slot,6)
        if stub==bytes.fromhex('3f3c001fa9f0'):
            r.command('s');r.command('s');run(slot);stub=read(slot,6)
        assert stub[:2]==bytes.fromhex('4ef9');base=int.from_bytes(stub[2:],'big')-0x184
        code=Path('resources/CODE/31_31.bin').read_bytes();assert read(base,len(code))==code
        skipped=0
        while True:
            run(base+0x184);caller,move,rack,evaluate=struct.unpack('>3Ih',read(regs()[15],14))
            print(f'Application entry: evaluate={evaluate}, base={base:#x}',flush=True)
            if evaluate:break
            run(caller);skipped+=1;assert skipped<1000
        initial=dict(move=read(move,34).hex(),rack=read(rack,8).hex(),counts=read(a5-0x5ab2,128).hex(),vowels=read(a5-0xbca,6).hex())
        run(base+0x1b4);frame=regs()[14];ids=[];weights=[]
        initial['entry_counts']=initial['counts'];initial['counts']=read(a5-0x5ab2,128).hex()
        for i in range(512):
            value=int.from_bytes(read(frame-0x43a+i*2,2),'big')
            if not value:break
            ids.append(value);weights.append(int.from_bytes(read(frame-0x83a+i*2,2),'big'))
        else:raise AssertionError('unterminated collected IDs')
        count=int.from_bytes(read(a5-0x2aa2,2),'big',signed=True);assert 0<=count<=10000
        pointer=int.from_bytes(read(a5-0x2aa6,4),'big')
        initial.update(record_ids=ids,record_weights=weights,record_count=count,records=read(pointer,count*8).hex())
        run(base+0x534);g=regs();after=dict(counts=read(a5-0x5ab2,128).hex(),occupied_before=g[5]&65535,special_score=g[6]&65535,scored_remaining=read(frame-0x32,16).hex())
        after['record_count']=int.from_bytes(read(a5-0x2aa2,2),'big',signed=True);assert 0<=after['record_count']<=10000
        after['records']=read(int.from_bytes(read(a5-0x2aa6,4),'big'),after['record_count']*8).hex()
        run(base+0x63a);features=list(struct.unpack('>22I',read(a5-0x5bc0,88)))
        identities=[]
        for rid,offset,target in [(35,0x9e2,0x36c),(23,0x7d2,4),(32,0x98a,4)]:
            stub=read(a5+offset,6);assert stub[:2]==bytes.fromhex('4ef9');b=int.from_bytes(stub[2:],'big')-target
            c=Path(f'resources/CODE/{rid}_{rid}.bin').read_bytes();live=read(b,len(c))
            start,end=(0x36c,len(c)) if rid==35 else ((4,0x650) if rid==32 else (0,len(c)))
            assert live[start:end]==c[start:end]
            if rid==35:assert live[0x34:0x64]==c[0x34:0x64]
            identities.append(dict(code_resource=rid,sha256=hashlib.sha256(c).hexdigest(),verified_start=start,verified_end=end,verified_range_sha256=hashlib.sha256(live[start:end]).hexdigest(),whole_resource_matches=live==c,live_sha256=hashlib.sha256(live).hexdigest(),additional_verified_ranges=[dict(start=0x34,end=0x64,sha256=hashlib.sha256(live[0x34:0x64]).hexdigest())] if rid==35 else []))
        report=dict(scope='One natural evaluated candidate; Full CODE31/23 and relevant CODE35 collector/CODE32 scorer ranges match; other regions have recorded floating-trap rewrites, ROM/register handshake; no data/argument injection. Record collector remains external to replay.',a5=a5,code31_sha256=hashlib.sha256(code).hexdigest(),identities=identities,skipped_non_evaluated_calls=skipped,initial=initial,after_placement=after,features=features)
        a.output.write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(dict(record_count=len(ids),features=features),indent=2))
    finally:
        command('stop')
        for addr in points:r.command(f'z0,{addr:x},2')
        r.close()
if __name__=='__main__':main()
