#!/usr/bin/env python3
"""Decode the manually audited CODE 24 scanner format-dispatch table."""
import hashlib
import json
from pathlib import Path
import struct


def main():
    root=Path(__file__).resolve().parents[1]
    data=(root/'resources/CODE/24_24.bin').read_bytes()
    # Includes range subtraction/check, PC-relative LEA, scaling, signed
    # displacement addition and indirect JMP. Reject changed code layouts.
    expected=bytes.fromhex('30070440003f0c4000396200025443fa07e8d040d2f100004ed1')
    assert data[0xb9c:0xbb6]==expected
    base=0x1394
    known={'?':0xbf2,'E':0xc2a,'G':0xc2a,'L':0xbde,'X':0xc24,'[':0xc8a,
           'c':0xd74,'d':0xc06,'e':0xc2a,'f':0xc2a,'g':0xc2a,'h':0xbb6,
           'i':0xc0c,'l':0xbca,'n':0xdf2,'o':0xc12,'p':0xc1e,'s':0xc3a,
           'u':0xc18,'x':0xc24}
    rows=[]
    for index in range(58):
        value=63+index
        displacement=struct.unpack_from('>h',data,base+2*index)[0]
        target=base+displacement
        assert target==known.get(chr(value),0xdfc)
        rows.append(dict(value=value,character=chr(value),displacement=displacement,
                         target_resource_offset=target))
    print(json.dumps(dict(code_resource=24,sha256=hashlib.sha256(data).hexdigest(),
                         dispatch_offset=0xb9c,dispatch_hex=expected.hex(),
                         table_offset=base,entry_count=58,default_target=0xdfc,
                         encoding='signed 16-bit displacement from table base',
                         scope='Static instruction/table audit with recovered scanf case correspondence; no unique compiler release or live switch trace claim',
                         entries=rows),indent=2))


if __name__=='__main__':main()
