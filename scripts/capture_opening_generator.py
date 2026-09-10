#!/usr/bin/env python3
"""Capture one complete natural CODE37 placement and scored-candidate stream."""
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
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('--output', type=Path, required=True)
    p.add_argument('--board', action='store_true', help='Capture a nonempty-board generator call')
    a = p.parse_args()
    command('stop'); r = Remote(); r.sock.settimeout(60); points = set()
    def read(addr,n):
        return b''.join(bytes.fromhex(r.command(f'm{addr+i:x},{min(2048,n-i):x}')) for i in range(0,n,2048))
    def regs(): return struct.unpack('>18I', bytes.fromhex(r.command('g')))
    def add(addr):
        assert r.command(f'Z0,{addr:x},2') == 'OK'; points.add(addr)
    def clear():
        for addr in list(points):
            assert r.command(f'z0,{addr:x},2') == 'OK'; points.remove(addr)
    def run(addr):
        add(addr); r.command('c'); assert regs()[17] == addr; clear()
    try:
        r.command('?'); assert read(0x40800000,16).hex() == 'f1acad130000002a067c4efa00804efa'
        xml=r.command('qXfer:features:read:m68k-core.xml:0,fff')
        assert re.findall(r'<reg name="([^"]+)"',xml)==[f'd{i}' for i in range(8)]+[f'a{i}' for i in range(6)]+['fp','sp','ps','pc']
        a5=int.from_bytes(read(0x904,4),'big'); slot=a5+0xa3a
        print('Waiting for natural CODE37 generator; requested nonempty board' if a.board else 'Waiting for natural CODE37 generator; requested empty board',flush=True)
        run(slot); stub=read(slot,6)
        if stub==bytes.fromhex('3f3c0025a9f0'):
            r.command('s');r.command('s');run(slot);stub=read(slot,6)
        assert stub[:2]==bytes.fromhex('4ef9');base=int.from_bytes(stub[2:],'big')-4
        code=Path('resources/CODE/37_37.bin').read_bytes();assert read(base+4,len(code)-4)==code[4:]
        run(base+4);sp=regs()[15];return_pc=int.from_bytes(read(sp,4),'big')
        board=read(a5-0x4302,544)
        assert bool(any(board)) == a.board, 'Board does not match requested opening/nonempty mode'
        first=int.from_bytes(read(a5-0x2eb8,4),'big');data_base=first-12
        source=Path('../../media/maven/session/share/maven2.1').read_bytes()
        assert read(data_base,len(source))==source
        sections=[]
        for i in range(16):
            pointer,root=struct.unpack('>II',read(a5-0x2eb8+8*i,8))
            if not root:break
            sections.append(dict(offset=pointer-data_base,root=root))
        else:raise AssertionError('unterminated dictionary sections')
        report=dict(scope='Complete natural CODE37 placement stream at E46 entry before and after evaluation, through preliminary ranking; precomputed leave table is captured input, final collector reranking is outside this call',code_sha256=hashlib.sha256(code).hexdigest(),dictionary_sha256=hashlib.sha256(source).hexdigest(),a5=a5,code_base=base,sections=sections,counts=read(a5-0x5ab2,128).hex(),vowel_characters=read(a5-0xbca,32).split(b'\0')[0].decode('ascii'),letter_multipliers=read(a5-0x6a6e,544).hex(),word_multipliers=read(a5-0x684e,544).hex(),placements=[])
        report['return_pc']=return_pc
        report['board_mode']=a.board
        report['scoring']={name:read(a5-d,n).hex() for name,d,n in [('board',0x4302,544),('values',0x40e2,1088),('letter_values',0x6bee,256),('letter_class',0x428,128),('leave_values',0x440c,256),('occurrence_masks',0x4c0c,2048)]}
        report['scoring']['alphabet']=read(int.from_bytes(read(a5-0x662e,4),'big'),28).hex()
        report['scoring']['sorted_rack']=read(a5-0x3204,17).split(b'\0')[0].decode('ascii')
        def ranking():
            return dict(moves=read(a5-0x5a10,340).hex(),count=int.from_bytes(read(a5-0x30fc,2),'big'),cutoff_bits=int.from_bytes(read(a5-0xade,4),'big'))
        report['initial_ranking']=ranking()
        report['extra_filter_pointer']=int.from_bytes(read(a5-0x4c1e,4),'big')
        report['scored_moves']=[]
        print('Identity and requested board inputs verified',flush=True)
        for address in (base+0xe46,base+0x1332,return_pc):add(address)
        while True:
            r.command('c');pc=regs()[17];assert pc in points
            if pc==return_pc:break
            move_ptr=int.from_bytes(read(a5-0x2a06,4),'big');move=read(move_ptr,34)
            if pc==base+0x1332:
                report['scored_moves'].append(move.hex())
            else:
                report['placements'].append(dict(word=move[:16].split(b'\0')[0].decode('ascii'),row=move[32],column=move[33],adjustment_bits=int.from_bytes(move[24:28],'big'),section=int.from_bytes(read(a5-0x2ab8,2),'big'),remaining_counts=read(a5-0x2988,128).hex()))
            assert len(report['placements'])<100000
            if pc==base+0xe46 and len(report['placements'])%250==0:
                print('Progress placements',len(report['placements']),'scored',len(report['scored_moves']),flush=True)
            assert r.command(f'z0,{pc:x},2')=='OK';points.remove(pc);r.command('s');add(pc)
        report['final_counts']=read(a5-0x2988,128).hex()
        report['final_ranking']=ranking()
        report['complete']=True
        a.output.write_text(json.dumps(report,indent=2)+'\n')
        print('Complete placements',len(report['placements']),flush=True)
    finally:
        cleanup = cleanup_breakpoints(r, points)
        if 'report' in locals() and a.output.exists():
            report['cleanup'] = cleanup
            a.output.write_text(json.dumps(report, indent=2) + '\n')

if __name__=='__main__':main()
