"""Explicit fixture decoding for the portable late-game value ABI."""
import ctypes as C
import struct
U8=C.c_uint8;U16=C.c_uint16;U32=C.c_uint32
class Value(C.Structure):
 _fields_=[(n,U16) for n in ('unseen_count','own_remaining','other_remaining','bag_remaining','unseen_q','new_tiles','main_triple')]+[(n,U8*128) for n in ('available','used')]+[(n,U16*128) for n in ('leave','tile_points','letter_leave')]+[(n,U16*10) for n in ('normal_bag','held_q_bag','reply_q_bag')]+[(n,(U16*8)*8) for n in ('normal_empty_bag','held_q_no_u','held_q_with_u','blank_adjustment')]+[('normal_before_matrix',U16),('with_u_before_matrix',U16),('blank_query',C.c_void_p),('user',C.c_void_p),('opponent_held_q',(U16*8)*8),('held_u_value',U16)]
def decode_value(b):
 state=Value();g=bytes.fromhex(b['globals']);t=bytes.fromhex(b['tables'])
 def global_word(off):return int.from_bytes(g[0x8da-off:0x8da-off+2],'big')
 def table(off,n):return struct.unpack('>'+str(n)+'H',t[0x65a8-off:0x65a8-off+2*n])
 for name,off in [('unseen_count',0x82e),('own_remaining',0x738),('other_remaining',0x736),('bag_remaining',0x734),('unseen_q',0x732)]:setattr(state,name,global_word(off))
 state.new_tiles=int(b['new_tiles'],16);state.main_triple=int(b['main_triple'],16);state.available[:]=bytes.fromhex(b['counts']);state.used[:]=bytes.fromhex(b['used']);state.leave[:]=struct.unpack('>128H',bytes.fromhex(b['leave']));state.tile_points[:]=struct.unpack('>128H',bytes.fromhex(b['tile_points']));state.letter_leave[:]=struct.unpack('>128H',g[0x8da-0x888:0x8da-0x888+256])
 for name,off in [('normal_bag',0x6114),('held_q_bag',0x6100),('reply_q_bag',0x60ec)]:getattr(state,name)[:]=table(off,10)
 for name,off in [('normal_empty_bag',0x6394),('held_q_no_u',0x6314),('held_q_with_u',0x6214),('blank_adjustment',0x6494),('opponent_held_q',0x6294)]:
  flat=table(off,64)
  for i in range(8):getattr(state,name)[i][:]=flat[i*8:i*8+8]
 state.held_u_value=global_word(0x792)
 state.normal_before_matrix=table(0x6316,1)[0];state.with_u_before_matrix=table(0x6216,1)[0]
 return state
