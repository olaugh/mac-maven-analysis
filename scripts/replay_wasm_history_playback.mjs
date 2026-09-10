import fs from 'node:fs';import assert from 'node:assert/strict';import crypto from 'node:crypto';
const name=process.argv[2]||'history-playback-end6-live',j=JSON.parse(fs.readFileSync(`analysis/toolchain/${name}.json`));assert(j.complete);
const hash=b=>crypto.createHash('sha256').update(b).digest('hex');for(const[rid,sha]of Object.entries(j.identities))assert.equal(hash(fs.readFileSync(`resources/CODE/${rid}_${rid}.bin`)),sha);
const cases=[j];if(process.argv[3]){const next=JSON.parse(fs.readFileSync(`analysis/toolchain/${process.argv[3]}.json`));assert(next.complete);assert.equal(next.wire,j.wire);assert.deepEqual(next.fixed,j.fixed);assert.deepEqual(next.initial,j.navigation_return??j.open_return);assert.equal(next.refills[0].private_seed,j.refills.at(-1).final.private_seed);cases.push(next);}
const wire=Buffer.from(j.wire,'hex');assert.equal(hash(wire),j.file_sha256);
const wasm=fs.readFileSync('.build/maven-history.wasm'),mod=await WebAssembly.compile(wasm);assert.deepEqual(WebAssembly.Module.imports(mod),[]);const{exports:e}=await WebAssembly.instantiate(mod,{});
function put(id,hex,width=1){const b=typeof hex==='string'?Buffer.from(hex,'hex'):hex,p=e.maven_history_buffer(id),v=new DataView(e.memory.buffer);for(let i=0;i<b.length;i+=width){if(width===1)v.setUint8(p+i,b[i]);else if(width===2)v.setUint16(p+i,b.readUInt16BE(i),true);else v.setUint32(p+i,b.readUInt32BE(i),true);}}
const be32=x=>{const b=Buffer.alloc(4);b.writeUInt32BE(x>>>0);return b;};
put(18,fs.readFileSync('resources/prfs/0_0.bin').subarray(0x312,0x312+28));
put(0,wire);put(1,j.initial.board);put(2,j.initial.values,2);put(3,j.initial.rack0+j.initial.rack1);put(4,Buffer.concat(j.initial.totals.map(be32)),4);put(5,j.fixed.letter_values,2);
for(const[id,key]of [[8,'letter_class'],[11,'word_multipliers'],[12,'letter_multipliers'],[13,'alphabet'],[14,'distribution']])put(id,j.fixed[key]);put(9,j.initial.counts);put(10,j.initial.undo);
for(const [run,j] of cases.entries()){
const random=j.refills.flatMap(x=>x.events);assert(random.length<=4096&&j.refills.length<=1024);
put(15,Buffer.concat(random.flatMap(x=>[be32(['private_random','toolbox_random','ticks'].indexOf(x.kind)),be32(x.value)])),4);put(16,Buffer.concat(j.refills.map(x=>be32(x.stack_ticks))),4);
[random.length,j.refills.length,j.refills[0].private_seed,j.initial.row_zero_count,j.initial.new_tiles,...j.initial.recorded_row,...j.initial.recorded_column,j.initial.selected_pointer===j.a5-0x3c9a?0:1].forEach((x,i)=>{if(run===0||i<2)e.maven_history_set(i,x);});
if(run===0)assert.equal(e.maven_history_decode(wire.length),0);assert.equal(e.maven_history_play(j.target_index??e.maven_history_count()-1),0);assert.equal(e.maven_history_get(5),0);
assert.equal(e.maven_history_get(0),random.length);assert.equal(e.maven_history_get(1),j.refills.length);assert.equal(e.maven_history_get(2),j.refills.at(-1).final.private_seed);assert.equal(e.maven_history_get(3),j.events.length);
j.events.forEach((event,i)=>{const s=event.state,expected=Buffer.concat([be32(event.index),be32(event.tag),...['board','values','rack0','rack1','counts','undo'].map(k=>Buffer.from(s[k],'hex')),...[...s.totals,s.selected_pointer===j.a5-0x3c9a?0:1,s.row_zero_count,s.new_tiles,...s.recorded_row,...s.recorded_column].map(be32)]);
 assert.equal(e.maven_history_get(4),expected.length);const actual=Buffer.from(new Uint8Array(e.memory.buffer,e.maven_history_buffer(17)+2048*i,expected.length));assert.deepEqual(actual,expected,`record ${event.index}`);
});assert.equal(e.maven_history_side(),0);
const final=j.navigation_return??j.open_return;
for(const[id,key,n]of [[1,'board',544],[3,'rack0',8],[9,'counts',128],[10,'undo',33]])assert.equal(Buffer.from(new Uint8Array(e.memory.buffer,e.maven_history_buffer(id),n)).toString('hex'),final[key]);
assert.equal(Buffer.from(new Uint8Array(e.memory.buffer,e.maven_history_buffer(3)+8,8)).toString('hex'),final.rack1);

}
console.log(JSON.stringify({scope:'Original multi-record history restore with actual placement and refills; observed external random/clock inputs',consecutive_restores:cases.length,records:cases.reduce((n,j)=>n+j.events.length,0),refills:cases.reduce((n,j)=>n+j.refills.length,0),external_inputs:cases.reduce((n,j)=>n+j.refills.reduce((n,f)=>n+f.events.length,0),0),all_matched:true,imports:[],wasm_sha256:hash(wasm)}));
