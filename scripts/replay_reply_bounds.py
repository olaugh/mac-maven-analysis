#!/usr/bin/env python3
"""Replay CODE27 bounds and CODE43 conflict tests; CODE39 arithmetic is reconstructed when prepared tables are captured; older traces supply mask values."""
import argparse,ctypes as C,hashlib,json,struct,subprocess,tempfile
from pathlib import Path
p=argparse.ArgumentParser(description=__doc__);p.add_argument('--capture',type=Path,default=Path('analysis/toolchain/reply-bounds-live.json'));a=p.parse_args();j=json.loads(a.capture.read_text());assert j['complete'];root=Path(__file__).resolve().parents[1]
for identity in j['identities']:
 rid=identity['code_resource'];assert hashlib.sha256((root/f'resources/CODE/{rid}_{rid}.bin').read_bytes()).hexdigest()==identity['sha256']
class Summary(C.Structure):_fields_=[('next',C.c_int16),('score_bits',C.c_uint32)]+[(n,C.c_uint8) for n in ['emptied_rack','kept_mask','row','column','length','identifier']]
class Cache(C.Structure):_fields_=[('best',C.c_uint32*128),('second',C.c_uint32*128),('replies',Summary*266),('first',C.c_int16),('summary_count',C.c_uint16)]
class Group(C.Structure):_fields_=[('valid',C.c_uint16),('bits',C.c_uint32)]
class Conflicts(C.Structure):_fields_=[('board',C.POINTER(C.c_uint8)),('matrix',C.c_void_p),('bit_masks',C.POINTER(C.c_uint32)),('groups',Group*8)]
paired=C.CFUNCTYPE(C.c_int16,C.c_void_p,C.c_int16,C.c_int16,C.POINTER(C.c_int16),C.POINTER(C.c_int16));own=C.CFUNCTYPE(C.c_int16,C.c_void_p,C.c_int16,C.POINTER(C.c_int16),C.POINTER(C.c_int16))
class RackBounds(C.Structure):_fields_=[(name,C.c_void_p) for name in ['own_a','own_b','own_error','other_a','other_b','other_error']]
class State(C.Structure):_fields_=[('cache',C.POINTER(Cache)),('conflicts',C.POINTER(Conflicts)),('points',C.POINTER(C.c_uint16)),('paired',paired),('own',own),('user',C.c_void_p)]
def bytearray_c(hex):return (C.c_uint8*(len(hex)//2)).from_buffer_copy(bytes.fromhex(hex))
def words(hex):return (C.c_uint16*(len(hex)//4))(*struct.unpack('>'+str(len(hex)//4)+'H',bytes.fromhex(hex)))
def longs(hex):return (C.c_uint32*(len(hex)//8))(*struct.unpack('>'+str(len(hex)//8)+'I',bytes.fromhex(hex)))
mask_calls=0;reconstructed_mask_calls=0
with tempfile.TemporaryDirectory() as tmp:
 library=Path(tmp)/'bounds.dylib';subprocess.run(['cc','-std=c99','-Wall','-Wextra','-Werror','-dynamiclib',*[str(root/f'reconstruction/{name}.c') for name in ['reply_bounds','endgame_move_cache','candidate_ranking','endgame_rack_bounds','rack_masks']],'-o',str(library)],check=True)
 lib=C.CDLL(str(library));fn=lib.maven_bound_move_against_replies;fn.argtypes=[C.POINTER(State),C.POINTER(C.c_uint8),C.POINTER(C.c_uint32),C.POINTER(C.c_uint32),C.POINTER(C.c_int16),C.POINTER(C.c_int16)];fn.restype=C.c_int
 lib.maven_build_reply_conflict_map.argtypes=[C.c_void_p,C.POINTER(C.c_uint8),C.POINTER(Cache),C.POINTER(C.c_uint32)]
 lib.maven_bound_own_rack.argtypes=[C.c_void_p,C.c_int16,C.POINTER(C.c_int16),C.POINTER(C.c_int16)];lib.maven_bound_own_rack.restype=C.c_int16
 lib.maven_bound_paired_racks.argtypes=[C.c_void_p,C.c_int16,C.c_int16,C.POINTER(C.c_int16),C.POINTER(C.c_int16)];lib.maven_bound_paired_racks.restype=C.c_int16
 for i,call in enumerate(j['calls']):
  board=bytearray_c(call['board']);move=bytearray_c(call['move']);matrix=longs(call['matrix']);bits=longs(call['bit_masks']);points=words(call['tile_points']);conflicts=Conflicts(board,C.addressof(matrix),bits);cache=Cache();cache.first=0 if call['summaries'] else -1
  address_to_index={item['pointer']:index for index,item in enumerate(call['summaries'])}
  for index,item in enumerate(call['summaries']):
   fields=struct.unpack('>II6B',bytes.fromhex(item['raw']));summary=cache.replies[index];summary.next=address_to_index[fields[0]] if fields[0] else -1
   for (name,_),value in zip(Summary._fields_[1:],fields[1:]):setattr(summary,name,value)
  rebuilt_matrix=(C.c_uint32*(8*544))();lib.maven_build_reply_conflict_map(rebuilt_matrix,board,C.byref(cache),bits)
  assert bytes(rebuilt_matrix)==bytes(matrix),(i,'constructed conflict matrix')
  conflicts.matrix=C.addressof(rebuilt_matrix)
  if call.get('mask_tables'):
   rack_arrays={name:words(raw) for name,raw in call['mask_tables'].items()};rack_bounds=RackBounds(*[C.addressof(rack_arrays[name]) for name,_ in RackBounds._fields_])
  errors=[];remaining=iter(call['mask_calls']);used=[]
  def consume(kind,own_mask,other_mask,positive,negative):
   try:
    event=next(remaining);assert (kind,own_mask,other_mask)==(event['kind'],event['own'],event['other']);used.append(event)
    if call.get('mask_tables'):
     if kind=='paired':value=lib.maven_bound_paired_racks(C.byref(rack_bounds),own_mask,other_mask,positive,negative)
     else:value=lib.maven_bound_own_rack(C.byref(rack_bounds),own_mask,positive,negative)
     assert (value&65535,positive[0],negative[0])==(event['result'],event['positive'],event['negative']);return value
    positive[0]=event['positive'];negative[0]=event['negative'];return event['result'] if event['result']<32768 else event['result']-65536
   except Exception as exc:errors.append(repr(exc));positive[0]=negative[0]=0;return 0
  state=State(C.pointer(cache),C.pointer(conflicts),points,paired(lambda _,x,y,p,n:consume('paired',x,y,p,n)),own(lambda _,x,p,n:consume('own',x,None,p,n)),None)
  upper=C.c_uint32(call['upper']);lower=C.c_uint32(call['lower']);empty=C.c_int16();compatible=C.c_int16();pruned=fn(C.byref(state),move,C.byref(upper),C.byref(lower),C.byref(empty),C.byref(compatible));expected=call['result']
  assert not errors,(i,errors);assert next(remaining,None) is None
  actual=(pruned,upper.value,lower.value,empty.value,compatible.value);wanted=tuple(expected[n] for n in ['pruned','upper','lower','empty','compatible']);assert actual==wanted,(i,actual,wanted)
  groups=b''.join(struct.pack('>HI',g.valid,g.bits) for g in conflicts.groups).hex();assert groups==expected['groups'],(i,'conflict cache')
  actual_summaries=[];index=cache.first;seen=set()
  while index>=0:
   assert index not in seen;seen.add(index);item=call['summaries'][index];summary=cache.replies[index];next_address=call['summaries'][summary.next]['pointer'] if summary.next>=0 else 0
   actual_summaries.append(dict(pointer=item['pointer'],raw=struct.pack('>II6B',next_address,*[getattr(summary,name) for name,_ in Summary._fields_[1:]]).hex()));index=summary.next
  assert actual_summaries==expected['summaries'],(i,'reply order or fields');mask_calls+=len(used)
  if call.get('mask_tables'):reconstructed_mask_calls+=len(used)
print(json.dumps(dict(scope=__doc__,calls=len(j['calls']),observed_mask_calls=mask_calls,reconstructed_mask_calls=reconstructed_mask_calls,all_bounds_conflicts_flags_and_reply_order_match=True)))
