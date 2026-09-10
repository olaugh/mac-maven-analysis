from pathlib import Path
import math
import random
import subprocess
import tempfile
import unittest

class LetterExpectationTests(unittest.TestCase):
    def test_exact_combinatorics_signed_wrap_and_truncation(self):
        root=Path(__file__).resolve().parents[1];rng=random.Random(1406)
        cases=[]
        for _ in range(300):
            total=rng.randrange(7,101);count=rng.randrange(total+1);scores=[rng.randrange(2**32) for _ in range(8)]
            draws=min(total-7,6);numerator=denominator=0
            for i in range(min(draws,count)+1):
                weight=math.comb(count,i)*(math.comb(total-count,draws-i) if draws-i<=total-count else 0)
                delta=(scores[i+1]-scores[0])&0xffffffff;delta=delta if delta<2**31 else delta-2**32
                numerator+=weight*delta;denominator+=weight
            assert denominator==math.comb(total,draws) and abs(numerator)<2**63
            expected=(abs(numerator)//denominator)*(-1 if numerator<0 else 1)&0xffffffff
            cases.append((total,count,scores,expected))
        source='#include "letter_expectation.h"\n#include <assert.h>\n#include <stddef.h>\nint main(void){assert(maven_letter_expectation(6,0,NULL)==0);\n'
        for total,count,scores,expected in cases:
            source+='{uint32_t s[]={'+','.join(str(x)+'u' for x in scores)+'};assert(maven_letter_expectation('+str(total)+','+str(count)+',s)=='+str(expected)+'u);}\n'
        source+='return 0;}\n'
        with tempfile.TemporaryDirectory() as temp:
            src=Path(temp)/'test.c';src.write_text(source);exe=Path(temp)/'test'
            subprocess.run(['cc','-std=c99','-Wall','-Wextra','-Werror','-fsanitize=undefined','-I',str(root/'reconstruction'),str(src),str(root/'reconstruction/letter_expectation.c'),'-o',str(exe)],check=True)
            subprocess.run([str(exe)],check=True,timeout=10)
