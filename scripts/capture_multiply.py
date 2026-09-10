#!/usr/bin/env python3
"""Capture natural Maven calls at a verified, session-specific CODE 1 base.

Leaves the guest paused. Does not inject calls or write registers or guest data.
Breakpoints are removed on exit. A new game is optional, and is a UI action.
"""
import argparse
import hashlib
import json
import socket
import struct
import time
from pathlib import Path
from gdb_remote import Remote
from qmp_session import command


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('--base', required=True, type=lambda s: int(s, 0))
    p.add_argument('--code', required=True, type=Path)
    p.add_argument('--output', required=True, type=Path)
    p.add_argument('--count', type=int, default=32)
    p.add_argument('--new-game', action='store_true')
    a = p.parse_args()
    code = a.code.read_bytes()
    command('stop')
    r = Remote()
    points = set()
    rows = []
    try:
        r.command('?')
        actual = bytes.fromhex(r.command(f'm{a.base:x},{len(code):x}'))
        if actual != code:
            raise RuntimeError('live CODE 1 differs from the supplied binary')
        # Register order comes from this target's advertised XML, not host GDB.
        xml = r.command('qXfer:features:read:m68k-core.xml:0,fff')
        import re
        names = re.findall(r'<reg name="([^"]+)"', xml)
        assert names == [f'd{i}' for i in range(8)] + [f'a{i}' for i in range(6)] + ['fp','sp','ps','pc']
        pc = a.base + 0xee
        assert r.command(f'Z0,{pc:x},2') == 'OK'
        points.add(pc)
        for index in range(a.count):
            r.command('c', wait=False)
            if index == 0 and a.new_game:
                time.sleep(.1)
                command('human-monitor-command', {'command-line':'sendkey meta_l-n'})
            try:
                r.receive()
            except socket.timeout:
                command('stop')
                r.receive()
                break
            entry = struct.unpack('>18I', bytes.fromhex(r.command('g')))
            if entry[17] != pc:
                raise RuntimeError(f'unexpected stop at {entry[17]:x}')
            ret, left, right = struct.unpack('>3I', bytes.fromhex(r.command(f'm{entry[15]:x},c')))
            # QEMU's stub does not perform GDB's usual step-over on resume.
            assert r.command(f'z0,{pc:x},2') == 'OK'
            points.remove(pc)
            assert r.command(f'Z0,{ret:x},2') == 'OK'
            points.add(ret)
            r.command('c')
            after = struct.unpack('>18I', bytes.fromhex(r.command('g')))
            assert after[17] == ret
            assert r.command(f'z0,{ret:x},2') == 'OK'
            points.remove(ret)
            assert r.command(f'Z0,{pc:x},2') == 'OK'
            points.add(pc)
            rows.append(dict(left=left, right=right, result=after[0],
                             expected=(left*right)&0xffffffff,
                             entry_pc=pc, return_pc=ret, entry_sp=entry[15], return_sp=after[15],
                             d1_preserved=entry[1]==after[1],
                             d2_d5_preserved=entry[2:6]==after[2:6]))
    finally:
        command('stop')
        for addr in points:
            r.command(f'z0,{addr:x},2')
        r.close()
        a.output.write_text(json.dumps(dict(code_sha256=hashlib.sha256(code).hexdigest(),
                                            code_base=a.base, calls=rows),indent=2)+'\n')
    assert all(x['result']==x['expected'] and x['return_sp']==x['entry_sp']+12
               and x['d1_preserved'] and x['d2_d5_preserved'] for x in rows)
    print(f'Captured and verified {len(rows)} natural calls; guest paused.')


if __name__ == '__main__':
    main()
