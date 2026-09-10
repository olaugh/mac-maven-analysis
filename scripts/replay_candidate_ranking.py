#!/usr/bin/env python3
"""Replay original ranking captures through the portable C implementation."""
import argparse
import ctypes
import json
from pathlib import Path
import subprocess

ROOT = Path(__file__).resolve().parents[1]
class CandidateList(ctypes.Structure):
    _fields_ = [('moves', ctypes.c_ubyte * 340), ('count', ctypes.c_uint16), ('cutoff_bits', ctypes.c_uint32)]


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('--capture', type=Path, default=ROOT / 'analysis/toolchain/candidate-top10-filter-live.json')
    a = p.parse_args()
    capture = json.loads(a.capture.read_text())
    build = ROOT / '.build'
    build.mkdir(exist_ok=True)
    library = build / 'candidate-ranking.dylib'
    subprocess.run(['cc', '-shared', '-fPIC', '-O2', '-std=c99', '-Wall', '-Wextra', '-Werror',
                    str(ROOT / 'reconstruction/candidate_ranking.c'), '-o', str(library)], check=True)
    api = ctypes.CDLL(str(library))
    callback_type = ctypes.CFUNCTYPE(ctypes.c_int, ctypes.c_void_p, ctypes.c_void_p)
    api.maven_insert_ranked_candidate.argtypes = [ctypes.POINTER(CandidateList), ctypes.c_void_p, callback_type, ctypes.c_void_p]
    api.maven_accept_word_improvement.argtypes = [ctypes.POINTER(CandidateList), ctypes.c_void_p]
    api.maven_candidate_is_eligible.argtypes = [ctypes.c_void_p, ctypes.c_void_p, ctypes.c_int16, callback_type, ctypes.c_void_p]
    api.maven_keep_better_move.argtypes = [ctypes.c_void_p, ctypes.c_void_p]
    api.maven_rank_sampled_candidates.argtypes = [ctypes.c_void_p, ctypes.c_size_t, ctypes.c_void_p]
    skipped, filtered, inserted = 0, 0, 0
    for index, call in enumerate(capture['calls']):
        if capture['mode'] == 'top10':
            state = CandidateList()
            raw = bytes.fromhex(call['initial']['moves'])
            ctypes.memmove(state.moves, raw, 340)
            state.count = call['initial']['count']
            state.cutoff_bits = call['initial']['cutoff_bits']
            invoked = []
            def eligible(user, move):
                invoked.append(True)
                if 'eligibility_mode' not in call:
                    return call['eligibility_result'] or 0
                extra = call['extra_filter_pointer']
                def duplicate(unused, candidate):
                    return api.maven_accept_word_improvement(ctypes.byref(state), candidate)
                if extra:
                    assert extra - capture['a5'] == 0xad2, ('unsupported extra filter', hex(extra))
                    extra_callback = callback_type(duplicate)
                else:
                    extra_callback = callback_type()
                result = api.maven_candidate_is_eligible(move, bytes.fromhex(call['board']), call['eligibility_mode'], extra_callback, None)
                assert result == call['eligibility_result'], (index, 'eligibility result')
                actual = dict(moves=bytes(state.moves).hex(), count=state.count, cutoff_bits=state.cutoff_bits)
                assert actual == call['after_eligibility'], (index, 'eligibility side effects')
                return result
            errors = []
            def checked_eligible(user, move):
                try:
                    return eligible(user, move)
                except BaseException as error:
                    errors.append(error)
                    return 0
            callback = callback_type(checked_eligible)
            inserted += api.maven_insert_ranked_candidate(ctypes.byref(state), bytes.fromhex(call['candidate']), callback, None)
            if errors:
                raise errors[0]
            assert bool(invoked) == (call['eligibility_result'] is not None), (index, 'callback ordering')
            skipped += not invoked
            filtered += bool(invoked) and not call['eligibility_result']
            result = dict(moves=bytes(state.moves).hex(), count=state.count, cutoff_bits=state.cutoff_bits)
            assert result == call['result'], (index, result, call['result'])
        elif capture['mode'] == 'best':
            result = ctypes.create_string_buffer(bytes.fromhex(call['incumbent']), 34)
            api.maven_keep_better_move(result, bytes.fromhex(call['candidate']))
            assert result.raw.hex() == call['result'], index
        else:
            result = ctypes.create_string_buffer(call['count'] * 34)
            assert api.maven_rank_sampled_candidates(bytes.fromhex(call['entries']), call['count'], result)
            assert result.raw.hex() == call['output'], index
    print(json.dumps(dict(scope=('Portable ranking and eligibility replay' if 'eligibility_mode' in capture['calls'][0] else 'Portable ranking replay; eligibility callback supplied from original trace'),
                         mode=capture['mode'], calls=len(capture['calls']), inserted=inserted,
                         cutoff_skips=skipped, eligibility_rejections=filtered, all_matched=True)))

if __name__ == '__main__':
    main()
