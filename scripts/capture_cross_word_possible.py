#!/usr/bin/env python3
"""Capture original crossing-word availability checks."""
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
        code=Path('resources/CODE/32_32.bin').read_bytes();assert read(base+0x6a2,0x7c0-0x6a2)==code[0x6a2:0x7c0]
        print('Waiting for original crossing-word check',flush=True);run(base+0x6a2)
        caller,available,alphabet,row,column=struct.unpack('>IIIhh',read(regs()[15],16))
        initial=dict(board=read(a5-0x4302,544).hex(),available=read(available,256).hex(),alphabet=read(alphabet,28).hex(),row=row,column=column)
        stub=read(a5+0x31a,6);assert stub[:2]==bytes.fromhex('4ef9');lookup=int.from_bytes(stub[2:],'big')
        code15=Path('resources/CODE/15_15.bin').read_bytes();assert read(lookup,0x276-0x23e)==code15[0x23e:0x276]
        calls=[]
        for address in (lookup,caller):assert r.command(f'Z0,{address:x},2')=='OK';points.add(address)
        while True:
            r.command('c');registers=regs();address=registers[17];assert address in points
            assert r.command(f'z0,{address:x},2')=='OK';points.remove(address)
            if address==caller:break
            ret,word=struct.unpack('>II',read(registers[15],8));query=read(word,32).split(b'\0')[0].decode('ascii');during=read(a5-0x4302,544).hex()
            run(ret);result=regs()[0];calls.append(dict(word=query,result_bits=result,board_during=during));assert len(calls)<129
            assert r.command(f'Z0,{lookup:x},2')=='OK';points.add(lookup)
        report=dict(scope='Original crossing-word helper and actual dictionary query sequence; exact CODE32/CODE15 ranges, ROM/register identity; no debugger argument injection',code32_sha256=hashlib.sha256(code).hexdigest(),code15_sha256=hashlib.sha256(code15).hexdigest(),initial=initial,calls=calls,result_bits=regs()[0],final_board=read(a5-0x4302,544).hex())
        a.output.write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(dict(row=row,column=column,queries=[c['word'] for c in calls],result_bits=report['result_bits']),indent=2))
    finally:
        command('stop')
        for addr in points:r.command(f'z0,{addr:x},2')
        r.close()
if __name__=='__main__':main()
