import fs from 'node:fs';import assert from 'node:assert/strict';import crypto from 'node:crypto';
const j=JSON.parse(fs.readFileSync('analysis/toolchain/history-snapshot-rebuild-live.json'));
assert(j.complete);const hash=b=>crypto.createHash('sha256').update(b).digest('hex');
for(const [rid,sha]of Object.entries(j.identities))assert.equal(hash(fs.readFileSync(`resources/CODE/${rid}_${rid}.bin`)),sha);
const wasm=fs.readFileSync('.build/maven-history.wasm'),mod=await WebAssembly.compile(wasm);assert.deepEqual(WebAssembly.Module.imports(mod),[]);
const {exports:e}=await WebAssembly.instantiate(mod,{});
function put(id,hex,width=1){const b=typeof hex==='string'?Buffer.from(hex,'hex'):hex,p=e.maven_history_buffer(id),v=new DataView(e.memory.buffer);for(let i=0;i<b.length;i+=width){if(width===1)v.setUint8(p+i,b[i]);else if(width===2)v.setUint16(p+i,b.readUInt16BE(i),true);else v.setUint32(p+i,b.readUInt32BE(i),true);}}
function get(id,length,width=1){const b=Buffer.alloc(length),p=e.maven_history_buffer(id),v=new DataView(e.memory.buffer);for(let i=0;i<length;i+=width){if(width===1)b[i]=v.getUint8(p+i);else if(width===2)b.writeUInt16BE(v.getUint16(p+i,true),i);else b.writeUInt32BE(v.getUint32(p+i,true),i);}return b;}
const save=fs.readFileSync('../../media/maven/session/share/maven-search-enum8');assert.equal(save.subarray(4).toString('hex'),j.payload);
put(0,save);put(1,j.initial.board);put(3,j.initial.rack0+j.initial.rack1);put(5,j.initial.letter_values,2);
assert.equal(e.maven_history_decode(save.length),0);assert.equal(e.maven_history_count(),1);assert.equal(e.maven_history_snapshot(0),1);
const loaded=j.events.find(x=>x.kind==='tag0_return').state;
for(const[id,key,n,w]of [[1,'board',544,1],[2,'values',1088,2]])assert.equal(get(id,n,w).toString('hex'),loaded[key],key);
assert.equal(get(3,16).toString('hex'),loaded.rack0+loaded.rack1);assert.equal(e.maven_history_side(),0);
assert.deepEqual([get(4,8,4).readUInt32BE(0),get(4,8,4).readUInt32BE(4)],loaded.totals);
put(6,j.display_board);put(7,j.previous_display_board);put(8,j.letter_class);
assert.equal(e.maven_history_rebuild(j.force_board_refresh),1);
const rebuilt=j.events.find(x=>x.kind==='rebuild_return').state;
assert.equal(get(1,544).toString('hex'),rebuilt.board);assert.equal(get(2,1088,2).toString('hex'),rebuilt.values);
assert.equal(e.maven_history_snapshot(1),0);assert.equal(e.maven_history_decode(save.length-1),1);assert.equal(e.maven_history_count(),0);assert.equal(e.maven_history_snapshot(0),0);
console.log(JSON.stringify({scope:'Original tag0 snapshot load and subsequent display-board rebuild, plus checked wasm file/index bounds; no full history/turn claim',all_matched:true,imports:[],wasm_sha256:hash(wasm)}));
