#!/usr/bin/env python3
"""Replay captured natural bag construction and refill with observed inputs."""
import argparse,ctypes as C,hashlib,json,struct,subprocess,tempfile
from pathlib import Path

def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--capture',type=Path,required=True);a=p.parse_args()
    root=Path(__file__).resolve().parents[1];j=json.loads(a.capture.read_text());before=j['initial'];after=j['final']
    for ident in j['identities']+[dict(code_resource=31,sha256=j['code31_sha256'])]:
        rid=ident['code_resource'];assert hashlib.sha256((root/f'resources/CODE/{rid}_{rid}.bin').read_bytes()).hexdigest()==ident['sha256']
    byte=C.c_uint8;word=C.c_uint16;bp=C.POINTER(byte)
    def array(name):return (byte*len(bytes.fromhex(before[name]))).from_buffer_copy(bytes.fromhex(before[name]))
    board=array('board');distribution=array('distribution');rack0=array('rack0');rack1=array('rack1');alphabet=array('alphabet');rack=array('rack')
    values=(word*544)(*struct.unpack('>544H',bytes.fromhex(before['values'])));bag=(byte*128)()
    ucallback=C.CFUNCTYPE(C.c_uint32,C.c_void_p);scallback=C.CFUNCTYPE(C.c_int16,C.c_void_p)
    class Ops(C.Structure):_fields_=[('user',C.c_void_p),('private_random',ucallback),('toolbox_random',scallback),('read_ticks',ucallback)]
    events=iter(j['events']);consumed=[];errors=[];seed=C.c_uint32(before['private_seed'])
    with tempfile.TemporaryDirectory() as temp:
        library=Path(temp)/'refill.dylib';subprocess.run(['cc','-std=c99','-Wall','-Wextra','-Werror','-dynamiclib',*[str(root/'reconstruction'/x) for x in ('rack_refill.c','remaining_tiles.c','random_opponent.c')],'-o',str(library)],check=True)
        lib=C.CDLL(str(library));lib.maven_collect_remaining_tiles.argtypes=[bp,bp,bp,C.POINTER(word),bp,bp,bp];lib.maven_collect_remaining_tiles.restype=C.c_uint32
        length=lib.maven_collect_remaining_tiles(bag,distribution,board,values,rack0,rack1,alphabet)
        assert bytes(bag)[:length].hex()==before['bag']
        lib.maven_private_random_next.argtypes=[C.POINTER(C.c_uint32)];lib.maven_private_random_next.restype=C.c_uint32
        def observe(kind):
            try:
                event=next(events);assert event['kind']==kind;consumed.append(kind)
                if kind=='private_random':assert lib.maven_private_random_next(C.byref(seed))==event['value']
                return event['value']
            except Exception as exc:errors.append(repr(exc));return len(errors) if kind=='ticks' else 0
        ops=Ops(None,ucallback(lambda _:observe('private_random')),scallback(lambda _:observe('toolbox_random')),ucallback(lambda _:observe('ticks')))
        lib.maven_refill_rack_from_bag.argtypes=[bp,bp,C.c_uint32,bp,C.c_uint32,C.POINTER(Ops)]
        if 'sample_before' in j:
            prior=j['sample_before']
            for array_value,key in [(rack,'sample'),(board,'board'),(rack0,'rack0'),(rack1,'rack1')]:
                C.memmove(array_value,bytes.fromhex(prior[key]),len(array_value))
            lib.maven_draw_random_opponent.argtypes=[bp,bp,bp,bp,bp,bp,C.POINTER(word),bp,C.c_uint32,C.POINTER(Ops)]
            lib.maven_draw_random_opponent.restype=C.c_uint32
            assert lib.maven_draw_random_opponent(rack,rack1,rack0,bag,distribution,board,values,alphabet,before['stack_ticks'],C.byref(ops))==length
            assert bytes(rack0).hex()==prior['rack0']
            assert bytes(rack1)==b'\0'+bytes.fromhex(prior['rack1'])[1:]
            assert bytes(rack).hex()==j['sample_callback']['rack']
            assert j['sample_callback']['weight']==1
        else:
            lib.maven_refill_rack_from_bag(rack,bag,length,board,before['stack_ticks'],C.byref(ops))
        assert not errors,errors
        assert next(events,None) is None
        assert bytes(rack).hex()==after['rack'] and bytes(board).hex()==after['board']
        assert bytes(bag)[:length].hex()==after['bag_workspace'] and seed.value==after['private_seed']
    print(json.dumps(dict(scope='Natural captured invocation replay; bag, private generator and refill C verified for this trace. Observed clock/Toolbox inputs; debugger affects timing. Small-bag uninitialized branch not thereby verified.',random_opponent_iteration='sample_before' in j,bag_bytes_matching=length,events_consumed=len(consumed),rack=bytes(rack).split(b'\0')[0].decode(),full_board_matches=True,bag_workspace_matches=True,private_seed_matches=True,capture_sha256=hashlib.sha256(a.capture.read_bytes()).hexdigest()),indent=2))
if __name__=='__main__':main()
