#!/usr/bin/env python3
"""Find Maven's observed A1/table, D0/index switch encoding.

Only this exact lowering is recognized. Sites remain static candidates until
their incoming control flow and selector transformation are individually audited.
"""
import hashlib
import json
from pathlib import Path
import struct


def main():
    root=Path(__file__).resolve().parents[1];sites=[]
    for path in sorted((root/'resources/CODE').glob('*.bin')):
        rid=int(path.stem.split('_')[0])
        if rid==0:continue
        data=path.read_bytes()
        for lea in range(4,len(data)-11,2):
            if data[lea:lea+2]!=b'\x43\xfa' or data[lea+4:lea+12]!=bytes.fromhex('d040d2f100004ed1'):
                continue
            compares=[offset for offset in range(max(4,lea-18),lea-3,2)
                      if data[offset:offset+2]==b'\x0c\x40']
            assert compares, (rid,lea)
            compare=compares[-1];maximum=struct.unpack_from('>H',data,compare+2)[0]
            branches=[offset for offset in range(compare+4,lea,2) if data[offset]==0x62]
            assert len(branches)==1,(rid,lea)
            branch=branches[0];disp=data[branch+1]
            if disp==0:disp=struct.unpack_from('>h',data,branch+2)[0]
            elif disp>=128:disp-=256
            default=branch+2+disp
            table=lea+2+struct.unpack_from('>h',data,lea+2)[0]
            end=table+2*(maximum+1)
            assert 4<=table<end<=len(data) and 4<=default<len(data)
            offsets=struct.unpack_from('>'+str(maximum+1)+'h',data,table)
            targets=[table+v for v in offsets]
            assert all(4<=t<len(data) and t%2==0 for t in targets)
            sites.append(dict(code_resource=rid,code_sha256=hashlib.sha256(data).hexdigest(),
                              dispatch_lea=lea,comparison_offset=compare,
                              table_offset=table,table_end=end,entry_count=maximum+1,
                              default_target=default,targets=targets,
                              context_start=max(4,lea-24),
                              context_hex=data[max(4,lea-24):lea+12].hex()))
    print(json.dumps(dict(scope='Exact switch encoding plus bounded table/target checks; static candidates, not reachability or unique compiler-release proof',
                         site_count=len(sites),sites=sites),indent=2))


if __name__=='__main__':main()
