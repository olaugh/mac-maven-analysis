import fs from 'node:fs';
import assert from 'node:assert/strict';
import crypto from 'node:crypto';
const capture=process.argv[2]||'simulation-cancel-live';
const j=JSON.parse(fs.readFileSync(`analysis/toolchain/${capture}.json`));
assert.ok(j.complete);assert.equal(j.saved.selected_pointer,j.a5-0x3c9a);
const before=j.events.find(x=>x.kind==='before_restore').state,after=j.events.find(x=>x.kind==='board_racks_restored').state;
const wasm=fs.readFileSync('.build/maven-simulation.wasm'),module=await WebAssembly.compile(wasm);assert.deepEqual(WebAssembly.Module.imports(module),[]);
const e=(await WebAssembly.instantiate(module,{})).exports;
const fields={board:0,values:1,rack0:7,rack1:8};
function put(state){for(const [key,id]of Object.entries(fields)){const p=e.maven_engine_buffer(id),bytes=Buffer.from(state[key],'hex');if(key==='values'){const v=new DataView(e.memory.buffer);for(let i=0;i<bytes.length;i+=2)v.setUint16(p+i,bytes.readUInt16BE(i),true);}else new Uint8Array(e.memory.buffer,p,bytes.length).set(bytes);}}
function get(key,size){const p=e.maven_engine_buffer(fields[key]);if(key!=='values')return Buffer.from(new Uint8Array(e.memory.buffer,p,size));const bytes=Buffer.alloc(size),v=new DataView(e.memory.buffer);for(let i=0;i<size;i+=2)bytes.writeUInt16BE(v.getUint16(p+i,true),i);return bytes;}
put(j.saved);e.maven_simulation_set(2,0);e.maven_simulation_save_position();put(before);e.maven_simulation_set(2,1);e.maven_simulation_restore_position();
for(const key of Object.keys(fields)){const expected=Buffer.from(after[key],'hex');assert.deepEqual(get(key,expected.length),expected,key);}
assert.equal(e.maven_simulation_get(9),0);
console.log(JSON.stringify({scope:'Pure position restoration compiled to wasm, matching original exit buffers; browser exit routing and post-session cache integration are outside this check',capture,exit_vehicle:j.controlled_mutation?'controlled lowered sample limit':'ordinary Escape',fields:Object.keys(fields),selected_side:0,imports:[],wasm_sha256:crypto.createHash('sha256').update(wasm).digest('hex'),all_matched:true},null,2));
