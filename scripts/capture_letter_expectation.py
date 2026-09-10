#!/usr/bin/env python3
"""Capture original letter expectation inputs and results."""
import argparse,hashlib,json,re,struct
from pathlib import Path
from gdb_remote import Remote
from qmp_session import command

def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--output',type=Path,required=True);p.add_argument('--count',type=int,default=24);a=p.parse_args()
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
        if any(read(address,2)==bytes.fromhex('4ef9') for address in slots):
            slot=next(address for address in slots if read(address,2)==bytes.fromhex('4ef9'))
            print('Waiting for next direct pattern call',flush=True)
        else:
            print('Waiting for first natural CODE35 entry before pattern cache warms',flush=True)
            for address in slots:
                assert r.command(f'Z0,{address:x},2')=='OK';points.add(address)
            r.command('c');slot=regs()[17];assert slot in slots
            for address in list(points):assert r.command(f'z0,{address:x},2')=='OK';points.remove(address)
        stub=read(slot,6)
        if stub==bytes.fromhex('3f3c0020a9f0'):
            r.command('s');r.command('s');run(slot);stub=read(slot,6)
        assert stub[:2]==bytes.fromhex('4ef9');base=int.from_bytes(stub[2:],'big')-slots[slot]
        code=Path('resources/CODE/32_32.bin').read_bytes();start,end=0x140a,0x164c;live=read(base+start,end-start)
        fingerprint=json.loads(Path('analysis/toolchain/floating-trap-rewrites-live.json').read_text());previous=next(x for x in fingerprint['resources'] if x['code_resource']==32);patched=bytearray(code)
        assert previous['source_sha256']==hashlib.sha256(code).hexdigest()
        for change in previous['differences']:
            assert patched[change['offset']]==change['original'];patched[change['offset']]=change['live']
        assert live in (code[start:end],bytes(patched[start:end]))
        calls=[];print('Capturing natural letter expectations',flush=True)
        for _ in range(a.count):
            run(base+start);caller,letter,total,count=struct.unpack('>I3h',read(regs()[15],10))
            scores=None
            if total>=7:
                index=0 if letter==63 else letter-96;assert 0<=index<=26
                table=int.from_bytes(read(a5-0x2a74+4*index,4),'big');raw=read(table,224);scores=[int.from_bytes(raw[24+28*i:28+28*i],'big') for i in range(8)]
            run(caller);bits=regs()[0];calls.append(dict(letter=letter,total=total,letter_count=count,scores=scores,result_bits=bits))
        report=dict(scope='Natural original letter expectation calls; executed resource range matches source or exact previously captured FP-rewrite fingerprint; ROM/register identity; no memory injection. Rewrite semantics and alternate SANE precision environments are not independently proven.',code32_sha256=hashlib.sha256(code).hexdigest(),loaded_range_sha256=hashlib.sha256(live).hexdigest(),loaded_range=live.hex(),range=[start,end],identity='source' if live==code[start:end] else 'previous_fp_rewrite_fingerprint',calls=calls)
        a.output.write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(dict(calls=len(calls),results=[c['result_bits'] for c in calls]),indent=2))
    finally:
        command('stop')
        for addr in points:r.command(f'z0,{addr:x},2')
        r.close()
if __name__=='__main__':main()
