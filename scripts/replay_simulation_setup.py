#!/usr/bin/env python3
"""Compare candidate seeding against two original first-batch configurations.

Lookahead overflow cases are static instruction-semantic checks, not live traces.
"""
import ctypes as C
import json
from pathlib import Path
import subprocess

subprocess.run(['cc', '-shared', '-fPIC', '-std=c99', '-Wall', '-Wextra', '-Werror',
                *[str(p) for p in Path('reconstruction').glob('*.c') if p.name != 'toolchain_probe.c'],
                '-o', '.build/simulation-setup.dylib'], check=True)
lib = C.CDLL('.build/simulation-setup.dylib')
seed = lib.maven_seed_simulation_candidates
seed.argtypes = [C.c_void_p, C.c_void_p, C.c_uint]
seed.restype = C.c_uint
plies = lib.maven_simulation_reply_plies
plies.argtypes = [C.c_int16]
plies.restype = C.c_int16
reports = []
for name in ['rollout-batch-live', 'rollout-exhaustive-live-01']:
    capture = json.loads(Path(f'analysis/toolchain/{name}.json').read_text())
    count = capture['candidate_count']
    expected = bytes.fromhex(capture['config'])[24:]
    moves = b''.join(expected[i*46:i*46+34] for i in range(count))
    output = C.create_string_buffer(64*46)
    assert seed(output, C.create_string_buffer(moves), count) == count
    assert output.raw[:count*46] == expected
    assert output.raw[count*46:] == bytes((64-count)*46)
    reports.append(dict(capture=name, candidates=count))
for lookahead, expected in [(-32768,2),(-1,2),(0,2),(1,2),(2,4),(16383,32766),(16384,-32768),(32767,-2)]:
    assert plies(lookahead) == expected
print(json.dumps(dict(scope=__doc__, captures=reports, static_word_cases=8, all_matched=True)))
