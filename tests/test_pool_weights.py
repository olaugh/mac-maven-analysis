"""Independent physical-tile oracle for CODE42's multiset requirement weights."""
import ctypes as C
import itertools
import math
from pathlib import Path
import random
import subprocess
import tempfile
import unittest

ROOT=Path(__file__).resolve().parents[1]
U8=C.c_uint8;U16=C.c_uint16
class State(C.Structure):
    _fields_=[('unique_mask',U16),('total',U16),('multiple_letters',U8*28)]
class PoolWeightsTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.tmp=tempfile.TemporaryDirectory(prefix='maven-pool-weights-')
        library=Path(cls.tmp.name)/'weights.dylib'
        subprocess.run(['cc','-std=c99','-shared','-fPIC','-Wall','-Wextra','-Werror',str(ROOT/'reconstruction/pool_weights.c'),str(ROOT/'reconstruction/rack_masks.c'),'-o',str(library)],check=True)
        cls.lib=C.CDLL(str(library));cls.lib.maven_count_pool_racks.restype=U16
    @classmethod
    def tearDownClass(cls):cls.tmp.cleanup()
    def test_physical_draws(self):
        rng=random.Random(420036)
        pools=['abcdefg','aabcdefg','aaaabbbb','aaaabcdeffghi','aabbccddeeffgghh','??aaaabbcdefghij']
        pools += [''.join(sorted(rng.choices('abcdefgh',k=n))) for n in range(7,17)]
        choose=((U16*8)*17)(*[(U16*8)(*[math.comb(n,k) if k<=n else 0 for k in range(8)]) for n in range(17)])
        alphabet=(U8*28)(*b'?abcdefghijklmnopqrstuvwxyz\0')
        for pool in pools:
            self.assertLessEqual(max(pool.count(x) for x in pool),8)
            counts=(U8*128)();occ=((U16*8)*128)();distinct=(U8*28)();cache=(U16*48)(*([1234]*48));state=State()
            for x in pool:counts[ord(x)]+=1
            rack=(U8*(len(pool)+1))(*pool.encode(),0)
            self.lib.maven_build_occurrence_masks(rack,occ)
            self.lib.maven_prepare_pool_weights(C.byref(state),counts,alphabet,occ,distinct,cache)
            self.assertEqual(state.total,len(pool));self.assertEqual(bytes(distinct).split(b'\0')[0],''.join(sorted(set(pool))).encode())
            self.assertEqual(list(cache),[65535]*len(pool)+[1234]*(48-len(pool)))
            letters=sorted(set(pool));draws=[]
            for positions in itertools.combinations(range(len(pool)),7):
                draw=[pool[i] for i in positions];draws.append(tuple(draw.count(x) for x in letters))
            for trial in range(48):
                required=[rng.randrange(pool.count(x)+1) for x in letters]
                if sum(required)>7:continue
                mask=0
                for x,k in zip(letters,required):
                    indexes=[i for i,c in enumerate(pool) if c==x]
                    for i in indexes[:k]:mask |= 1<<i
                expected=sum(all(actual>=needed for actual,needed in zip(draw,required)) for draw in draws)
                before=bytes(counts)
                result=self.lib.maven_count_pool_racks(C.byref(state),counts,U16(mask),occ,choose)
                self.assertEqual(result,expected,(pool,required,mask));self.assertEqual(bytes(counts),before)

if __name__=='__main__':unittest.main()
