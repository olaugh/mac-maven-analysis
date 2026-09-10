#!/usr/bin/env python3
"""Replay a naturally captured feature vector through reconstructed C."""
import argparse,ctypes as C,hashlib,json,struct,subprocess,tempfile
from pathlib import Path

def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--capture',type=Path,required=True);a=p.parse_args()
    root=Path(__file__).resolve().parents[1];j=json.loads(a.capture.read_text());before=j['initial'];after=j['after_placement']
    for identity in j['identities']+[dict(code_resource=31,sha256=j['code31_sha256'])]:
        rid=identity['code_resource'];assert hashlib.sha256((root/f'resources/CODE/{rid}_{rid}.bin').read_bytes()).hexdigest()==identity['sha256']
        source=(root/f'resources/CODE/{rid}_{rid}.bin').read_bytes()
        if 'verified_start' in identity:assert hashlib.sha256(source[identity['verified_start']:identity['verified_end']]).hexdigest()==identity['verified_range_sha256']
        for region in identity.get('additional_verified_ranges',[]):assert hashlib.sha256(source[region['start']:region['end']]).hexdigest()==region['sha256']
    byte=C.c_uint8;word=C.c_uint16;long=C.c_uint32;bp=C.POINTER(byte)
    counts0=(byte*128).from_buffer_copy(bytes.fromhex(before['counts']));counts1=(byte*128).from_buffer_copy(bytes.fromhex(after['counts']))
    records=(byte*len(bytes.fromhex(after['records']))).from_buffer_copy(bytes.fromhex(after['records']))
    ids=(word*(len(before['record_ids'])+1))(*before['record_ids'],0);weights=(word*(len(before['record_weights'])+1))(*before['record_weights'],0)
    callback=C.CFUNCTYPE(C.c_int16,C.c_void_p,C.c_int16)
    class Before(C.Structure):_fields_=[(x,C.c_int16) for x in ('j','q','x','z','blank','rack_length')]
    vowels=bytes.fromhex(before['vowels']).split(b'\0')[0];features=(long*22)()
    classify=callback(lambda _,letter:int(letter in vowels));remaining=C.create_string_buffer(bytes.fromhex(after['scored_remaining']))
    with tempfile.TemporaryDirectory() as temp:
        library=Path(temp)/'features.dylib';subprocess.run(['cc','-std=c99','-Wall','-Wextra','-Werror','-dynamiclib',str(root/'reconstruction/evaluation_features.c'),'-o',str(library)],check=True)
        lib=C.CDLL(str(library));lib.maven_prepare_evaluation_features.argtypes=[C.POINTER(long),bp,long,callback,C.c_void_p];lib.maven_prepare_evaluation_features.restype=Before
        snapshot=lib.maven_prepare_evaluation_features(features,counts0,len(bytes.fromhex(before['rack']).split(b'\0')[0]),classify,None)
        lib.maven_evaluation_record_flag_clear.argtypes=[bp,C.c_int16,C.c_int16];lib.maven_evaluation_record_flag_clear.restype=C.c_int16
        match=callback(lambda _,identifier:lib.maven_evaluation_record_flag_clear(records,after['record_count'],identifier))
        lib.maven_finish_evaluation_features.argtypes=[C.POINTER(long),C.POINTER(Before),bp,long,C.c_int16,C.c_void_p,C.c_int16,C.POINTER(word),C.POINTER(word),callback,C.c_void_p]
        score=int.from_bytes(bytes.fromhex(before['move'])[16:20],'big')
        lib.maven_finish_evaluation_features(features,C.byref(snapshot),counts1,score,after['occupied_before'],remaining,after['special_score'],ids,weights,match,None)
    assert list(features)==j['features'],(list(features),j['features'])
    print(json.dumps(dict(scope='Feature preparation/completion C replay with original record-collector outputs and observed before/after counts; not complete evaluation or ranking',all_22_features_match=True,collected_records=len(before['record_ids']),features=list(features),capture_sha256=hashlib.sha256(a.capture.read_bytes()).hexdigest()),indent=2))
if __name__=='__main__':main()
