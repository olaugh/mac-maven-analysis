/* Owned wasm load, select history, search, play, save and reload. */
import fs from 'node:fs';import assert from 'node:assert/strict';import crypto from 'node:crypto';
const files=['DATA/0_0.bin','ZERO/0_0.bin','DREL/0_0.bin','prfs/0_0.bin','PATB/0_entries.bin','ESTR/0_pattern_strings.bin','EXPR/0_full.bin','FRST/0_0.bin',...Array.from('?abcdefghijklmnopqrstuvwxyz',c=>`MUL${c}/0_0.bin`),...Array.from('abcdefgh',c=>`VCB${c}/0_0.bin`)];
const blobs=files.map(p=>fs.readFileSync(`resources/${p}`)),packet=Buffer.alloc(43*8+blobs.reduce((n,b)=>n+b.length,0));let offset=43*8;blobs.forEach((b,i)=>{packet.writeUInt32BE(offset,8*i);packet.writeUInt32BE(b.length,8*i+4);b.copy(packet,offset);offset+=b.length;});
const dictionary=fs.readFileSync('../../media/maven/session/share/maven2.1'),wasm=fs.readFileSync('.build/maven-portable.wasm');const {instance}=await WebAssembly.instantiate(wasm,{}),e=instance.exports;
const view=id=>new Uint8Array(e.memory.buffer,e.maven_port_buffer(id),e.maven_port_capacity(id));const write=(id,b)=>{assert(b.length<=view(id).length);view(id).set(b);};const read=(id,n)=>Buffer.from(view(id).slice(0,n));const be32=x=>{const b=Buffer.alloc(4);b.writeUInt32BE(x>>>0);return b;};
write(0,packet);write(1,dictionary);assert.equal(e.maven_port_create(packet.length,dictionary.length),0);view(0).fill(0);view(1).fill(0);
function inputs(refills){let seed=refills[0].private_seed;const initial=seed,events=[],starts=[];for(const f of refills){assert.equal(f.private_seed,seed);starts.push(be32(f.stack_ticks));for(const event of f.events){if(event.kind==='private_random'){seed=(seed>>>1)+((((seed>>>4)^seed)&1)*0x40000000);assert.equal(seed,event.value);}else events.push(Buffer.concat([be32(event.kind==='ticks'?0:1),be32(event.value)]));}assert.equal(seed,f.final.private_seed);}return{initial,final:seed,events:Buffer.concat(events),starts:Buffer.concat(starts),count:events.length,refills:refills.length};}

const captures=Array.from({length:5},(_,i)=>JSON.parse(fs.readFileSync(`analysis/toolchain/session-publication-exhaustive-live-${String(i+1).padStart(2,'0')}.json`)));assert(captures.every(c=>c.complete));
const first=captures[0],initial=first.initial,refills=captures.flatMap(c=>c.refills),pubs=captures.flatMap(c=>c.publications),input=inputs(refills);
const b=Buffer.from(initial.board,'hex'),v=Buffer.from(initial.values,'hex'),p=Buffer.alloc(477);
for(let r=1;r<16;r++)for(let c=1;c<16;c++){const k=r*17+c,i=(r-1)*15+c-1;p[i]=b[k];p[i+225]=+(!!b[k]&&!v.readUInt16BE(2*k));}
Buffer.from(initial.rack0,'hex').copy(p,450);Buffer.from(initial.rack1,'hex').copy(p,458);p.writeUInt16BE(initial.row_zero_count,474);
write(2,p);assert.equal(e.maven_port_position(477),0);assert.equal(e.maven_port_late(1,0),0);
const config=Buffer.from(first.config,'hex'),expectedRanking=Buffer.concat(Array.from({length:10},(_,i)=>config.subarray(24+46*i,58+46*i)));assert.deepEqual(read(3,340),expectedRanking);
write(6,input.events);write(7,input.starts);
const options=stop=>Buffer.concat([input.initial,1,1,0,0,0,input.count,input.refills,0,stop].map(be32));
write(10,options(1));assert.equal(e.maven_port_simulate(),6);assert.equal(e.maven_port_count(7),input.initial);assert.equal(e.maven_port_count(13),0);assert.equal(e.maven_port_count(8),0);assert.equal(e.maven_port_count(9),0);assert.equal(read(11,820).readUInt32BE(816),4);
write(10,options(0));assert.equal(e.maven_port_simulate(),0);assert.equal(e.maven_port_count(7),input.final);assert.equal(e.maven_port_count(8),input.count);assert.equal(e.maven_port_count(9),150);assert.equal(e.maven_port_count(13),6);assert.equal(e.maven_port_count(14),450);
const result=read(11,820);assert.deepEqual(result.subarray(0,460),Buffer.from(captures.at(-1).final_config,'hex').subarray(24));assert.deepEqual(result.subarray(460,800),Buffer.from(pubs.at(-1).moves,'hex'));assert.deepEqual(result.subarray(800),Buffer.concat([5,8,6,10,2].map(be32)));
const publications=read(12,6*348);for(let i=0;i<6;i++){const pub=publications.subarray(i*348,(i+1)*348);assert.equal(pub.readUInt32BE(),10);assert.equal(pub.readUInt32BE(4),i*90);assert.deepEqual(pub.subarray(8),Buffer.from(pubs[i].moves,'hex'));}
assert.equal(e.maven_port_get_position(),0);assert.deepEqual(read(2,477),p);assert.equal(e.maven_port_count(11),0);

const cancelled=JSON.parse(fs.readFileSync('analysis/toolchain/session-publication-cancel-live.json')),draw=JSON.parse(fs.readFileSync('analysis/toolchain/session-publication-cancel-draw-live.json'));
const continuation=inputs([{private_seed:draw.initial.private_seed,stack_ticks:draw.initial.stack_ticks,events:draw.events,final:draw.final},...cancelled.refills]);assert.equal(continuation.initial,input.final);
const continuedConfig=Buffer.from(cancelled.config,'hex');assert.deepEqual(read(3,340),Buffer.concat(Array.from({length:10},(_,i)=>continuedConfig.subarray(24+46*i,58+46*i))));
write(6,continuation.events);write(7,continuation.starts);write(10,Buffer.concat([continuation.initial,1,0,1,0,0,continuation.count,continuation.refills,0,3].map(be32)));
assert.equal(e.maven_port_simulate(),6);assert.equal(e.maven_port_count(7),continuation.final);assert.equal(e.maven_port_count(8),continuation.count);assert.equal(e.maven_port_count(9),4);assert.equal(e.maven_port_count(13),1);assert.equal(e.maven_port_count(14),8);
const stopped=read(11,820);assert.deepEqual(stopped.subarray(0,460),Buffer.from(cancelled.final_config,'hex').subarray(24));assert.deepEqual(stopped.subarray(460,800),Buffer.from(cancelled.publications[0].moves,'hex'));assert.deepEqual(stopped.subarray(800),Buffer.concat([0,0,1,10,4].map(be32)));
assert.equal(e.maven_port_get_position(),0);assert.deepEqual(read(2,477),p);
console.log(JSON.stringify({scope:'Owned wasm consecutive exhaustive and cancelled random sessions',refills:154,simulation_events:458,publications:7,pre_start_cancel:true,continuous_private_rng:true,reused_published_ranking:true,all_matched:true,wasm_sha256:crypto.createHash('sha256').update(wasm).digest('hex')}));
