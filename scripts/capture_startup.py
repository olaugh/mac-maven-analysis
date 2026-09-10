#!/usr/bin/env python3
"""Find Maven startup through GetResource and capture its real global writer.

Select Maven in Finder first. --launch-selected issues Command-O. Uses only
breakpoints/reads: no injected function calls, register writes or memory writes.
All guest pointers are derived from this run and verified against CODE 1.
Leaves the emulator paused and removes its own breakpoints.
"""
import argparse
import hashlib
import json
import struct
import time
from pathlib import Path
from gdb_remote import Remote
from qmp_session import command


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('--code-dir', type=Path, default=Path('resources/CODE'))
    p.add_argument('--output-dir', type=Path, required=True)
    p.add_argument('--launch-selected', action='store_true')
    p.add_argument('--max-calls', type=int, default=1500)
    p.add_argument('--timeout', type=float, default=120,
                   help='wall-clock deadline in seconds, including unrelated resource calls')
    args = p.parse_args()
    args.output_dir.mkdir(parents=True, exist_ok=True)
    code = (args.code_dir/'1_1.bin').read_bytes()
    below = struct.unpack_from('>I', (args.code_dir/'0_0.bin').read_bytes(), 4)[0]
    command('stop')
    r = Remote()
    points = set()
    counts = {}
    try:
        r.command('?')
        assert r.command('m40800000,10') == 'f1acad130000002a067c4efa00804efa'
        xml = r.command('qXfer:features:read:m68k-core.xml:0,fff')
        import re
        assert re.findall(r'<reg name="([^"]+)"', xml) == (
            [f'd{i}' for i in range(8)] + [f'a{i}' for i in range(6)] + ['fp','sp','ps','pc'])
        # Current 68k toolbox trap table: 0xe00 + (A9A0 & 0x3ff)*4.
        handler = int(r.command('m1480,4'), 16)
        assert r.command(f'Z0,{handler:x},2') == 'OK'
        points.add(handler)
        r.command('c', wait=False)
        if args.launch_selected:
            time.sleep(.1)
            command('human-monitor-command', {'command-line':'sendkey meta_l-o 30'})
        deadline = time.monotonic() + args.timeout
        for _ in range(args.max_calls):
            if time.monotonic() >= deadline:
                raise TimeoutError('Startup deadline reached; confirm Maven is selected in Finder')
            r.receive()
            assert r.command(f'z0,{handler:x},2') == 'OK'
            points.remove(handler)
            registers = struct.unpack('>18I', bytes.fromhex(r.command('g')))
            if registers[17] != handler:
                raise RuntimeError('unexpected debugger stop')
            stack = bytes.fromhex(r.command(f'm{registers[15]:x},10'))
            return_pc, rid = struct.unpack_from('>IH', stack)
            kind = stack[6:10].decode('mac_roman')
            counts[kind] = counts.get(kind, 0) + 1
            if kind == 'ZERO' and rid == 0:
                base = return_pc - 0x54
                candidate = r.command(f'm{base:x},{len(code):x}')
                if not candidate.startswith('E') and bytes.fromhex(candidate) == code:
                    break
            # Resume over the handler instruction before reinserting its breakpoint.
            r.command('s')
            assert r.command(f'Z0,{handler:x},2') == 'OK'
            points.add(handler)
            r.command('c', wait=False)
        else:
            raise RuntimeError('Maven startup was not observed within the call limit')
        a5 = registers[13]
        bottom = int(r.command('m908,4'),16)
        assert bottom == a5 - below
        before = bytes.fromhex(r.command(f'm{bottom:x},{below:x}'))
        end = base + 0xa8
        assert r.command(f'Z0,{end:x},2') == 'OK'
        points.add(end)
        r.command('c')
        after_registers = struct.unpack('>18I', bytes.fromhex(r.command('g')))
        assert after_registers[17] == end and after_registers[13] == a5
        after = bytes.fromhex(r.command(f'm{bottom:x},{below:x}'))
        (args.output_dir/'globals-before.bin').write_bytes(before)
        (args.output_dir/'globals-after.bin').write_bytes(after)
        report = dict(code1_base=base, a5=a5, below_a5=below,
                      initialization_end_pc=end, getresource_handler=handler,
                      prior_resource_calls=counts, code1_exact_match=True,
                      code1_sha256=hashlib.sha256(code).hexdigest(), lowmem_0908=f'{bottom:08x}',
                      before_sha256=hashlib.sha256(before).hexdigest(),
                      actual_sha256=hashlib.sha256(after).hexdigest())
        (args.output_dir/'startup-capture.json').write_text(json.dumps(report,indent=2)+'\n')
        print(json.dumps(report,indent=2))
    finally:
        command('stop')
        # A stop notification may remain after a timeout; query responses should
        # not be trusted in that case. Close without attempting new work.
        for addr in points:
            r.command(f'z0,{addr:x},2')
        r.close()


if __name__ == '__main__':
    main()
