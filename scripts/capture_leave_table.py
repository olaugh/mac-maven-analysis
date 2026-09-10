#!/usr/bin/env python3
"""Capture natural CODE32 leave preparation or exchange generation with exact inputs and state."""
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
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--output',type=Path,required=True);p.add_argument('--at-entry',action='store_true');p.add_argument('--simulation-exit',action='store_true');p.add_argument('--late',action='store_true');p.add_argument('--exchange',action='store_true');p.add_argument('--search',action='store_true');a=p.parse_args()
    command('stop');r=Remote();r.sock.settimeout(180);points=set()
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
        a5=long(0x904);offset=0x9dc if a.late else 0x11a if a.search else 0x1304 if a.exchange else 0xefa;slot=a5+(0x97a if a.late else 0x852 if a.search else 0x9ba if a.exchange else 0x99a);rid=28 if a.search else 32
        if a.simulation_exit:
            st=read(a5+0xba,6);assert st[:2]==bytes.fromhex('4ef9');b3=int.from_bytes(st[2:],'big')-0x2c6
            c3=Path('resources/CODE/3_3.bin').read_bytes();assert read(b3+4,len(c3)-4)==c3[4:]
            print('Waiting for ordinary simulation exit',flush=True);run(b3+0xdd6)
        print('Waiting for natural exchange generator' if a.exchange else 'Waiting for natural leave preparation',flush=True);
        if not a.at_entry:run(slot)
        stub=read(slot,6)
        if stub==bytes.fromhex('3f3c')+rid.to_bytes(2,'big')+bytes.fromhex('a9f0'):
            r.command('s');r.command('s');run(slot);stub=read(slot,6)
        assert stub[:2]==bytes.fromhex('4ef9');base=int.from_bytes(stub[2:],'big')-offset
        outer_base=base
        outer_code=Path(f'resources/CODE/{rid}_{rid}.bin').read_bytes()
        if a.search:
            assert read(base+4,len(outer_code)-4)==outer_code[4:]
            code32_stub=read(a5+0x99a,6)
            assert code32_stub[:2]==bytes.fromhex('4ef9') or code32_stub==bytes.fromhex('3f3c0020a9f0')
            base=int.from_bytes(code32_stub[2:],'big')-0xefa if code32_stub[:2]==bytes.fromhex('4ef9') else None
        code=Path('resources/CODE/32_32.bin').read_bytes();live=read(base+4,len(code)-4) if base is not None else None
        previous=next(x for x in json.loads(Path('analysis/toolchain/floating-trap-rewrites-live.json').read_text())['resources'] if x['code_resource']==32)
        assert previous['source_sha256']==hashlib.sha256(code).hexdigest()
        patched=bytearray(code)
        for change in previous['differences']:
            assert patched[change['offset']]==change['original'];patched[change['offset']]=change['live']
        assert live is None or live in (code[4:],bytes(patched[4:]))
        identity='deferred_until_natural_load' if live is None else 'source' if live==code[4:] else 'exact_previous_fp_rewrite_fingerprint'
        if not a.at_entry:run(outer_base+offset)
        assert regs()[17]==outer_base+offset
        caller=long(regs()[15]);rack=long(regs()[15]+4) if a.search else long(a5-0x3c8a);search_callback=long(regs()[15]+8) if a.search else 0
        def state():
            out={name:read(a5-offset,n).hex() for name,offset,n in [('board',0x4302,544),('values',0x40e2,1088),('counts',0x5ab2,128),('undo',0xaca,33),('unseen_counts',0x31fc,128),('leave_values',0x440c,256),('tile_points',0x3406,256),('canonical_masks',0x3304,256),('occurrence_masks',0x4c0c,2048),('mask_generations',0x4e20,512),('balance_entries',0xa98,256)]}
            out.update(rack=read(rack,8).hex(),row_zero_count=word(a5-0x4c0e),new_tiles=word(a5-0x4e2a),recorded_row=[word(a5-d) for d in (0x430a,0x430c)],recorded_column=[word(a5-d) for d in (0x4306,0x4308)],sorted_rack=text(a5-0x3204,17 if a.late else 8),mask_count=word(a5-0x3306),generation=long(a5-0x4e24),started_generation=long(a5-0x4e28),unseen_total=word(a5-0x30fa),balance_pool_vowels=struct.unpack('>i',read(a5-0x998,4))[0],balance_pool_consonants=struct.unpack('>i',read(a5-0x994,4))[0],ranking=dict(moves=read(a5-0x5a10,340).hex(),count=word(a5-0x30fc),cutoff_bits=long(a5-0xade)))
            return out
        initial=state()
        fixed={name:read(a5-offset,n).hex() for name,offset,n in [('letter_values',0x6bee,256),('word_multipliers',0x684e,544),('letter_multipliers',0x6a6e,544),('letter_class',0x428,128),('distribution',0x6aee,128),('penalties',0x976,80),('small_pool_scores',0x6122,34),('q_with_unseen_u',0x8fe,10),('q_without_held_u',0x926,70)]}
        fixed.update(search_q_query=text(long(a5-0x6c44)),search_blank_query=text(a5-0x97c),alphabet=read(long(a5-0x662e),28).hex(),vowel_characters=text(a5-0xbca),unseen_q_query=text(a5-0x8e0),held_u_query=text(a5-0x8de),opening_scores=[long(long(a5-0x2a98)+28*i+24) for i in range(16)],letter_scores=[[long(long(a5-0x2a74+4*i)+28*j+24) for j in range(8)] for i in range(27)],composition_scores=[[long(long(a5-0x2a94+4*i)+28*j+24) for j in range(i+1)] for i in range(8)])
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
        report=dict(late=a.late,search=a.search,search_base=outer_base,search_callback=search_callback,search_code_sha256=hashlib.sha256(outer_code).hexdigest(),scope='Natural CODE32 exchange generator' if a.exchange else 'Natural CODE32 heuristic leave-table preparation',a5=a5,code_base=base,code_sha256=hashlib.sha256(code).hexdigest(),code_identity=identity,loaded_code_sha256=hashlib.sha256(live).hexdigest() if live is not None else None,initial=initial,fixed=fixed,pattern_record_count=count,pattern_records=records.hex(),pattern_strings=strings.hex(),pattern_scores=pattern_scores.hex(),lookup_entries=entries,exchange=a.exchange,leave_offset=word(a5-0x5ab4),opening=not bool(read(a5-0x4272,1)[0]),extra_filter_pointer=long(a5-0x4c1e),exchange_moves=[],letter_lookups=[])
        if a.search:
            if base is None:
                run(a5+0x99a);stub=read(a5+0x99a,6)
                if stub==bytes.fromhex('3f3c0020a9f0'):
                    r.command('s');r.command('s');run(a5+0x99a);stub=read(a5+0x99a,6)
                assert stub[:2]==bytes.fromhex('4ef9');base=int.from_bytes(stub[2:],'big')-0xefa
                live=read(base+4,len(code)-4);assert live in (code[4:],bytes(patched[4:]))
                report.update(code_base=base,code_identity='source' if live==code[4:] else 'exact_previous_fp_rewrite_fingerprint',loaded_code_sha256=hashlib.sha256(live).hexdigest())
            source=Path('../../media/maven/session/share/maven2.1').read_bytes();data_base=long(a5-0x2eb8)-12
            assert read(data_base,len(source))==source
            report['dictionary_sha256']=hashlib.sha256(source).hexdigest();report['sections']=[]
            for i in range(16):
                pointer,root=struct.unpack('>II',read(a5-0x2eb8+i*8,8))
                if not root:break
                report['sections'].append(dict(offset=pointer-data_base,root=root))
            report['opponent_rack']=read(a5-0x3ca2 if rack==a5-0x3c9a else a5-0x3c9a,8).hex()
            report['scored_move_callback_pointer']=long(a5-0x4c12)
            report['candidates']=[];phase=0
            for off in (4,0x1c4,0x1e4):add(outer_base+off)
        add(caller)
        if a.exchange:
            add(base+0x133c);add(base+0x13e6)
        print('Inputs captured; following natural return',flush=True)
        while True:
            r.command('c');registers=regs();pc=registers[17];assert pc in points
            if pc==caller:break
            if a.search:
                if pc==outer_base+0x1c4:phase=1
                elif pc==outer_base+0x1e4:
                    report['preliminary_ranking']=state()['ranking'];phase=2
                else:
                    assert pc==outer_base+4
                    report['candidates'].append(dict(phase=phase,move=read(long(registers[15]+4),34).hex(),mode=word(a5-0x4e2a)))
            elif pc==base+0x133c:
                report['letter_lookups'].append(dict(letter=read(registers[12],1)[0],value=struct.unpack('>h',(registers[0]&65535).to_bytes(2,'big'))[0]))
            else:report['exchange_moves'].append(read(long(registers[15]),34).hex())
            assert r.command(f'z0,{pc:x},2')=='OK';points.remove(pc);r.command('s');add(pc)
        report['final']=state()
        if a.search:print('Search candidate callbacks',len(report['candidates']),flush=True)
        report['final_lookup_accumulators']=[long(cache_pointer+10*i+4) for i in range(cache_count)]
        report['complete']=True;a.output.write_text(json.dumps(report,indent=2)+'\n')
        print(json.dumps(dict(masks=report['final']['mask_count'],exchanges=len(report['exchange_moves']))),flush=True)
    finally:
        cleanup = cleanup_breakpoints(r, points)
        if 'report' in locals() and a.output.exists():
            report['cleanup'] = cleanup
            a.output.write_text(json.dumps(report, indent=2) + '\n')

if __name__=='__main__':main()
