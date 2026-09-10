from collections import Counter
import ctypes as C
from itertools import combinations
from math import comb
from pathlib import Path
import random
import subprocess
import tempfile
import unittest

class OpponentSamplesTests(unittest.TestCase):
    def test_enumeration_matches_labelled_tile_subsets(self):
        root=Path(__file__).resolve().parents[1]
        byte=C.c_uint8;word=C.c_uint16;bp=C.POINTER(byte)
        callback=C.CFUNCTYPE(C.c_int16,C.c_void_p,bp,C.c_uint32)
        choose=((word*8)*18)(*[(word*8)(*[comb(n,k) if k<=n else 0 for k in range(8)]) for n in range(18)])
        with tempfile.TemporaryDirectory() as tmp:
            library=Path(tmp)/'samples.dylib'
            subprocess.run(['cc','-std=c99','-Wall','-Wextra','-Werror','-dynamiclib',str(root/'reconstruction/opponent_samples.c'),'-o',str(library)],check=True)
            lib=C.CDLL(str(library));fn=lib.maven_enumerate_opponent_samples;fn.argtypes=[bp,bp,C.c_void_p,callback,C.c_void_p];fn.restype=C.c_int16
            rng=random.Random(380046)
            for tiles in ['','abcdef','abcdefg','aaaaaaaaaaaaaaaaa','aaabbbccccdd','?aaaaabbbccddeeff']+[''.join(rng.choice('?abcdefg') for _ in range(n)) for n in range(7,18)]:
                counts=(byte*128)();alphabet=(byte*9)(*b'?abcdefg\0')
                for tile in tiles:counts[ord(tile)]+=1
                expected=Counter(''.join(sorted(tiles[i] for i in subset)) for subset in combinations(range(len(tiles)),7))
                found=[]
                def visit(_,rack,weight):found.append((C.string_at(rack).decode(),weight));return 0
                self.assertEqual(fn(counts,alphabet,choose,callback(visit),None),0)
                self.assertEqual(dict(found),expected)
                self.assertEqual([rack for rack,_ in found],sorted(expected,reverse=True))
                self.assertEqual(sum(weight for _,weight in found),comb(len(tiles),7) if len(tiles)>=7 else 0)
                before=bytes(counts);stopped=[]
                def stop(_,rack,weight):stopped.append(C.string_at(rack));return -7
                self.assertEqual(fn(counts,alphabet,choose,callback(stop),None),int(bool(expected)))
                self.assertEqual(len(stopped),int(bool(expected)));self.assertEqual(bytes(counts),before)
