#!/usr/bin/env python3
"""Retained original row flags from the controlled AT board's normal cross queries."""
import ctypes as C,hashlib,json,struct,subprocess,tempfile
from pathlib import Path
from replay_board_placements import Enumeration,Callback
from replay_opening_generator import Section
j=json.loads(Path('analysis/toolchain/cross-query-at-overlap-live.json').read_text());assert j['complete']
source=Path('../../media/maven/session/share/maven-cross-at-0909').read_bytes();meta=json.loads(Path('analysis/toolchain/cross-query-at-fixture.json').read_text());assert hashlib.sha256(source).hexdigest()==meta['sha256']
board=bytearray(544);board[:272]=source[4:276]
for r in range(1,16):
 for c in range(1,16):board[(c+15)*17+r]=board[r*17+c]
data=Path('../../media/maven/session/share/maven2.1').read_bytes();assert hashlib.sha256(data).hexdigest()==j['dictionary_sha256'];blob=C.create_string_buffer(data);roots=struct.unpack_from('>II',data,4);sections=(Section*3)(Section(C.addressof(blob)+12,roots[0]),Section(C.addressof(blob)+116+4*roots[0],roots[1]),Section())
buf=C.create_string_buffer(bytes(board));premiums=C.create_string_buffer(bytes([1])*544);state=Enumeration();state.sections=sections;state.board=C.addressof(buf);state.letter_multipliers=state.word_multipliers=C.addressof(premiums)
for c in b'?abcdef':state.remaining[c]+=1
initial=bytes(state.remaining);emitted=[];callback=Callback(lambda u,p,r:emitted.append(bytes(p.contents.word)));state.placement=callback
workspace=C.create_string_buffer(bytes.fromhex(j['calls'][0]['before']),64)
with tempfile.TemporaryDirectory() as tmp:
 libpath=Path(tmp)/'shared.dylib';subprocess.run(['cc','-std=c99','-Wall','-Wextra','-Werror','-dynamiclib',*[f'reconstruction/{s}.c' for s in ('board_placements','board_state','cross_check_letters','dictionary_lookup')],'-o',str(libpath)],check=True)
 f=C.CDLL(str(libpath)).maven_enumerate_board_placements_shared;f.argtypes=[C.POINTER(Enumeration),*[C.c_void_p]*5]
 for _ in range(2):
  f(C.byref(state),workspace,None,None,None,None)
  assert workspace.raw[32:]==bytes.fromhex(j['calls'][-1]['after'])[32:]
  assert bytes(state.remaining)==initial
assert emitted
print(json.dumps(dict(scope=__doc__,repeated_enumerations=2,row_flag_bytes=workspace.raw[32:].hex(),rack_restored=True,all_matched=True,limitation='row flags compared; complete candidate stream and row-control timing require an original whole-generator capture')))
