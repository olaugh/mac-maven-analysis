#!/usr/bin/env python3
"""Replay complete original tree operations; compare every node and free-list link."""
import argparse,ctypes as C,gzip,hashlib,json,struct,subprocess,tempfile
from collections import Counter
from pathlib import Path
p=argparse.ArgumentParser(description=__doc__);p.add_argument('--capture',type=Path,default=Path('analysis/toolchain/endgame-tree-live.json.gz'));a=p.parse_args()
raw=a.capture.read_bytes();j=json.loads(gzip.decompress(raw) if a.capture.suffix=='.gz' else raw);assert j['complete']
root=Path(__file__).resolve().parents[1];assert hashlib.sha256((root/'resources/CODE/30_30.bin').read_bytes()).hexdigest()==j['code_sha256']
class Node(C.Structure):
 _fields_=[('lower',C.c_int16),('upper',C.c_int16),('first_child',C.c_uint16),('next_sibling',C.c_uint16),('reserved_word',C.c_uint16),('move_score',C.c_int16),('position_hash',C.c_uint32),('placed_tiles',C.c_uint8*8)]+[(n,C.c_uint8) for n in ['adjustment_tag','kept_mask','row','column','emptied_rack','leave_tag','mark','reserved_byte']]
cb=C.CFUNCTYPE(None,C.c_void_p)
class Tree(C.Structure):_fields_=[('nodes',C.POINTER(Node)),('capacity',C.c_uint16),('free_head',C.c_uint16),('current',C.c_uint16),('diagnostic',cb),('poll',cb),('user',C.c_void_p)]
assert C.sizeof(Node)==32
fmt='>hhHHHhI8s8B';capacity=j['capacity'];pool=j['pool'];diagnostics=[]
def diagnostic(_):diagnostics.append('original-valid tree diagnostic')
def node_index(pointer):
 if not pointer:return capacity
 assert pool<=pointer<pool+capacity*32 and (pointer-pool)%32==0,hex(pointer)
 return (pointer-pool)//32
def unpack_nodes(raw):
 nodes=(Node*capacity)()
 for i in range(capacity):
  fields=struct.unpack_from(fmt,raw,32*i)
  for (name,_),value in zip(Node._fields_,fields):
   if name=='placed_tiles':nodes[i].placed_tiles[:]=value
   else:setattr(nodes[i],name,value)
 return nodes
def packed(nodes):return b''.join(struct.pack(fmt,*[bytes(getattr(n,name)) if name=='placed_tiles' else getattr(n,name) for name,_ in Node._fields_]) for n in nodes)
def bytearray_c(raw):return (C.c_uint8*len(raw)).from_buffer_copy(raw)
with tempfile.TemporaryDirectory() as tmp:
 library=Path(tmp)/'tree.dylib';subprocess.run(['cc','-std=c99','-Wall','-Wextra','-Werror','-dynamiclib',str(root/'reconstruction/endgame_tree.c'),'-o',str(library)],check=True)
 lib=C.CDLL(str(library));tp=C.POINTER(Tree);bp=C.POINTER(C.c_uint8)
 for name in ['reset','sweep','allocate_node']:
  f=getattr(lib,'maven_endgame_'+('tree_reset' if name=='reset' else name));f.argtypes=[tp]
 for name in ['select_child','recompute_bounds','prune']:
  getattr(lib,'maven_endgame_'+name).argtypes=[tp,C.c_uint16]
 lib.maven_endgame_select_child.restype=C.c_uint16;lib.maven_endgame_allocate_node.restype=C.c_uint16
 lib.maven_endgame_mark.argtypes=[tp,C.c_uint16,C.c_uint8];lib.maven_endgame_prepend_child.argtypes=[tp,C.c_uint16,C.c_uint16]
 lib.maven_endgame_add_move.argtypes=[tp,bp,bp,C.c_int32,C.c_int32];lib.maven_endgame_add_move.restype=C.c_uint16
 lib.maven_endgame_expand_move.argtypes=[bp,C.POINTER(Node),bp]
 for i,call in enumerate(j['calls']):
  before=call['before'];nodes=unpack_nodes(bytes.fromhex(before['nodes']));current=before['current_pointer']
  current_index=(current-pool)//32 if pool<=current<pool+32*capacity and (current-pool)%32==0 else capacity
  tree=Tree(nodes,capacity,before['free_head'],current_index,cb(diagnostic),cb(lambda _:None),None)
  stack=bytes.fromhex(call['stack']);args=struct.unpack_from('>7I',stack,4);kind=call['kind'];result=None
  if kind=='reset':lib.maven_endgame_tree_reset(C.byref(tree))
  elif kind=='select':result=lib.maven_endgame_select_child(C.byref(tree),node_index(args[0]))
  elif kind=='bounds':lib.maven_endgame_recompute_bounds(C.byref(tree),node_index(args[0]))
  elif kind=='prune':lib.maven_endgame_prune(C.byref(tree),node_index(args[0]))
  elif kind=='sweep':lib.maven_endgame_sweep(C.byref(tree))
  elif kind=='mark':lib.maven_endgame_mark(C.byref(tree),node_index(args[0]),struct.unpack_from('>H',stack,8)[0])
  elif kind=='allocate':result=lib.maven_endgame_allocate_node(C.byref(tree))
  elif kind=='prepend':lib.maven_endgame_prepend_child(C.byref(tree),node_index(args[0]),node_index(args[1]))
  elif kind=='add_move':
   move=bytearray_c(bytes.fromhex(call['move']));board=bytearray_c(bytes.fromhex(call['board']));upper,lower=struct.unpack_from('>ii',stack,8)
   lib.maven_endgame_add_move(C.byref(tree),move,board,upper,lower)
   # Original add_move returns void; allocator's incidental D0 is not its contract.
  elif kind=='expand_move':
   move=bytearray_c(bytes.fromhex(call['move_before']));board=bytearray_c(bytes.fromhex(call['board']));lib.maven_endgame_expand_move(move,C.byref(nodes[node_index(args[1])]),board)
   assert bytes(move).hex()==call['move_after'],(i,kind,'expanded move')
  else:raise AssertionError(kind)
  if result is not None:assert (pool+32*result if result else 0)==call['result'],(i,kind,result,call['result'])
  expected=bytes.fromhex(before['nodes'] if call['after']['nodes']=='unchanged' else call['after']['nodes']);actual=packed(nodes)
  if actual!=expected:
   off=next(k for k,(x,y) in enumerate(zip(actual,expected)) if x!=y);raise AssertionError((i,kind,'node',off//32,'byte',off%32,actual[off],expected[off]))
  assert tree.free_head==call['after']['free_head'],(i,kind,'free head')
 assert not diagnostics,diagnostics
print(json.dumps(dict(scope=__doc__,calls=len(j['calls']),kinds=dict(Counter(c['kind'] for c in j['calls'])),capacity=capacity,all_nodes_and_results_match=True,solver_completed=j['solver_completed'])))
