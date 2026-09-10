#!/usr/bin/env python3
"""Read-only CODE3 ranking trace after natural application entry; no memory injection."""
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
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output', type=Path, required=True)
    parser.add_argument('--count', type=int, default=16)
    parser.add_argument('--mode', choices=['best', 'sampled', 'top10'], default='best')
    args = parser.parse_args()
    command('stop')
    remote = Remote()
    remote.sock.settimeout(60)
    breakpoints = set()

    def read(address, size):
        return bytes.fromhex(remote.command(f'm{address:x},{size:x}'))

    def regs():
        return struct.unpack('>18I', bytes.fromhex(remote.command('g')))

    def add(address):
        assert remote.command(f'Z0,{address:x},2') == 'OK'
        breakpoints.add(address)

    def clear():
        for address in list(breakpoints):
            assert remote.command(f'z0,{address:x},2') == 'OK'
            breakpoints.remove(address)

    def run(address):
        add(address)
        remote.command('c')
        assert regs()[17] == address
        clear()

    report = {'scope': 'Natural candidate-ranking calls; exact original resource, ROM and register identity; no memory injection',
              'mode': args.mode, 'calls': []}
    try:
        remote.command('?')
        assert read(0x40800000, 16).hex() == 'f1acad130000002a067c4efa00804efa'
        xml = remote.command('qXfer:features:read:m68k-core.xml:0,fff')
        assert re.findall(r'<reg name="([^"]+)"', xml) == [f'd{i}' for i in range(8)] + [f'a{i}' for i in range(6)] + ['fp', 'sp', 'ps', 'pc']
        a5 = int.from_bytes(read(0x904, 4), 'big')
        code0 = Path('resources/CODE/0_0.bin').read_bytes()
        slots = {}
        for i in range((len(code0) - 16) // 8):
            offset, push, rid, trap = struct.unpack_from('>4H', code0, 16 + 8*i)
            if rid == (28 if args.mode == 'top10' else 3):
                slots[a5 + 34 + 8*i] = offset + 4
        rid = 28 if args.mode == 'top10' else 3
        print(f'Waiting for actual CODE{rid} entry; trigger Kibitz or game search', flush=True)
        for slot in slots:
            add(slot)
        remote.command('c')
        slot = regs()[17]
        assert slot in slots
        clear()
        stub = read(slot, 6)
        if stub == bytes.fromhex('3f3c') + rid.to_bytes(2, 'big') + bytes.fromhex('a9f0'):
            remote.command('s')
            remote.command('s')
            run(slot)
            stub = read(slot, 6)
        assert stub[:2] == bytes.fromhex('4ef9')
        base = int.from_bytes(stub[2:], 'big') - slots[slot]
        code = Path(f'resources/CODE/{rid}_{rid}.bin').read_bytes()
        assert read(base + 4, len(code) - 4) == code[4:]
        report.update(code_resource=rid, code_sha256=hashlib.sha256(code).hexdigest(), a5=a5, code_base=base)
        print(f'CODE{rid} identity verified; waiting for ' + args.mode, flush=True)
        for attempt in range(args.count):
            run(base + (0x1a2 if args.mode == 'best' else 4))
            sp = regs()[15]
            arg = int.from_bytes(read(sp + 4, 4), 'big')
            return_pc = int.from_bytes(read(sp, 4), 'big')
            if args.mode == 'top10':
                def state():
                    return dict(moves=read(a5 - 0x5a10, 340).hex(), count=int.from_bytes(read(a5 - 0x30fc, 2), 'big'), cutoff_bits=int.from_bytes(read(a5 - 0xade, 4), 'big'))
                call = dict(candidate=read(arg, 34).hex(), initial=state(), board=read(a5 - 0x4302, 544).hex(), eligibility_mode=int.from_bytes(read(a5 - 0x4e2a, 2), 'big', signed=True), extra_filter_pointer=int.from_bytes(read(a5 - 0x4c1e, 4), 'big'))
                add(return_pc)
                add(base + 0x32)
                remote.command('c')
                stopped = regs()
                clear()
                if stopped[17] == base + 0x32:
                    call['eligibility_result'] = stopped[0] & 0xffff
                    call['after_eligibility'] = state()
                    run(return_pc)
                else:
                    assert stopped[17] == return_pc
                    call['eligibility_result'] = None
                call['result'] = state()
            elif args.mode == 'best':
                call = dict(candidate=read(arg, 34).hex(), incumbent=read(a5 - 0x5a32, 34).hex())
                run(return_pc)
                call['result'] = read(a5 - 0x5a32, 34).hex()
            else:
                count = int.from_bytes(read(arg + 12, 2), 'big', signed=True)
                assert 0 <= count <= 64
                call = dict(count=count, entries=read(arg + 24, max(count, 1)*46).hex())
                run(base + 0x132)
                call['output'] = read(regs()[14] - 0x8c0, count*34).hex()
            report['calls'].append(call)
            args.output.write_text(json.dumps(report, indent=2) + '\n')
            print('Captured', attempt + 1, flush=True)
    finally:
        cleanup = cleanup_breakpoints(remote, breakpoints)
        if 'report' in locals() and args.output.exists():
            report['cleanup'] = cleanup
            args.output.write_text(json.dumps(report, indent=2) + '\n')

if __name__ == '__main__':
    main()
