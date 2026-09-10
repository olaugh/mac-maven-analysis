#!/usr/bin/env python3
"""Inventory candidate A5-relative calls to the fingerprinted startup helpers.

Aligned opcode matches are candidates, not proven executable call sites:
CODE resources also contain inline tables and data. Preserve context for audit.
"""
import hashlib
import json
from pathlib import Path


def main():
    root=Path(__file__).resolve().parents[1]
    jump=json.loads((root/'analysis/toolchain/jump-table.json').read_text())
    targets={e['a5_callable_offset']:e for e in jump['entries']
             if e['code_resource']==1 and 0xaa<=e['resource_offset']<0x240}
    rows=[]
    for path in sorted((root/'resources/CODE').glob('*.bin')):
        rid=int(path.stem.split('_')[0])
        if rid==0:continue
        data=path.read_bytes()
        for offset in range(4,len(data)-3,2):
            opcode=data[offset:offset+2]
            if opcode not in (b'\x4e\xad',b'\x4e\xed'):continue
            slot=int.from_bytes(data[offset+2:offset+4],'big')
            if slot not in targets:continue
            rows.append(dict(code_resource=rid,resource_offset=offset,
                             operation='JSR' if opcode==b'\x4e\xad' else 'JMP',
                             a5_slot=slot,target_resource_offset=targets[slot]['resource_offset'],
                             context_start=max(4,offset-12),
                             context_hex=data[max(4,offset-12):offset+16].hex(),
                             code_sha256=hashlib.sha256(data).hexdigest()))
    counts=[dict(a5_slot=slot,target_resource_offset=e['resource_offset'],
                 candidates=sum(r['a5_slot']==slot for r in rows))
            for slot,e in targets.items()]
    print(json.dumps(dict(scope='Aligned JSR/JMP opcode candidates only; no instruction-boundary or reachability proof. Runtime identity does not uniquely identify compiler version.',
                         targets=counts,candidates=rows),indent=2))


if __name__=='__main__':main()
