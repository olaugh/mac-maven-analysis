// node web/tools/test_dawg_compiler.mjs [scratch/maven-rebuilt.dawg]
// Asserts the JS compiler output is byte-identical to the Python compiler's
// output (and to the shipped original when fed the original's own words).
import { readFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import { dirname, join } from 'node:path';
import { compileDawg, parseWordList, unpackFile, enumerateSection } from '../dawg_compiler.js';

const here = dirname(fileURLToPath(import.meta.url));
const web = join(here, '..');
const same = (a, b) => a.length === b.length && a.every((x, i) => x === b[i]);
function check(name, got, want) {
  if (same(got, want)) { console.log(`PASS ${name}: ${got.length} bytes identical`); return; }
  let i = 0; while (i < Math.min(got.length, want.length) && got[i] === want[i]) i++;
  console.log(`FAIL ${name}: lengths ${got.length} vs ${want.length}, first difference at byte ${i}`);
  process.exitCode = 1;
}

// 1. Extracted Maven lists -> must equal the Python output for the same lists.
const pyRebuilt = process.argv[2];
if (pyRebuilt) {
  const s1 = parseWordList(readFileSync(join(here, 'lexica/maven-s1.txt'), 'utf8'));
  const s2 = parseWordList(readFileSync(join(here, 'lexica/maven-s2.txt'), 'utf8'));
  let t = Date.now();
  const out = compileDawg(s1, s2);
  console.log(`compiled maven-s1/s2 (${s1.size}/${s2.size} words) in ${Date.now() - t} ms`);
  check('maven-s1/s2 vs Python build_dawg.py output', out, readFileSync(pyRebuilt));
}

// 2. The original file's own words (including its three trailing-space
//    words) -> must reproduce the original file exactly.
const original = readFileSync(join(web, 'dictionaries/MAVEN-1995.dawg'));
const { sections } = unpackFile(original);
const words = sections.map(({ entries, rootIndex }) => enumerateSection(entries, rootIndex));
console.log(`original words: S1 ${words[0].size}, S2 ${words[1].size}`);
check('original words -> MAVEN-1995.dawg', compileDawg(words[0], words[1]), original);

// 3. Modern lists with normalisation -> must equal the Python-built files.
const lexica = '/Users/john/sources/jan14-aviary/magpie-pr-619/data/lexica/';
for (const [a, b] of [['NWL23', 'CSW24'], ['NWL20', 'CSW21'], ['TWL06', 'CSW24']]) {
  const opt = { minLength: 2, maxLength: 15 };
  const s1 = parseWordList(readFileSync(`${lexica}${a}.txt`, 'utf8'), opt);
  const s2 = parseWordList(readFileSync(`${lexica}${b}.txt`, 'utf8'), opt);
  check(`${a}-${b}.dawg`, compileDawg(s1, s2), readFileSync(join(web, `dictionaries/${a}-${b}.dawg`)));
}
