#!/usr/bin/env python3
"""Build local MAGPIE move-choice data from Maven's recovered word enumerator.
The test-only callback resets the Word List UI's 1000-result counter, allowing
complete enumeration without changing reconstructed source. Reject padded
non-word records rather than silently turning them into new playable words.
"""
import hashlib,json,subprocess,tempfile
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1];MAG=ROOT/'../../magpie-pr-619'
def main():
 dictionary=ROOT/'../../media/maven/session/share/maven2.1';assert hashlib.sha256(dictionary.read_bytes()).hexdigest()=='2619382321bca5b52967b3515d15b0592a8e1f641bce92f65edcf06ba10edb19'
 with tempfile.TemporaryDirectory() as tmp:
  tmp=Path(tmp);source=(ROOT/'scripts/word_enumerator_probe.c').read_text().replace('puts((const char *)word);','puts((const char *)word); state.result_count=0;');(tmp/'dump.c').write_text(source)
  names=['word_enumerator','query_prepare','dictionary_lookup','dictionary_setup','dictionary_tables','whole_file','error_context']
  subprocess.run(['cc','-O2','-I'+str(ROOT/'scripts'),'-I'+str(ROOT/'reconstruction'),str(tmp/'dump.c'),*[str(ROOT/f'reconstruction/{n}.c') for n in names],'-o',str(tmp/'dump')],check=True)
  lines=subprocess.check_output([str(tmp/'dump'),str(dictionary),'?'*15,'','','','0'],text=True).upper().splitlines()
 words=sorted(set(w for w in lines if 2<=len(w)<=15 and all('A'<=c<='Z' for c in w)));rejected=sorted(set(lines)-set(words))
 lex=MAG/'data/lexica';(lex/'NWLMAVEN.txt').write_text('\n'.join(words)+'\n')
 for conversion in ['text2kwg','text2wordmap']:subprocess.run([str(MAG/'bin/magpie'),'convert',conversion,'NWLMAVEN','-savesettings','false'],cwd=MAG,check=True)
 (lex/'NWLMAVEN.klv2').write_bytes((lex/'CSW21.klv2').read_bytes())
 report=dict(scope=__doc__,words=len(words),rejected_records=rejected,leaves='CSW21: modern move choice only, not Maven valuation',files={p.name:hashlib.sha256(p.read_bytes()).hexdigest() for p in lex.glob('NWLMAVEN.*')})
 (ROOT/'analysis/toolchain/magpie-maven-lexicon.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report,indent=2))
if __name__=='__main__':main()
