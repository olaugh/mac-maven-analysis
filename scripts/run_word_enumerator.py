#!/usr/bin/env python3
"""Run reconstructed Word List core on the fingerprinted Maven data fork.

This is an investigation driver, not a rebuilt Maven application. Default
lengths are 2..15; prefix/suffix '?' and rack blanks are supported.
"""
import argparse
import hashlib
import json
from pathlib import Path
import subprocess
import tempfile


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--data-file',type=Path,required=True)
    parser.add_argument('--rack',required=True)
    parser.add_argument('--prefix',default='')
    parser.add_argument('--suffix',default='')
    parser.add_argument('--on-board',default='')
    parser.add_argument('--bingos',action='store_true')
    args=parser.parse_args()
    for value in (args.rack,args.prefix,args.suffix,args.on_board):
        if len(value)>31 or any(c not in 'abcdefghijklmnopqrstuvwxyz?' for c in value):
            parser.error('Use at most 31 lowercase ASCII letters or ? per field')
    digest=hashlib.sha256(args.data_file.read_bytes()).hexdigest()
    assert digest=='2619382321bca5b52967b3515d15b0592a8e1f641bce92f65edcf06ba10edb19'
    root=Path(__file__).resolve().parents[1]
    with tempfile.TemporaryDirectory() as temp:
        exe=Path(temp)/'enumerate'
        subprocess.run(['cc','-std=c99','-Wall','-Wextra','-Werror',
                        '-I',str(root/'reconstruction'),
                        str(root/'scripts/word_enumerator_probe.c'),
                        str(root/'reconstruction/word_enumerator.c'),
                        str(root/'reconstruction/query_prepare.c'),
                        str(root/'reconstruction/dictionary_lookup.c'),
                        str(root/'reconstruction/dictionary_setup.c'),str(root/'reconstruction/dictionary_tables.c'),
                        str(root/'reconstruction/whole_file.c'),
                        str(root/'reconstruction/error_context.c'),
                        '-o',str(exe)],check=True)
        result=subprocess.run([str(exe),str(args.data_file.resolve()),args.rack,
                               args.prefix,args.suffix,args.on_board,str(int(args.bingos))],check=True,capture_output=True,text=True)
    words=result.stdout.splitlines()
    print(json.dumps(dict(data_sha256=digest,rack=args.rack,prefix=args.prefix,
                         suffix=args.suffix,on_board=args.on_board,bingos=args.bingos,
                         word_count=len(words),words=words,
                         scope='Reconstructed file loader, dictionary setup, normalized-ASCII preparation, and enumeration; native filesystem adapter and Toolbox/UI external'),indent=2))


if __name__=='__main__':main()
