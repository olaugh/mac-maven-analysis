#!/usr/bin/env python3
"""Capture original lazy pattern-cache construction, without changing arguments."""
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
        a5=int.from_bytes(read(0x904,4),'big');code0=Path('resources/CODE/0_0.bin').read_bytes();slots={}
        for i in range((len(code0)-16)//8):
            offset,push,rid,trap=struct.unpack_from('>4H',code0,16+8*i)
            if rid==32:slots[a5+34+8*i]=offset+4
        if False:
            slot=next(address for address in slots if read(address,2)==bytes.fromhex('4ef9'))
            print('Waiting for next direct composition call',flush=True)
        else:
            print('Waiting for first natural CODE32 entry before composition cache warms',flush=True)
            for address in slots:
                assert r.command(f'Z0,{address:x},2')=='OK';points.add(address)
            r.command('c');slot=regs()[17];assert slot in slots
            for address in list(points):assert r.command(f'z0,{address:x},2')=='OK';points.remove(address)
        stub=read(slot,6)
        if stub==bytes.fromhex('3f3c0020a9f0'):
            r.command('s');r.command('s');run(slot);stub=read(slot,6)
        assert stub[:2]==bytes.fromhex('4ef9');base=int.from_bytes(stub[2:],'big')-slots[slot]
        code=Path('resources/CODE/32_32.bin').read_bytes();start,end=0x16c0,0x18e4
        assert read(base+start,end-start)==code[start:end]
        print('Waiting for original lazy pattern cache construction',flush=True);run(base+start)
        assert read(a5-0x98c,4)==b'\0'*4
        assert read(a5-0x97e,2)==b'\0'*2
        count=int.from_bytes(read(a5-0x2aa2,2),'big',signed=True);assert 0<=count<32768
        records_address=int.from_bytes(read(a5-0x2aa6,4),'big');strings_address=int.from_bytes(read(a5-0x2aa0,4),'big')
        raw=b''.join(read(records_address+i,min(2048,count*8-i)) for i in range(0,count*8,2048));strings={}
        for i in range(1,count):
            rec=raw[i*8:i*8+8]
            if int.from_bytes(rec[4:6],'big') and not rec[6]:
                off=int.from_bytes(rec[2:4],'big',signed=True)
                data=read(strings_address+off,64);assert b'\0' in data
                strings[str(off)]=data.split(b'\0')[0].decode('ascii')
        run(base+0x1872)
        cache_address=int.from_bytes(read(a5-0x98c,4),'big');cache_count=int.from_bytes(read(a5-0x97e,2),'big',signed=True)
        entries=[]
        for i in range(cache_count):
            pointer,accumulator,index=struct.unpack('>IIh',read(cache_address+10*i,10))
            entries.append(dict(string_offset=pointer-strings_address,accumulator=accumulator,table_index=index))
        report=dict(scope='Original lazy pattern cache constructed during normal engine execution; exact CODE32[0x16c0,0x18e4) and ROM/register identity; no debugger memory injection',a5=a5,code32_sha256=hashlib.sha256(code).hexdigest(),verified_range=[start,end],record_count=count,raw_records=raw.hex(),strings=strings,entries=entries)
        a.output.write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(dict(record_count=count,cache_count=cache_count),indent=2))
    finally:
        command('stop')
        for addr in points:r.command(f'z0,{addr:x},2')
        r.close()
if __name__=='__main__':main()
