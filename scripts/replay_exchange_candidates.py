#!/usr/bin/env python3
"""Compare the original exchange stream, adjusted lookups and retained ranking."""
import argparse,ctypes,json,struct,subprocess
from pathlib import Path
from replay_candidate_ranking import CandidateList
ROOT=Path(__file__).resolve().parents[1]
Value=ctypes.CFUNCTYPE(ctypes.c_int16,ctypes.c_void_p,ctypes.c_ubyte)
Emit=ctypes.CFUNCTYPE(None,ctypes.c_void_p,ctypes.c_void_p)
Diagnostic=ctypes.CFUNCTYPE(None,ctypes.c_void_p)
Filter=ctypes.CFUNCTYPE(ctypes.c_int,ctypes.c_void_p,ctypes.c_void_p)
class Exchange(ctypes.Structure):
    _fields_=[('rack',ctypes.c_void_p),('sorted_rack',ctypes.c_void_p),('canonical_masks',ctypes.c_void_p),('mask_count',ctypes.c_int16),('leave_values',ctypes.c_void_p),('leave_offset',ctypes.c_int16),('unseen_total',ctypes.c_int16),('opening',ctypes.c_int),('opening_score_zero',ctypes.c_uint16),('opening_score_five',ctypes.c_uint16),('adjusted_letter_value',Value),('candidate',Emit),('diagnostic',Diagnostic),('user',ctypes.c_void_p),('retained_count',ctypes.POINTER(ctypes.c_uint16))]
def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--capture',type=Path,default=ROOT/'analysis/toolchain/exchange-generator-live.json');a=p.parse_args()
    j=json.loads(a.capture.read_text());assert j['complete'] and j['exchange'];buffers=[]
    def buf(raw):
        b=ctypes.create_string_buffer(raw);buffers.append(b);return ctypes.addressof(b)
    def words(hexdata,kind):
        b=bytes.fromhex(hexdata);v=struct.unpack('>'+str(len(b)//2)+('h' if kind==ctypes.c_int16 else 'H'),b);o=(kind*len(v))(*v);buffers.append(o);return ctypes.addressof(o)
    build=ROOT/'.build';build.mkdir(exist_ok=True);library=build/'exchange-candidates.dylib'
    subprocess.run(['cc','-shared','-fPIC','-std=c99','-O2','-Wall','-Wextra','-Werror',*[str(ROOT/f'reconstruction/{n}.c') for n in ['exchange_candidates','rack_masks','candidate_ranking']],'-o',str(library)],check=True)
    api=ctypes.CDLL(str(library));api.maven_generate_exchange_candidates.argtypes=[ctypes.POINTER(Exchange)]
    api.maven_insert_ranked_candidate.argtypes=[ctypes.POINTER(CandidateList),ctypes.c_void_p,Filter,ctypes.c_void_p]
    api.maven_accept_word_improvement.argtypes=[ctypes.POINTER(CandidateList),ctypes.c_void_p]
    s=Exchange();s.rack=buf(bytes.fromhex(j['initial']['rack']));s.sorted_rack=buf(j['initial']['sorted_rack'].encode());s.canonical_masks=words(j['initial']['canonical_masks'],ctypes.c_int16);s.mask_count=j['initial']['mask_count'];s.leave_values=words(j['initial']['leave_values'],ctypes.c_uint16);s.leave_offset=j['leave_offset'];s.unseen_total=j['initial']['unseen_total'];s.opening=j['opening'];s.opening_score_zero=j['fixed']['opening_scores'][0]&65535;s.opening_score_five=j['fixed']['opening_scores'][5]&65535
    ranking=CandidateList();initial=j['initial']['ranking'];ctypes.memmove(ranking.moves,bytes.fromhex(initial['moves']),340);ranking.count=initial['count'];ranking.cutoff_bits=initial['cutoff_bits']
    s.retained_count=ctypes.cast(ctypes.byref(ranking,CandidateList.count.offset),ctypes.POINTER(ctypes.c_uint16))
    errors=[];lookups=[];moves=[];expected=iter(j['letter_lookups'])
    def lookup(u,letter):
        e=next(expected);lookups.append(letter)
        if e['letter']!=letter:errors.append(('lookup order',letter,e))
        return e['value']
    extra=j['extra_filter_pointer'];assert not extra or extra-j['a5']==0xad2
    eligible=Filter(lambda u,m:api.maven_accept_word_improvement(ctypes.byref(ranking),m) if extra else 1)
    def emit(u,m):
        moves.append(ctypes.string_at(m,34).hex());api.maven_insert_ranked_candidate(ctypes.byref(ranking),m,eligible,None)
    value=Value(lookup);callback=Emit(emit);diagnostic=Diagnostic(lambda u:errors.append('diagnostic'));s.adjusted_letter_value=value;s.candidate=callback;s.diagnostic=diagnostic
    api.maven_generate_exchange_candidates(ctypes.byref(s));assert not errors,errors
    assert len(moves)==len(j['exchange_moves'])
    for i,(actual,wanted) in enumerate(zip(moves,j['exchange_moves'])):assert actual==wanted,(i,actual,wanted)
    assert dict(moves=bytes(ranking.moves).hex(),count=ranking.count,cutoff_bits=ranking.cutoff_bits)==j['final']['ranking']
    assert len(lookups)==len(j['letter_lookups'])
    print(json.dumps(dict(scope='Complete exchange stream and top-ten state including final count truncation; original adjusted-letter values and leave table supplied',exchanges=len(moves),all_matched=True)))
if __name__=='__main__':main()
