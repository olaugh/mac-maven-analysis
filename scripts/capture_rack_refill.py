#!/usr/bin/env python3
"""Trace one naturally invoked rack refill; preserve all original inputs."""
import argparse,hashlib,json,re,struct
from pathlib import Path
from gdb_remote import Remote
from qmp_session import command
from maven_debug_cleanup import cleanup_breakpoints

def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--output',type=Path,required=True);p.add_argument('--opponent-sample',action='store_true');a=p.parse_args()
    command('stop');r=Remote();r.sock.settimeout(180);points=set()
    def read(addr,n):return b''.join(bytes.fromhex(r.command(f'm{addr+i:x},{min(2048,n-i):x}')) for i in range(0,n,2048))
    def regs():return struct.unpack('>18I',bytes.fromhex(r.command('g')))
    def arm(addr):assert r.command(f'Z0,{addr:x},2')=='OK';points.add(addr)
    def remove(addr):assert r.command(f'z0,{addr:x},2')=='OK';points.remove(addr)
    def run(addr):arm(addr);r.command('c');assert regs()[17]==addr;remove(addr)
    try:
        r.command('?');assert read(0x40800000,16).hex()=='f1acad130000002a067c4efa00804efa'
        xml=r.command('qXfer:features:read:m68k-core.xml:0,fff')
        assert re.findall(r'<reg name="([^"]+)"',xml)==[f'd{i}' for i in range(8)]+[f'a{i}' for i in range(6)]+['fp','sp','ps','pc']
        a5=int.from_bytes(read(0x904,4),'big');slot=a5+0x962
        sample_identity = None
        sample_before = None
        if a.opponent_sample:
            sample_stub=read(a5+0xa4a,6)
            if sample_stub==bytes.fromhex('3f3c0026a9f0'):
                print('Waiting for first original random sampler load',flush=True)
                run(a5+0xa4a);r.command('s');r.command('s');run(a5+0xa4a);sample_stub=read(a5+0xa4a,6)
            assert sample_stub[:2]==bytes.fromhex('4ef9')
            sample_base=int.from_bytes(sample_stub[2:],'big')-0xe
            sample_code=Path('resources/CODE/38_38.bin').read_bytes();assert read(sample_base,len(sample_code))==sample_code
            print('Waiting for next original random opponent sample',flush=True)
            run(sample_base+0x12)
            sample_before={name:read(a5-d,n).hex() for name,d,n in [('board',0x4302,544),('rack0',0x3c9a,8),('rack1',0x3ca2,8)]}
            sample_before['sample']=read(regs()[14]-8,8).hex()
            sample_identity=dict(code_resource=38,sha256=hashlib.sha256(sample_code).hexdigest())
        print('Waiting for natural rack refill',flush=True);run(slot);stub=read(slot,6)
        if stub==bytes.fromhex('3f3c001fa9f0'):
            r.command('s');r.command('s');run(slot);stub=read(slot,6)
        assert stub[:2]==bytes.fromhex('4ef9');base=int.from_bytes(stub[2:],'big')-0x7e0
        code=Path('resources/CODE/31_31.bin').read_bytes();assert read(base,len(code))==code
        run(base+0x7e0);rackptr=int.from_bytes(read(regs()[15]+4,4),'big')
        initial={name:read(a5-d,n).hex() for name,d,n in [('board',0x4302,544),('values',0x40e2,1088),('distribution',0x6aee,128),('rack0',0x3c9a,8),('rack1',0x3ca2,8)]}
        alphabetptr=int.from_bytes(read(a5-0x662e,4),'big');initial['alphabet']=read(alphabetptr,28).hex()
        initial['private_seed']=int.from_bytes(read(a5-0xdc4,4),'big');initial['rack']=read(rackptr,8).hex()
        run(base+0x7f4);g=regs();frame=g[14];length=g[0];assert length<=127
        initial['bag']=read(frame-0x80,length).hex();initial['stack_ticks']=int.from_bytes(read(frame-0x84,4),'big')
        events=[];offsets=[0x810,0x824,0x82c,0x852,0x866,0x86c,0x8b4]
        for offset in offsets:arm(base+offset)
        while True:
            r.command('c');g=regs();offset=g[17]-base;assert offset in offsets
            if offset==0x8b4:break
            event=dict(offset=offset)
            if offset in (0x810,0x852):event.update(kind='ticks',value=int.from_bytes(read(frame-(0x84 if offset==0x810 else 0x88),4),'big'))
            elif offset in (0x824,0x866):event.update(kind='private_random',value=g[0])
            else:event.update(kind='toolbox_random',value=g[0]&65535)
            events.append(event);assert len(events)<10000
            remove(base+offset);r.command('s');arm(base+offset)
        final=dict(rack=read(rackptr,8).hex(),board=read(a5-0x4302,544).hex(),private_seed=int.from_bytes(read(a5-0xdc4,4),'big'),bag_workspace=read(frame-0x80,length).hex())
        identities=[sample_identity] if sample_identity else []
        for rid,slot_offset,offset in [(4,0x5b2,4),(9,0x6e2,0x6e),(1,0x52,0x144)]:
            stub=read(a5+slot_offset,6);assert stub[:2]==bytes.fromhex('4ef9');b=int.from_bytes(stub[2:],'big')-offset
            c=Path(f'resources/CODE/{rid}_{rid}.bin').read_bytes();assert read(b,len(c))==c
            identities.append(dict(code_resource=rid,sha256=hashlib.sha256(c).hexdigest()))
        report=dict(scope='One natural refill, debugger pauses affect timing; full loaded CODE31/4/9/1 identities checked; no game input injection',a5=a5,code31_sha256=hashlib.sha256(code).hexdigest(),identities=identities,initial=initial,events=events,final=final)
        if a.opponent_sample:
            for addr in list(points):remove(addr)
            run(sample_base+0x3c)
            callback_stack=read(regs()[15],12)
            callback_rack=int.from_bytes(callback_stack[:4],'big');sample_weight=int.from_bytes(callback_stack[4:8],'big')
            assert callback_rack==rackptr and sample_weight==1
            report['sample_before']=sample_before
            report['sample_callback']=dict(rack=read(callback_rack,8).hex(),weight=sample_weight)
        a.output.write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(dict(event_count=len(events),rack=bytes.fromhex(final['rack']).split(b'\0')[0].decode()),indent=2))
    finally:
        cleanup=cleanup_breakpoints(r,points)
        if 'report' in locals():
            report['cleanup']=cleanup;a.output.write_text(json.dumps(report,indent=2)+'\n')
if __name__=='__main__':main()
