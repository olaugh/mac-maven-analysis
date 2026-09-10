"""Compare normalized query preparation with original debugger captures."""
import json
from pathlib import Path
import subprocess
import tempfile
import unittest


class QueryPreparationTests(unittest.TestCase):
    def test_captured_preparation_and_instruction_derived_bingos(self):
        root = Path(__file__).resolve().parents[1]
        source = ['#include "query_prepare.h"', '#include <assert.h>',
                  '#include <string.h>', 'int main(void) {',
                  'MavenWordEnumeration s = {0}; uint8_t required[128];']
        cases = [('cat', 'cat', '', '', ''), ('blank', 'ca?', '', '', ''),
                 ('filtered', 'ca?', '', 'c?', 't'),
                 ('required', 'ca?', 't', '', '')]
        for name, rack, board, prefix, suffix in cases:
            state = json.loads((root / 'analysis/toolchain' /
                               f'word-enumerator-live-{name}.json').read_text())['before']
            args = ','.join('(const uint8_t *)' + json.dumps(x)
                            for x in (rack, board, prefix, suffix))
            source += ['memset(&s,0,sizeof s); s.minimum_length=2; s.maximum_length=15;',
                       f'maven_prepare_word_query(&s,{args},0,required);']
            for field in ('available', 'required_counts', 'occurrences'):
                for i, value in enumerate(state[field]):
                    source.append(f'assert(s.{field}[{i}]=={value});')
            for field in ('length', 'suffix_length', 'result_count', 'blanks_used',
                          'minimum_length', 'maximum_length'):
                source.append(f'assert(s.{field}=={state[field]});')
            for field in ('prefix', 'suffix', 'required_letters'):
                value = json.dumps(bytes.fromhex(state[field]).decode('ascii'))
                source.append(f'assert(!strcmp((const char *)s.{field},{value}));')
        source.append(r'''
/* Bingos expectations come from instructions, not a captured Bingos run.
 * The overlapping A counts take max; '?' is omitted from required letters.
 * Fixed suffix T raises availability without becoming a required count. */
memset(&s,0,sizeof s); s.word[1]='x'; s.occurrences['z']=7;
maven_prepare_word_query(&s,(const uint8_t *)"aab?",
    (const uint8_t *)"a?",(const uint8_t *)"",(const uint8_t *)"t",1,required);
assert(s.available['a']==2 && s.available['b']==1 && s.available['?']==2);
assert(s.available['t']==1 && s.required_counts['t']==0);
assert(s.required_counts['a']==2 && s.required_counts['b']==1);
assert(s.required_counts['?']==1 && !strcmp((const char *)required,"ab"));
assert(s.word[0]==0 && s.word[1]=='x' && s.occurrences['z']==7);
return 0; }
''')
        with tempfile.TemporaryDirectory() as temp:
            src = Path(temp) / 'test.c'
            src.write_text('\n'.join(source))
            exe = Path(temp) / 'test'
            subprocess.run(['cc', '-std=c99', '-Wall', '-Wextra', '-Werror',
                            '-I', str(root / 'reconstruction'), str(src),
                            str(root / 'reconstruction/query_prepare.c'),
                            '-o', str(exe)], check=True)
            subprocess.run([str(exe)], check=True, timeout=10)


if __name__ == '__main__':
    unittest.main()
