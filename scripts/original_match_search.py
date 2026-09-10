"""Normal file-open/Kibitz search, with read-only entry/return breakpoints."""
import hashlib,select,socket,struct,time
from pathlib import Path
from gdb_remote import Remote
from qmp_session import command
from mac_ui import key,text
from maven_debug_cleanup import cleanup_breakpoints
ROOT=Path(__file__).resolve().parents[1]
class OriginalSearch:
 def __init__(self,ui_delay_scale=1.0,progress=None):
  if not 0 < ui_delay_scale <= 1:raise ValueError('UI delay scale must be in (0, 1]')
  # progress(event) is called at every debugger stop; long endgame searches
  # stop once per clock read, so a watchdog can distinguish slow from stuck.
  self.identity=None;self.ui_delay_scale=ui_delay_scale;self.progress=progress or (lambda event:None)
  # QEMU holds each key for 30 ms; keep a release margin even in fast mode.
  self.key_delay=max(.04,.08*ui_delay_scale)
 def require_fresh_workspace(self,expected):
  # A new owned engine cannot be compared with an arbitrary warm Mac process.
  # Opening a position does not reset this aliased query/control workspace.
  command('stop');r=Remote()
  try:
   r.command('?');assert r.command('m40800000,10')=='f1acad130000002a067c4efa00804efa'
   a5=int.from_bytes(bytes.fromhex(r.command('m904,4')),'big')
   actual=bytes.fromhex(r.command(f'm{a5-0x6f2:x},40'))
   if actual!=expected:raise RuntimeError('Original Maven has warm query/control state. Restart the original application before creating a fresh match engine, or replay the complete preceding sequence in both engines.')
   return dict(a5=a5,workspace=actual.hex(),matched_resource_initializer=True)
  finally:r.close();command('cont')
 def search(self,fixture):
  started=time.perf_counter()
  command('stop');r=Remote();r.sock.settimeout(30);points=set()
  def read(a,n):return b''.join(bytes.fromhex(r.command(f'm{a+i:x},{min(2048,n-i):x}')) for i in range(0,n,2048))
  def regs():return struct.unpack('>18I',bytes.fromhex(r.command('g')))
  def long(a):return int.from_bytes(read(a,4),'big')
  def word(a):return int.from_bytes(read(a,2),'big',signed=True)
  def add(a):assert r.command(f'Z0,{a:x},2')=='OK';points.add(a)
  def clear():
   for a in list(points):assert r.command(f'z0,{a:x},2')=='OK';points.remove(a)
  def remove(a):assert r.command(f'z0,{a:x},2')=='OK';points.remove(a)
  def run(a):add(a);r.command('c');assert regs()[17]==a;clear()
  try:
   r.command('?');assert read(0x40800000,16).hex()=='f1acad130000002a067c4efa00804efa'
   a5=long(0x904);entries={a5+0x852:(28,0x11a),a5+0xa1a:(36,0x1810),a5+0x89a:(30,0x14e)}
   for address in entries:add(address)
   # Arm before Open: importing can trigger a search before Cmd-K.
   armed=time.perf_counter()
   r.command('c',wait=False);key('meta_l-o',delay=self.key_delay);time.sleep(.2*self.ui_delay_scale);text(fixture,delay=self.key_delay);key('ret',delay=self.key_delay);time.sleep(self.ui_delay_scale)
   opened=time.perf_counter()
   # The asynchronous continue also leaves a '+' acknowledgement.
   # Socket readability alone does not mean a breakpoint packet arrived.
   while select.select([r.sock],[],[],0)[0] and r.sock.recv(1,socket.MSG_PEEK)==b'+':r.sock.recv(1)
   if not select.select([r.sock],[],[],0)[0]:key('meta_l-k',delay=self.key_delay)
   r.receive();slot=regs()[17];assert slot in entries;clear();rid,offset=entries[slot];self.progress('entry')
   stub=read(slot,6)
   if stub==struct.pack('>3H',0x3f3c,rid,0xa9f0):r.command('s');r.command('s');run(slot);stub=read(slot,6)
   assert stub[:2]==bytes.fromhex('4ef9');base=int.from_bytes(stub[2:],'big')-offset
   code=(ROOT/f'resources/CODE/{rid}_{rid}.bin').read_bytes();assert read(base+4,len(code)-4)==code[4:]
   run(base+offset);rr=regs();caller=long(rr[15]);rack=long(rr[15]+4);self.progress('search')
   if self.identity is None:
    data=(ROOT/'../../media/maven/session/share/maven2.1').read_bytes();assert read(long(a5-0x2eb8)-12,len(data))==data
    self.identity=dict(dictionary_sha256=hashlib.sha256(data).hexdigest(),code28_sha256=hashlib.sha256(code).hexdigest(),a5=a5)
   initial=dict(board=read(a5-0x4302,544).hex(),values=read(a5-0x40e2,1088).hex(),rack=read(rack,8).hex(),opponent=read(a5-0x3ca2 if rack==a5-0x3c9a else a5-0x3c9a,8).hex(),zero=word(a5-0x4c0e),dedup=bool(long(a5-0x4c1e)),offset=word(a5-0x5ab4),cross_workspace=read(a5-0x6f2,64).hex())
   clocks=[];search_started=time.perf_counter()
   if rid==30:
    budget=long(rr[15]+8);add(caller);add(base+0x472)
    while True:
     r.command('c');stopped=regs()
     if stopped[17]==caller:break
     # The caller breakpoint stays armed; only the clock breakpoint is stepped over.
     assert stopped[17]==base+0x472;clocks.append(stopped[0]);remove(base+0x472);r.command('s');add(base+0x472);self.progress('clock')
    clear()
   else:run(caller)
   search_finished=time.perf_counter();self.progress('return')
   result=dict(initial=initial,moves=read(a5-0x5a10,340).hex(),count=word(a5-0x30fc),cutoff=long(a5-0xade),cross_workspace_after=read(a5-0x6f2,64).hex(),identity=self.identity,kind={28:'heuristic',36:'late',30:'endgame'}[rid],code_sha256=hashlib.sha256(code).hexdigest(),return_d0=regs()[0],clocks=clocks)
   result['timing_seconds']=dict(attach_and_arm=armed-started,open_ui=opened-armed,entry_and_input_capture=search_started-opened,original_search_with_debugger=search_finished-search_started)
   if rid==30:
    h=struct.unpack('>16I',read(a5-0x468,64));seed=((h[0]<<1)&0x7fffffff)|(((h[0]>>30)^(h[0]>>3))&1)
    result.update(hash_words=h,seed=seed,budget=budget)
   return result
  finally:cleanup_breakpoints(r,points)

def write_fixture(board,racks,scores,name='zzmatch'):
 payload=bytearray(300);blanks=[]
 for i,c in enumerate(board):
  if c:
   row,col=divmod(i,15);payload[(row+1)*17+col+1]=ord(c.lower())
   if c.islower():blanks.extend([row+1,col+1])
 for i,rack in enumerate(racks):
  b=''.join(rack).lower().encode();payload[272+i*8:272+i*8+len(b)]=b
 payload[288:296]=struct.pack('>II',*[s*100 for s in scores]);payload[296:296+len(blanks)]=bytes(blanks)
 p=ROOT/'../../media/maven/session/share'/name;p.write_bytes(struct.pack('>HH',0,300)+payload)
 p.with_name(p.name+'.idump').write_bytes(p.with_name('maven-search-late13.idump').read_bytes())
 return name
