#!/usr/bin/env python3
"""Capture original rack/board pattern matching with all explicit inputs."""
import argparse,hashlib,json,re,struct
from pathlib import Path
from gdb_remote import Remote
from qmp_session import command

def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--output',type=Path,required=True);p.add_argument('--trace-matches',action='store_true');a=p.parse_args()
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
        if stub==bytes.fromhex('3f3c0023a9f0'):
            r.command('s');r.command('s');run(slot);stub=read(slot,6)
        assert stub[:2]==bytes.fromhex('4ef9');base=int.from_bytes(stub[2:],'big')-slots[slot]
        code=Path('resources/CODE/35_35.bin').read_bytes();assert read(base+0xa48,0xcd0-0xa48)==code[0xa48:0xcd0]
        print('Waiting for original rack/board pattern matcher',flush=True);run(base+0xa48)
        caller,ids,weights,mode=struct.unpack('>IIIh',read(regs()[15],14))
        count=int.from_bytes(read(a5-0x2aa2,2),'big',signed=True);assert 0<count<32768
        records=int.from_bytes(read(a5-0x2aa6,4),'big');strings=int.from_bytes(read(a5-0x2aa0,4),'big');table=int.from_bytes(read(a5-0x2a9c,4),'big')
        def block(address,n):return b''.join(read(address+i,min(2048,n-i)) for i in range(0,n,2048))
        raw=block(records,8*count);offsets=set();maximum=0
        for i in range(1,count):
            rec=raw[8*i:8*i+8];index=int.from_bytes(rec[4:6],'big',signed=True)
            if index:assert index>0;maximum=max(maximum,index);offsets.add(int.from_bytes(rec[2:4],'big',signed=True))
        text={}
        for off in offsets:
            b=read(strings+off,64);assert b'\0' in b;text[str(off)]=b.split(b'\0')[0].decode('ascii')
        initial={name:block(a5-d,n).hex() for name,d,n in [('board',0x4302,544),('values',0x40e2,1088),('letter_values',0x6bee,256),('counts',0x5ab2,128)]}
        matched=None
        if a.trace_matches:
            matched=[]
            for address in (base+0xac4,base+0xc9e,caller):
                assert r.command(f'Z0,{address:x},2')=='OK';points.add(address)
            while True:
                r.command('c');registers=regs();address=registers[17]
                assert address in points
                assert r.command(f'z0,{address:x},2')=='OK';points.remove(address)
                if address==caller:break
                rid=registers[7]&65535
                if address==base+0xac4:
                    idx=int.from_bytes(raw[8*rid+4:8*rid+6],'big',signed=True)
                    bits=int.from_bytes(read(table+28*idx+24,4),'big')
                else:bits=registers[3]
                weight=bits&65535;weight=weight if weight<32768 else weight-65536
                matched.append(dict(id=rid,weight=weight,score_bits=bits,kind='rack' if address==base+0xac4 else 'board'))
                assert len(matched)<count
                r.command('s');assert r.command(f'Z0,{address:x},2')=='OK';points.add(address)
            assert sum(item['score_bits'] for item in matched)&0xffffffff==regs()[0]
            for address in list(points):assert r.command(f'z0,{address:x},2')=='OK';points.remove(address)
        else:run(caller)
        result=regs()[0]
        def words(pointer):
            if not pointer:return None
            out=[]
            for i in range(count):
                v=int.from_bytes(read(pointer+2*i,2),'big',signed=True);out.append(v)
                if not v:return out
            raise AssertionError('missing terminator')
        id_values=words(ids)
        # Weight0 is valid, so size follows IDs rather than stopping at0.
        weight_values=None if not weights or id_values is None else list(struct.unpack('>'+str(len(id_values))+'h',read(weights,2*len(id_values))))
        report=dict(scope='One original pattern matcher call during normal first-game execution; exact CODE35[0xa48,0xcd0), ROM and register identity; no debugger argument injection',code35_sha256=hashlib.sha256(code).hexdigest(),record_count=count,raw_records=raw.hex(),strings=text,score_records=block(table,28*(maximum+1)).hex(),initial=initial,mode=mode,result_bits=result,matched_records=matched,record_ids=id_values,weights=weight_values,final_counts=read(a5-0x5ab2,128).hex())
        a.output.write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(dict(mode=mode,result_bits=result,matched_records=matched,record_ids=id_values,weights=weight_values),indent=2))
    finally:
        command('stop')
        for addr in points:r.command(f'z0,{addr:x},2')
        r.close()
if __name__=='__main__':main()
