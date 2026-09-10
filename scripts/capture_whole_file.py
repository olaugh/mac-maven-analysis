#!/usr/bin/env python3
"""Observe the first natural whole-file load after capture_startup. Leaves paused."""
import argparse
import hashlib
import json
from pathlib import Path
import re
import struct
from gdb_remote import Remote
from qmp_session import command

def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--output',type=Path,required=True)
    p.add_argument('--data-file',type=Path,required=True)
    args=p.parse_args();command('stop');r=Remote();r.sock.settimeout(60);points=set()
    def read(a,n):
        return b''.join(bytes.fromhex(r.command(f'm{a+i:x},{min(4096,n-i):x}')) for i in range(0,n,4096))
    def regs():return struct.unpack('>18I',bytes.fromhex(r.command('g')))
    def arm(a):assert r.command(f'Z0,{a:x},2')=='OK';points.add(a)
    def remove(a):assert r.command(f'z0,{a:x},2')=='OK';points.remove(a)
    def run(a):arm(a);r.command('c');assert regs()[17]==a;remove(a)
    try:
        r.command('?');assert read(0x40800000,16).hex()=='f1acad130000002a067c4efa00804efa'
        xml=r.command('qXfer:features:read:m68k-core.xml:0,fff')
        assert re.findall(r'<reg name="([^"]+)"',xml)==[f'd{i}' for i in range(8)]+[f'a{i}' for i in range(6)]+['fp','sp','ps','pc']
        a5=regs()[13];slot=a5+0xd3a;run(slot);stub=read(slot,6)
        if stub==bytes.fromhex('3f3c002fa9f0'):
            r.command('s');r.command('s');run(slot);stub=read(slot,6)
        assert stub[:2]==bytes.fromhex('4ef9')
        base=int.from_bytes(stub[2:],'big')-0x25c
        code=Path('resources/CODE/47_47.bin').read_bytes();assert read(base,len(code))==code
        run(base+0x25c);sp=regs()[15]
        caller,nameptr,volume,lengthptr=struct.unpack('>IIhI',read(sp,14))
        name=read(nameptr+1,read(nameptr,1)[0]).decode('mac_roman')
        stages={0x27a:'FSOpen',0x28e:'GetEOF',0x29c:'NewPtrClear',0x2b4:'FSRead',0x2c0:'GetPtrSize',0x2d2:'FSClose'}
        for off in stages:arm(base+off)
        arm(caller);rows=[]
        while True:
            r.command('c');g=regs();pc=g[17];assert pc in points;remove(pc)
            if pc==caller:break
            off=pc-base
            row=dict(operation=stages[off],offset=off,length=int.from_bytes(read(lengthptr,4),'big'))
            if off==0x29c:row['allocation_pointer']=g[8]
            elif off==0x2c0:row['size']=int.from_bytes(read(g[15],4),'big')
            else:row['error']=struct.unpack('>h',read(g[15],2))[0]
            rows.append(row)
        length=int.from_bytes(read(lengthptr,4),'big');pointer=g[0]
        assert pointer and length<16*1024*1024
        payload=read(pointer,length+1);expected=args.data_file.read_bytes()
        report=dict(scope='Natural startup whole-file call; breakpoints and reads only',a5=a5,
                    code47_base=base,code47_sha256=hashlib.sha256(code).hexdigest(),complete_loaded_code_matches=True,
                    name=name,volume=volume,calls=rows,length=length,return_pointer=pointer,
                    trailing_byte=payload[-1],data_sha256=hashlib.sha256(payload[:-1]).hexdigest(),
                    source_sha256=hashlib.sha256(expected).hexdigest(),data_matches=payload[:-1]==expected)
        assert report['data_matches'] and payload[-1]==0
        report['caller_pc']=caller
        candidates=[]
        for rid,offset in [(2,0x108),(15,0x1e),(9,0xea)]:
            candidate=Path(f'resources/CODE/{rid}_{rid}.bin').read_bytes()
            candidate_base=caller-offset
            if read(candidate_base,len(candidate))==candidate:
                candidates.append((rid,offset,candidate_base,candidate))
        assert len(candidates)==1,'Caller must match an entire known resource'
        rid,offset,caller_base,caller_code=candidates[0]
        report['caller']=dict(code_resource=rid,resource_offset=offset,base=caller_base,
                              sha256=hashlib.sha256(caller_code).hexdigest(),complete_loaded_code_matches=True)
        if rid==2 and offset==0x108:
            outer_return=int.from_bytes(read(g[14]+4,4),'big')
            run(outer_return)
            roots=[int.from_bytes(read(a5-d,4),'big') for d in (0x218c,0x2190)]
            tables=[int.from_bytes(read(a5-d,4),'big') for d in (0x2194,0x2198)]
            expected_roots=[int.from_bytes(payload[a:a+4],'big') for a in (4,8)]
            assert roots==expected_roots
            assert tables==[pointer+12,pointer+116+4*roots[0]]
            assert all(read(t+4*i+3,1)==b'a' for t,i in zip(tables,roots))
            report['dictionary_setup']=dict(roots=roots,tables=tables,root_records_hex=[read(t+4*i,4).hex() for t,i in zip(tables,roots)])
        if rid==15 and offset==0x1e:
            fp=g[14];index_pointer=int.from_bytes(read(fp+12,4),'big')
            outer_return=int.from_bytes(read(fp+4,4),'big')
            run(caller_base+0xc8)
            index=int.from_bytes(read(index_pointer,4),'big')
            assert index*4+4<=length
            report['index_caller']=dict(index=index,index_pointer=index_pointer,
                                        record_hex=payload[index*4:index*4+4].hex())
            run(outer_return)
            report['index_caller']['return_pointer']=regs()[0]
            assert regs()[0]==pointer and payload[index*4+3]==ord('a')
        args.output.write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report,indent=2))
    finally:
        command('stop')
        for a in points:r.command(f'z0,{a:x},2')
        r.close()

if __name__=='__main__':main()
