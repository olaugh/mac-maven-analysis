#!/usr/bin/env python3
"""Check native load/setup/query pipeline against four original Word List traces."""
import argparse
import hashlib
import json
from pathlib import Path
import subprocess

def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--data-file',type=Path,required=True)
    args=p.parse_args();data=args.data_file.read_bytes();digest=hashlib.sha256(data).hexdigest()
    subprocess.run(['make','all'],check=True,capture_output=True)
    assert digest=='2619382321bca5b52967b3515d15b0592a8e1f641bce92f65edcf06ba10edb19'
    cases=[('cat','cat','','',''),('blank','ca?','','',''),
           ('filtered','ca?','c?','t',''),('required','ca?','','','t')]
    reports=[]
    for label,rack,prefix,suffix,required in cases:
        path=Path(f'analysis/toolchain/word-enumerator-live-{label}.json')
        capture=json.loads(path.read_text());assert capture['code12_exact_match']
        assert hashlib.sha256(Path('resources/CODE/12_12.bin').read_bytes()).hexdigest()==capture['code12_sha256']
        result=subprocess.run(['.build/word-enumerator',str(args.data_file),rack,prefix,suffix,required,'0'],
                              capture_output=True,text=True,check=True,timeout=60)
        words=result.stdout.splitlines();assert words==capture['original_words']
        reports.append(dict(capture=path.name,capture_sha256=hashlib.sha256(path.read_bytes()).hexdigest(),
                            words=len(words),ordered_words_match=True,host_final_status=result.stderr.strip()))
    sources=['reconstruction/whole_file.c','reconstruction/dictionary_setup.c','reconstruction/dictionary_tables.c','reconstruction/query_prepare.c',
             'reconstruction/word_enumerator.c','reconstruction/dictionary_lookup.c','scripts/native_file_ops.h',
             'scripts/word_enumerator_probe.c']
    print(json.dumps(dict(scope='Native reconstructed load/setup/preparation/enumeration pipeline matches ordered words from four separate natural traces; not a full original UI session or full game',
                         data_sha256=digest,runs=reports,total_words=sum(r['words'] for r in reports),
                         source_sha256={s:hashlib.sha256(Path(s).read_bytes()).hexdigest() for s in sources}),indent=2))

if __name__=='__main__':main()
