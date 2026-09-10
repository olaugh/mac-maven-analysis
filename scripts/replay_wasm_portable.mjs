/* No captured initialization tables or cache state are written to wasm. */
import fs from 'node:fs';
import assert from 'node:assert/strict';
import crypto from 'node:crypto';
import zlib from 'node:zlib';
const name=process.argv[2]??'heuristic-search-live';
const primeAT=process.argv.includes('--prime-at');
const late=name.startsWith('late-search-')||process.argv.includes('--late');
const endgame=name.startsWith('endgame-search-')||process.argv.includes('--endgame');
const j=JSON.parse(late||endgame?zlib.gunzipSync(fs.readFileSync(`analysis/toolchain/${name}.json.gz`)):fs.readFileSync(`analysis/toolchain/${name}.json`));assert(j.complete);
const files=['DATA/0_0.bin','ZERO/0_0.bin','DREL/0_0.bin','prfs/0_0.bin','PATB/0_entries.bin','ESTR/0_pattern_strings.bin','EXPR/0_full.bin','FRST/0_0.bin',
 ...Array.from('?abcdefghijklmnopqrstuvwxyz',c=>`MUL${c}/0_0.bin`),...Array.from('abcdefgh',c=>`VCB${c}/0_0.bin`)];
const blobs=files.map(p=>fs.readFileSync(`resources/${p}`));
const packet=Buffer.alloc(43*8+blobs.reduce((n,b)=>n+b.length,0));let offset=43*8;
blobs.forEach((b,i)=>{packet.writeUInt32BE(offset,i*8);packet.writeUInt32BE(b.length,i*8+4);b.copy(packet,offset);offset+=b.length;});
const dictionary=fs.readFileSync('../../media/maven/session/share/maven2.1');
assert.equal(crypto.createHash('sha256').update(dictionary).digest('hex'),j.dictionary_sha256);
const wasm=fs.readFileSync('.build/maven-portable.wasm');
const {instance}=await WebAssembly.instantiate(wasm,{});const e=instance.exports;
const view=id=>new Uint8Array(e.memory.buffer,e.maven_port_buffer(id),e.maven_port_capacity(id));
function write(id,bytes){assert(bytes.length<=e.maven_port_capacity(id));view(id).set(bytes);}
write(0,packet);write(1,dictionary);
assert.equal(e.maven_port_create(packet.length-1,dictionary.length),1,'truncated resources');
assert.equal(e.maven_port_create(packet.length,dictionary.length-1),1,'truncated dictionary');
assert.equal(e.maven_port_create(packet.length,dictionary.length),0,'resource initialization');
// Prove owned copies: overwrite inputs before any search.
view(0).fill(0);view(1).fill(0);
if(primeAT){
 const at=Buffer.alloc(477);at[7*15+7]=97;at[7*15+8]=116;Buffer.from('?abcdef').copy(at,450);Buffer.from('ghijklm').copy(at,458);write(2,at);assert.equal(e.maven_port_position(477),0);assert.equal(e.maven_port_search(0,0),0);
}
const position=Buffer.alloc(477),board=Buffer.from(j.initial.board,'hex'),values=Buffer.from(j.initial.values,'hex');
for(let row=1;row<16;row++)for(let col=1;col<16;col++){
 const index=(row-1)*15+col-1,original=row*17+col;
 position[index]=board[original];position[225+index]=+(!!board[original]&&!values.readUInt16BE(original*2));
}
Buffer.from(endgame?j.own:j.initial.rack,'hex').copy(position,450);
if(late){
 // Late analysis depends on unseen inventory, not the actual opponent rack.
 // Choose one feasible hidden tile solely to satisfy the public position form.
 const alphabet='?abcdefghijklmnopqrstuvwxyz',remaining=[2,9,2,2,4,12,2,3,2,9,1,1,4,2,6,8,2,1,6,4,6,4,2,2,1,2,1];
 for(let i=0;i<225;i++)if(position[i])remaining[alphabet.indexOf(position[225+i]?'?':String.fromCharCode(position[i]))]--;
 for(const c of Buffer.from(j.initial.rack,'hex'))if(c)remaining[alphabet.indexOf(String.fromCharCode(c))]--;
 position[458]=alphabet.charCodeAt(remaining.findIndex(n=>n>0));
}else Buffer.from(endgame?j.other:j.opponent_rack,'hex').copy(position,458);
position.writeUInt16BE(j.initial.row_zero_count,474);write(2,position);
assert.equal(e.maven_port_position(476),1);assert.equal(e.maven_port_position(477),0);
view(2)[450]=255;assert.equal(e.maven_port_position(477),1,'invalid rack leaves position unchanged');
const expected=late||endgame?null:Buffer.concat(j.candidates.map(c=>Buffer.concat([Buffer.from([c.phase,c.mode]),Buffer.from(c.move,'hex')])));
let seed;
if(endgame){
 const words=Buffer.from(j.initialized_hash_table??j.fixed.hash_table,'hex');const first=words.readUInt32BE(0);
 seed=(((first<<1)&0x7fffffff)|(((first>>>30)^(first>>>3))&1))>>>0;
 if(j.fixed.hash_table.startsWith('00000000'))assert.equal(seed,j.hash_entry_seed);
 const clocks=Buffer.alloc(j.elapsed.length*4);j.elapsed.forEach((c,i)=>clocks.writeUInt32BE(c.result,i*4));write(5,clocks);
 for(const stop of [1,2]){const before=Buffer.from(view(3));assert.equal(e.maven_port_endgame(seed,j.budget,j.elapsed.length,stop),6);assert.deepEqual(Buffer.from(view(3)),before);}
 const before=Buffer.from(view(3));assert.equal(e.maven_port_endgame(seed,j.budget,0,0),1,'clock exhaustion');assert.deepEqual(Buffer.from(view(3)),before);
}
for(let repeat=0;repeat<3;repeat++){
 if(endgame){
  assert.equal(e.maven_port_endgame(seed,j.budget,j.elapsed.length,0),0);
  assert.equal(e.maven_port_count(0),j.final.ranking.count);assert.equal(e.maven_port_count(5),j.iterations.length);assert.equal(e.maven_port_count(6),j.elapsed.length);
  assert.deepEqual(Buffer.from(view(3)),Buffer.from(j.final.ranking.moves,'hex'));
 }else if(late){
  assert.equal(e.maven_port_late(1,0),0,'late search');assert.equal(e.maven_port_count(3),1);
  assert.equal(e.maven_port_count(0),j.final.ranking_count);
  assert.deepEqual(Buffer.from(view(3)),Buffer.from(j.final.ranking,'hex'));
 }else{
  assert.equal(e.maven_port_search(+!!j.extra_filter_pointer,j.leave_offset),0);
  assert.equal(e.maven_port_count(1),j.candidates.length);
  assert.deepEqual(Buffer.from(view(4).subarray(0,expected.length)),expected,'all observed candidates');
  assert.equal(e.maven_port_count(0),j.final.ranking.count);assert.equal(e.maven_port_count(2)>>>0,j.final.ranking.cutoff_bits);
  assert.deepEqual(Buffer.from(view(3)),Buffer.from(j.final.ranking.moves,'hex'));
 }
}
console.log(JSON.stringify({scope:'Owned wasm engine initialized from resources, dictionary and public position only',capture:name,prior_AT_search:primeAT,candidates:j.candidates?.length,ranked:late?j.final.ranking_count:j.final.ranking.count,repeated_searches:3,all_matched:true,wasm_sha256:crypto.createHash('sha256').update(wasm).digest('hex')}));
