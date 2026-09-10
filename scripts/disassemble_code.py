#!/usr/bin/env python3
"""Disassemble resource-relative M68K code and annotate original A5 jump slots.

This is a reproducible navigation aid, not a claim that inline data is code.
All addresses include the four-byte CODE header. Runtime identity is separate.
"""
import argparse
from pathlib import Path
import re
import struct
from capstone import Cs,CS_ARCH_M68K,CS_MODE_BIG_ENDIAN,CS_MODE_M68K_020
ROOT=Path(__file__).resolve().parents[1]
def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('resource',type=int,nargs='+');a=p.parse_args()
    slots={};data=(ROOT/'resources/CODE/0_0.bin').read_bytes()
    for i in range((len(data)-16)//8):
        offset,push,rid,trap=struct.unpack_from('>4H',data,16+8*i);slots[34+8*i]=(rid,offset+4)
    decoder=Cs(CS_ARCH_M68K,CS_MODE_BIG_ENDIAN|CS_MODE_M68K_020);decoder.skipdata=True
    for rid in a.resource:
        data=(ROOT/f'resources/CODE/{rid}_{rid}.bin').read_bytes();lines=[]
        for ins in decoder.disasm(data[4:],4):
            annotation='';m=re.fullmatch(r'\$([0-9a-f]+)\(a5\)',ins.op_str)
            if ins.mnemonic in ('jsr','jmp') and m and int(m[1],16) in slots:
                target,offset=slots[int(m[1],16)];annotation=f' ; CODE{target}+{offset:04x}'
            lines.append(f'{ins.address:04x}: {ins.bytes.hex():20} {ins.mnemonic:10} {ins.op_str}{annotation}')
        out=ROOT/f'analysis/toolchain/code{rid}-corrected.asm';out.write_text('\n'.join(lines)+'\n');print(out)
if __name__=='__main__':main()
