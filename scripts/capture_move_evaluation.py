#!/usr/bin/env python3
"""Capture one complete natural CODE35 collector with inputs, contribution stream and undo."""
import argparse
import hashlib
import json
from pathlib import Path
import re
import struct
from gdb_remote import Remote
from qmp_session import command
from maven_debug_cleanup import cleanup_breakpoints


def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--output',type=Path,required=True);a=p.parse_args()
    command('stop');r=Remote();r.sock.settimeout(60);points=set()
    def read(addr,n):return b''.join(bytes.fromhex(r.command(f'm{addr+i:x},{min(2048,n-i):x}')) for i in range(0,n,2048))
    def regs():return struct.unpack('>18I',bytes.fromhex(r.command('g')))
    def long(addr):return int.from_bytes(read(addr,4),'big')
    def word(addr):return int.from_bytes(read(addr,2),'big',signed=True)
    def text(addr,limit=64):
        raw=read(addr,limit);assert b'\0' in raw;return raw.split(b'\0')[0].decode('ascii')
    def add(addr):
        assert r.command(f'Z0,{addr:x},2')=='OK';points.add(addr)
    def clear():
        for addr in list(points):
            assert r.command(f'z0,{addr:x},2')=='OK';points.remove(addr)
    def run(addr):
        add(addr);r.command('c');assert regs()[17]==addr;clear()
    try:
        r.command('?');assert read(0x40800000,16).hex()=='f1acad130000002a067c4efa00804efa'
        xml=r.command('qXfer:features:read:m68k-core.xml:0,fff')
        assert re.findall(r'<reg name="([^"]+)"',xml)==[f'd{i}' for i in range(8)]+[f'a{i}' for i in range(6)]+['fp','sp','ps','pc']
        a5=long(0x904);slot=a5+0x9e2
        print('Waiting for natural main move collector',flush=True);run(slot);stub=read(slot,6)
        if stub==bytes.fromhex('3f3c0023a9f0'):
            r.command('s');r.command('s');run(slot);stub=read(slot,6)
        assert stub[:2]==bytes.fromhex('4ef9');base=int.from_bytes(stub[2:],'big')-0x36c
        code=Path('resources/CODE/35_35.bin').read_bytes();assert read(base+0x36c,len(code)-0x36c)==code[0x36c:]
        run(base+0x36c);caller,move,ids,weights=struct.unpack('>4I',read(regs()[15],16));rack=long(a5-0x3c8a)
        def state():
            out={name:read(a5-offset,n).hex() for name,offset,n in [('board',0x4302,544),('values',0x40e2,1088),('counts',0x5ab2,128),('undo',0xaca,33)]}
            out.update(rack=read(rack,8).hex(),row_zero_count=word(a5-0x4c0e),new_tiles=word(a5-0x4e2a),recorded_row=[word(a5-d) for d in (0x430a,0x430c)],recorded_column=[word(a5-d) for d in (0x4306,0x4308)],balance_entries=read(a5-0xa98,256).hex(),balance_pool_vowels=struct.unpack('>i',read(a5-0x998,4))[0],balance_pool_consonants=struct.unpack('>i',read(a5-0x994,4))[0])
            return out
        initial=state()
        fixed={name:read(a5-offset,n).hex() for name,offset,n in [('letter_values',0x6bee,256),('word_multipliers',0x684e,544),('letter_multipliers',0x6a6e,544),('letter_class',0x428,128),('distribution',0x6aee,128),('penalties',0x976,80),('small_pool_scores',0x6122,34),('q_with_unseen_u',0x8fe,10),('q_without_held_u',0x926,70)]}
        fixed.update(alphabet=read(long(a5-0x662e),28).hex(),vowel_characters=text(a5-0xbca),unseen_q_query=text(a5-0x8e0),held_u_query=text(a5-0x8de),opening_scores=[long(long(a5-0x2a98)+28*i+24) for i in range(16)],letter_scores=[[long(long(a5-0x2a74+4*i)+28*j+24) for j in range(8)] for i in range(27)],composition_scores=[[long(long(a5-0x2a94+4*i)+28*j+24) for j in range(i+1)] for i in range(8)])
        count=word(a5-0x2aa2);assert 0<count<32768
        records=read(long(a5-0x2aa6),count*8);strings_base=long(a5-0x2aa0);score_base=long(a5-0x2a9c)
        string_offsets=[];maximum=0
        for i in range(1,count):
            index=struct.unpack_from('>h',records,8*i+4)[0]
            if index:
                assert index>0;maximum=max(maximum,index);string_offsets.append(struct.unpack_from('>h',records,8*i+2)[0])
        assert min(string_offsets)>=0
        strings=read(strings_base,max(string_offsets)+64)
        pattern_scores=read(score_base,28*(maximum+1));cache_pointer=long(a5-0x98c);cache_count=word(a5-0x97e);entries=[]
        if cache_pointer:
            for i in range(cache_count):
                pointer,accumulator,index=struct.unpack('>IIh',read(cache_pointer+10*i,10));entries.append(dict(string_offset=pointer-strings_base,accumulator=accumulator,table_index=index))
        report=dict(scope='Complete original CODE35 collector and pattern contributions; exact collector/matcher bytes and ROM/register identity; no debugger argument injection',a5=a5,code_base=base,code_sha256=hashlib.sha256(code).hexdigest(),move=read(move,34).hex(),initial=initial,fixed=fixed,pattern_record_count=count,pattern_records=records.hex(),pattern_strings=strings.hex(),pattern_scores=pattern_scores.hex(),lookup_entries=entries,original_ids_pointer=ids,original_weights_pointer=weights,scored_move_callback_pointer=long(a5-0x4c12),contributions=[])
        sites={0x3c6:-32,0x694:20000,0x780:-1,0x7ca:-33,0x8b2:-2,0x916:-3,0x966:-4,0x9c8:None,0xac4:'rack',0xc9e:'board'}
        alphabet=bytes.fromhex(fixed['alphabet']).split(b'\0')[0]
        for addr in [caller,*[base+off for off in sites]]:add(addr)
        print('Collector inputs captured; following contributions',flush=True)
        while True:
            r.command('c');registers=regs();pc=registers[17];assert pc in points
            if pc==caller:break
            kind=sites[pc-base];bits=registers[3]
            if kind is None:
                letter=read(registers[10],1)[0];rid=-5-alphabet.index(letter)
            elif kind in ('rack','board'):
                rid=registers[7]&65535
                if kind=='rack':
                    index=struct.unpack_from('>h',records,8*rid+4)[0];bits=struct.unpack_from('>I',pattern_scores,28*index+24)[0]
            else:rid=kind
            report['contributions'].append(dict(id=rid,score_bits=bits,weight=struct.unpack('>h',(bits&65535).to_bytes(2,'big'))[0],site=hex(pc-base)))
            assert len(report['contributions'])<count+40
            assert r.command(f'z0,{pc:x},2')=='OK';points.remove(pc);r.command('s');add(pc)
        report['result_bits']=regs()[0];assert sum(c['score_bits'] for c in report['contributions'])&0xffffffff==report['result_bits']
        report['final']=state();n=len(report['contributions'])+1
        report['ids']=list(struct.unpack('>'+str(n)+'h',read(ids,n*2))) if ids else None
        report['weights']=list(struct.unpack('>'+str(n)+'h',read(weights,n*2))) if weights else None
        report['complete']=True;a.output.write_text(json.dumps(report,indent=2)+'\n')
        print(json.dumps(dict(contributions=n-1,result_bits=report['result_bits'])),flush=True)
    finally:
        cleanup = cleanup_breakpoints(r, points)
        if 'report' in locals() and a.output.exists():
            report['cleanup'] = cleanup
            a.output.write_text(json.dumps(report, indent=2) + '\n')

if __name__=='__main__':main()
