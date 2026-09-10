#!/usr/bin/env python3
"""Capture a natural CODE3 rollout batch, including each CODE31 refill and its external inputs."""
import argparse
import hashlib
import json
from pathlib import Path
import re
import struct
import subprocess
import sys
from gdb_remote import Remote
from qmp_session import command
from maven_debug_cleanup import cleanup_breakpoints
from verify_loaded_code import verify_loaded_code


def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--output',type=Path,required=True);p.add_argument('--batches',type=int,default=1);p.add_argument('--with-endgame',action='store_true');p.add_argument('--with-late',action='store_true');p.add_argument('--at-entry',action='store_true');p.add_argument('--session-tail',action='store_true');p.add_argument('--controlled-session-limit',action='store_true');p.add_argument('--cancel-after-reply',action='store_true');a=p.parse_args()
    assert 1<=a.batches<=5000
    if a.controlled_session_limit or a.cancel_after_reply:assert a.batches==1;a.session_tail=True
    assert not(a.controlled_session_limit and a.cancel_after_reply)
    if a.batches>1:
        for index in range(a.batches):
            output=a.output.with_name(a.output.stem+f'-{index+1:02}'+a.output.suffix)
            assert not output.exists()
            subprocess.run([sys.executable,__file__,'--output',str(output),*(['--with-endgame'] if a.with_endgame else []),*(['--with-late'] if a.with_late else []),*(['--session-tail'] if a.session_tail and index==a.batches-1 else [])],check=True)
        return
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
        a5=long(0x904);slot=a5+0xba
        print('Waiting for natural simulation batch; start Simulate in the existing dialog',flush=True)
        if not a.at_entry:run(slot)
        stub=read(slot,6)
        if stub==bytes.fromhex('3f3c0003a9f0'):
            r.command('s');r.command('s');run(slot);stub=read(slot,6)
        assert stub[:2]==bytes.fromhex('4ef9');base=int.from_bytes(stub[2:],'big')-0x2c6
        code=Path('resources/CODE/3_3.bin').read_bytes();assert read(base+4,len(code)-4)==code[4:]
        if not a.at_entry:run(base+0x2c6)
        else:assert regs()[17]==base+0x2c6
        caller,opponent_pointer,weight=struct.unpack('>3I',read(regs()[15],12));config=long(a5-0x2ec4);candidate_count=word(config+12);assert 0<candidate_count<=64
        rack=a5-0x3c9a
        def state():
            out={name:read(a5-offset,n).hex() for name,offset,n in [('board',0x4302,544),('values',0x40e2,1088),('counts',0x5ab2,128),('undo',0xaca,33),('unseen_counts',0x31fc,128),('leave_values',0x440c,256),('tile_points',0x3406,256),('canonical_masks',0x3304,256),('occurrence_masks',0x4c0c,2048),('mask_generations',0x4e20,512),('balance_entries',0xa98,256)]}
            out.update(rack=read(rack,8).hex(),row_zero_count=word(a5-0x4c0e),new_tiles=word(a5-0x4e2a),recorded_row=[word(a5-d) for d in (0x430a,0x430c)],recorded_column=[word(a5-d) for d in (0x4306,0x4308)],sorted_rack=text(a5-0x3204,8),mask_count=word(a5-0x3306),generation=long(a5-0x4e24),started_generation=long(a5-0x4e28),unseen_total=word(a5-0x30fa),balance_pool_vowels=struct.unpack('>i',read(a5-0x998,4))[0],balance_pool_consonants=struct.unpack('>i',read(a5-0x994,4))[0],ranking=dict(moves=read(a5-0x5a10,340).hex(),count=word(a5-0x30fc),cutoff_bits=long(a5-0xade)))
            out.update(rack0=read(a5-0x3c9a,8).hex(),rack1=read(a5-0x3ca2,8).hex(),selected_rack_pointer=long(a5-0x3c8a),selected_move=read(a5-0x5a32,34).hex())
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
        report=dict(scope='One complete original CODE3 rollout batch with natural opponent sample and weight; selected moves/refills/application boundaries captured',a5=a5,code_base=base,code_sha256=hashlib.sha256(code).hexdigest(),initial=initial,fixed=fixed,pattern_record_count=count,pattern_records=records.hex(),pattern_strings=strings.hex(),pattern_scores=pattern_scores.hex(),lookup_entries=entries,config=read(config,24+46*candidate_count).hex(),candidate_count=candidate_count,opponent_sample=text(opponent_pointer,8),weight=weight,events=[])
        source=Path('../../media/maven/session/share/maven2.1').read_bytes();data_base=long(a5-0x2eb8)-12;assert read(data_base,len(source))==source
        report['dictionary_sha256']=hashlib.sha256(source).hexdigest();report['sections']=[]
        for i in range(16):
            pointer,root=struct.unpack('>II',read(a5-0x2eb8+8*i,8))
            if not root:break
            report['sections'].append(dict(offset=pointer-data_base,root=root))
        stub=read(a5+0x962,6);assert stub[:2]==bytes.fromhex('4ef9')
        refill_base=int.from_bytes(stub[2:],'big')-0x7e0
        refill_code=Path('resources/CODE/31_31.bin').read_bytes();assert read(refill_base,len(refill_code))==refill_code
        report['code31_sha256']=hashlib.sha256(refill_code).hexdigest();report['refills']=[]
        report['publications']=[]
        def publication():
            frame=regs()[14]
            assert long(frame+8)==config
            report['publications'].append(dict(event_index=len(report['events']),
                count=candidate_count,moves=read(frame-0x8c0,34*candidate_count).hex(),
                entries=read(config+24,46*candidate_count).hex()))
        add(base+0x132)
        refill_sites=(0x7e0,0x7f4,0x810,0x824,0x82c,0x852,0x866,0x86c,0x8b4)
        for off in refill_sites:add(refill_base+off)
        sites={0x3b4:'candidate_applied',0x442:'candidate_refilled',0x4a0:'reply_selected',0x4ac:'reply_applied',0x4b2:'reply_refilled',0x63c:'candidate_restored'}
        for off in sites:add(base+off)
        endgame_sites={}
        if a.with_endgame or a.with_late:
            report['endgame_calls']=[]
            report['search_fixed']={name:read(a5-off,n).hex() for name,off,n in [('bit_masks',0x662a,128),('hash_table',0x468,64),('row_flags',0x6d2,32)]}
            report['search_fixed'].update(capacity=long(a5-0x2ec8),bingo_bonus=word(a5-0x65aa))
            identities=([(30,0x89a,0x14e),(45,0xaf2,0x2b8),(29,0x86a,0x2c),(37,0xa32,0x548),(39,0xa52,4),(40,0xa8a,0x9c),(43,0xaa2,4),(27,0x82a,0x26),(53,0xd72,4)] if a.with_endgame else [])
            late_identities=[(32,0x99a,0xefa),(35,0x9da,0xa48),(36,0xa1a,0x1810),(37,0xa3a,4),(42,0xa92,4),(43,0xaba,0x314)]
            for rid,slot,off in identities:
                codebase,identity=verify_loaded_code(read,a5,rid,slot,off)
                report.setdefault('search_identities',[]).append(identity)
                if rid==30:endgame_base=codebase
                if rid==36:late_base=codebase
            if a.with_endgame:endgame_sites={endgame_base+0x14e:'entry',endgame_base+0x174:'start_clock',endgame_base+0x472:'elapsed',base+0x21c:'returned'}
            if a.with_late:
                report['late_calls']=[]
                report['search_fixed'].update(late_tables=read(a5-0x65a8,0x510).hex(),priority=read(long(a5-0x8da),28).hex(),search_q_query=text(long(a5-0x6c44)),search_blank_query=text(a5-0x97c),exchange_q_string=text(a5-0x710),leave_offset=word(a5-0x5ab4))
                endgame_sites.update({a5+0xa1a:'late_stub',base+0x23e:'late_returned'})
            for addr in endgame_sites:add(addr)
        batch_end=base+0xd44 if a.cancel_after_reply else base+0x65a if a.controlled_session_limit else caller
        add(batch_end);print('Following original rollout candidates and replies',flush=True)
        send_cancel=False
        while True:
            if send_cancel:
                r.command('c',wait=False);command('human-monitor-command',{'command-line':'sendkey esc 100'});r.receive();send_cancel=False
            else:r.command('c')
            registers=regs();pc=registers[17];assert pc in points
            if pc==batch_end:break
            if pc==base+0x132:
                publication()
                assert r.command(f'z0,{pc:x},2')=='OK';points.remove(pc);r.command('s');add(pc)
                continue
            if pc in endgame_sites:
                kind=endgame_sites[pc]
                if kind=='late_stub':
                    assert r.command(f'z0,{pc:x},2')=='OK';points.remove(pc)
                    stub=read(pc,6)
                    if stub==bytes.fromhex('3f3c0024a9f0'):
                        r.command('s');r.command('s');add(pc);r.command('c');assert regs()[17]==pc;assert r.command(f'z0,{pc:x},2')=='OK';points.remove(pc)
                    late_base,identity=verify_loaded_code(read,a5,36,0xa1a,0x1810)
                    report.setdefault('search_identities',[]).append(identity)
                    late_entry=late_base+0x1810;endgame_sites[late_entry]='late_entry';add(late_entry)
                    continue
                if kind=='late_entry':
                    own=long(registers[15]+4);late_call=dict(event_index=len(report['events']),side=0 if own==rack else 1,force=word(registers[15]+8),initial=state());report['late_calls'].append(late_call)
                elif kind=='late_returned':
                    late_call['final']=state()
                    for spec in late_identities:
                        _,identity=verify_loaded_code(read,a5,*spec);report.setdefault('search_identities',[]).append(identity)
                    assert r.command(f'z0,{late_entry:x},2')=='OK';points.remove(late_entry);endgame_sites.pop(late_entry);add(a5+0xa1a)
                elif kind=='entry':
                    own=long(registers[15]+4);budget=long(registers[15]+8)
                    endgame_call=dict(event_index=len(report['events']),side=0 if own==rack else 1,budget=budget,reserve=word(a5-0xacc),elapsed=[],initial=state())
                    report['endgame_calls'].append(endgame_call)
                elif kind=='start_clock':endgame_call['start_ticks']=long(registers[14]-0x6e2)
                elif kind=='elapsed':endgame_call['elapsed'].append(dict(result=registers[0],ticks=long(0x16a)))
                else:endgame_call['final']=state()
                assert r.command(f'z0,{pc:x},2')=='OK';points.remove(pc);r.command('s');add(pc)
                continue
            if pc-refill_base in refill_sites:
                off=pc-refill_base
                if off==0x7e0:
                    rackptr=long(registers[15]+4)
                    refill_trace=dict(event_index=len(report['events']),rack_side=0 if rackptr==a5-0x3c9a else 1,private_seed=long(a5-0xdc4),events=[])
                    assert rackptr in (a5-0x3c9a,a5-0x3ca2)
                    report['refills'].append(refill_trace)
                elif off==0x7f4:
                    frame=registers[14];length=registers[0];assert length<=127
                    refill_trace.update(bag=read(frame-0x80,length).hex(),stack_ticks=long(frame-0x84))
                elif off==0x8b4:
                    refill_trace['final']=dict(rack=read(rackptr,8).hex(),private_seed=long(a5-0xdc4),bag_workspace=read(frame-0x80,length).hex())
                else:
                    if off in (0x810,0x852):event=dict(kind='ticks',value=long(frame-(0x84 if off==0x810 else 0x88)))
                    elif off in (0x824,0x866):event=dict(kind='private_random',value=registers[0])
                    else:event=dict(kind='toolbox_random',value=registers[0]&65535)
                    refill_trace['events'].append(event);assert len(refill_trace['events'])<10000
                assert r.command(f'z0,{pc:x},2')=='OK';points.remove(pc);r.command('s');add(pc)
                continue
            report['events'].append(dict(kind=sites[pc-base],candidate=registers[6]&65535,reply=registers[3]&65535,state=state(),candidate_entries=read(config+24,46*candidate_count).hex()))
            print('event',len(report['events']),sites[pc-base],flush=True)
            if a.cancel_after_reply and sites[pc-base]=='candidate_refilled' and 'cancel_input' not in report:
                send_cancel=True
                report['cancel_input']={'kind':'ordinary Escape','sent_after_event':len(report['events']),'search_poll_callback':long(a5-0x5c76)}
            assert len(report['events'])<candidate_count*100
            assert r.command(f'z0,{pc:x},2')=='OK';points.remove(pc);r.command('s');add(pc)
        if a.cancel_after_reply:
            assert long(a5-0x5dde)==long(a5-0x6c54)
            report['interrupted']=True;report['scope']='Original partial CODE3 batch interrupted by ordinary Escape at an explicit reply poll; outer session cleanup captured'
        report['final']=state();report['final_config']=read(config,24+46*candidate_count).hex();report['complete']=True
        if a.session_tail:
            if a.controlled_session_limit:
                before=read(config,24+46*candidate_count);assert word(config+16)==0
                weight=long(config+0x42);assert 0<weight<0x7fffffff
                changed=weight.to_bytes(4,'big');assert r.command(f'M{config:x},4:{changed.hex()}')=='OK'
                assert read(config,len(before))==changed+before[4:]
                report['controlled_mutation']=dict(field='signed32 sample limit',before=before[:4].hex(),after=changed.hex(),first_candidate_weight=weight,all_other_config_bytes_unchanged=True)
            clear();frame=regs()[14]
            for _ in range(30):
                if long(frame+4)==base+0x2c0:break
                frame=long(frame);assert frame
            else:raise AssertionError('session frame not found')
            session_caller=long(frame+4)
            report['session_saved']={name:read(frame-off,n).hex() for name,off,n in [('board',0x220,544),('values',0x660,1088),('rack0',0x668,8),('rack1',0x670,8)]}
            report['session_saved']['selected_pointer']=long(frame-0x674)
            report['session_tail']=[]
            def run_tail(address):
                add(address);add(base+0x132)
                while True:
                    r.command('c');pc=regs()[17]
                    if pc==address:break
                    assert pc==base+0x132;publication()
                    assert r.command(f'z0,{pc:x},2')=='OK';points.remove(pc);r.command('s');add(pc)
                clear()
            for offset,name in [(0xd86,'before_restore'),(0xdd6,'board_racks_restored'),(0xde2,'leave_rebuilt')]:
                run_tail(base+offset);report['session_tail'].append(dict(kind=name,state=state(),config=read(config,24+46*candidate_count).hex()))
            run_tail(session_caller);report['session_tail'].append(dict(kind='returned',state=state(),config=read(config,24+46*candidate_count).hex()))
        a.output.write_text(json.dumps(report,indent=2)+'\n');print('Complete rollout events',len(report['events']),flush=True)
    finally:
        cleanup=cleanup_breakpoints(r,points)
        if 'report' in locals() and a.output.exists():
            report['cleanup']=cleanup;a.output.write_text(json.dumps(report,indent=2)+'\n')

if __name__=='__main__':main()
