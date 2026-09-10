"""Independent numeric/order oracle for statically recovered CODE3 ranking."""
import ctypes
from pathlib import Path
import random
import struct
import subprocess
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]
MASK = (1 << 32) - 1

def signed(v):
    return (v & MASK) if (v & MASK) < (1 << 31) else (v & MASK) - (1 << 32)

def divide(a, b):
    return (abs(a) // abs(b)) * (-1 if (a < 0) != (b < 0) else 1)

class CandidateRankingTests(unittest.TestCase):
    def test_numeric_order_ties_and_metadata(self):
        with tempfile.TemporaryDirectory() as tmp:
            lib = Path(tmp) / 'ranking.dylib'
            subprocess.run(['cc', '-shared', '-fPIC', '-std=c99', '-Wall', '-Wextra',
                            '-Werror', str(ROOT / 'reconstruction/candidate_ranking.c'),
                            '-o', str(lib)], check=True)
            api = ctypes.CDLL(str(lib))
            api.maven_rank_sampled_candidates.argtypes = [ctypes.c_void_p, ctypes.c_size_t, ctypes.c_void_p]
            api.maven_keep_better_move.argtypes = [ctypes.c_void_p, ctypes.c_void_p]
            rng = random.Random(0x301A2)
            for trial in range(300):
                count = rng.randrange(1, 65)
                samples = rng.choice([0, 1, 2, 3, 100, MASK, 1 << 31, rng.getrandbits(32)])
                half = divide(signed(samples or 1), 2)
                source, expected = bytearray(), []
                for i in range(count):
                    record = bytearray(rng.randbytes(46))
                    record[:16] = bytes([i]) * 16
                    total = rng.choice([0, 100, MASK, rng.getrandbits(32)])
                    struct.pack_into('>I', record, 34, total)
                    struct.pack_into('>I', record, 42, samples if i == 0 else rng.getrandbits(32))
                    source.extend(record)
                    average = divide(signed(total + half), signed(samples or 1)) & MASK
                    term0, term1 = struct.unpack_from('>II', record, 16)
                    struct.pack_into('>I', record, 24, (average - term0 - term1) & MASK)
                    expected.append((signed(average), bytes(record[:34])))
                expected.sort(key=lambda pair: -pair[0])
                output = ctypes.create_string_buffer(count * 34)
                self.assertEqual(api.maven_rank_sampled_candidates(bytes(source), count, output), 1)
                self.assertEqual(output.raw, b''.join(row for _, row in expected))
            self.assertEqual(api.maven_rank_sampled_candidates(None, 0, None), 1)
            self.assertEqual(api.maven_rank_sampled_candidates(None, 65, None), 0)
            incumbent = ctypes.create_string_buffer(34)
            candidate = bytearray(34)
            candidate[0] = 99
            self.assertEqual(api.maven_keep_better_move(incumbent, bytes(candidate)), 0)
            self.assertEqual(incumbent.raw, bytes(34))
            struct.pack_into('>III', candidate, 16, 0x7fffffff, 1, 1)
            self.assertEqual(api.maven_keep_better_move(incumbent, bytes(candidate)), 0)
            struct.pack_into('>III', candidate, 16, MASK, 2, 0)
            self.assertEqual(api.maven_keep_better_move(incumbent, bytes(candidate)), 1)
            self.assertEqual(incumbent.raw, bytes(candidate))
