import fs from 'node:fs';
import crypto from 'node:crypto';
import assert from 'node:assert/strict';
const hash=b=>crypto.createHash('sha256').update(b).digest('hex');
const capture=name=>JSON.parse(fs.readFileSync(`analysis/toolchain/${name}.json`));
const scoreName=process.argv[2]||'move-score-live';
const score=capture(scoreName),restore=capture('game-restore-live'),undo=capture('move-undo-live');
assert.equal(hash(fs.readFileSync('resources/CODE/32_32.bin')),score.code32_sha256);
assert.equal(hash(fs.readFileSync('resources/CODE/31_31.bin')),undo.code31_sha256);
for(const ident of restore.identities)assert.equal(hash(fs.readFileSync(`resources/CODE/${ident.code_resource}_${ident.code_resource}.bin`)),ident.sha256);
const application=score.application_state||restore.state;
if(score.application_state)assert.equal(hash(fs.readFileSync('resources/CODE/31_31.bin')),score.application_code31_sha256);
const binary=fs.readFileSync('.build/maven-board.wasm');
const module=await WebAssembly.compile(binary);assert.deepEqual(WebAssembly.Module.imports(module),[]);
const instance=await WebAssembly.instantiate(module,{}),e=instance.exports;
const fields={board:0,values:1,letter_values:2,word_multipliers:3,letter_multipliers:4,letter_class:5,alphabet:6,move:7,rack:8,undo:9,counts:10,remaining_rack:11};
function put(name,hex){
 assert.ok(Object.hasOwn(fields,name));
 const b=Buffer.from(hex,'hex'),p=e.maven_board_buffer(fields[name]);
 if(name==='values'||name==='letter_values'){
  const view=new DataView(e.memory.buffer);for(let i=0;i<b.length;i+=2)view.setUint16(p+i,b.readUInt16BE(i),true);
 }else new Uint8Array(e.memory.buffer,p,b.length).set(b);
}
function get(name,length){
 const p=e.maven_board_buffer(fields[name]);
 if(name==='values'||name==='letter_values'){
  const b=Buffer.alloc(length),view=new DataView(e.memory.buffer);
  for(let i=0;i<length;i+=2)b.writeUInt16BE(view.getUint16(p+i,true),i);return b.toString('hex');
 }
 return Buffer.from(new Uint8Array(e.memory.buffer,p,length)).toString('hex');
}
function text(name,length=8){return Buffer.from(get(name,length),'hex').toString('ascii').split('\0')[0];}
e.maven_board_reset();for(const [name,hex] of Object.entries(score.initial))put(name,hex);
assert.equal(e.maven_board_score()>>>0,score.result.score_bits);
assert.equal(text('remaining_rack'),Buffer.from(score.result.remaining_rack,'hex').toString('ascii').split('\0')[0]);
assert.equal(e.maven_board_result(0),score.result.new_tiles);
assert.deepEqual([e.maven_board_result(1),e.maven_board_result(2)],score.result.zero_value_row);
assert.deepEqual([e.maven_board_result(3),e.maven_board_result(4)],score.result.zero_value_column);
e.maven_board_prepare_counts();e.maven_board_apply();
for(const [name,len] of [['board',544],['values',1088],['undo',33]])assert.equal(get(name,len),application[name]);
if(score.application_state)assert.equal(get('counts',128),application.counts);
assert.equal(text('rack'),'i');assert.equal(e.maven_board_result(5),6);assert.equal(e.maven_board_result(6),0);
e.maven_board_reset();for(const name of ['board','values','undo','rack','counts'])put(name,undo.initial[name]);
e.maven_board_set_counter(undo.initial.row_zero_count);e.maven_board_undo();
for(const [name,len] of [['board',544],['values',1088],['undo',33],['rack',8],['counts',128]])assert.equal(get(name,len),undo.result[name]);
assert.equal(e.maven_board_result(6),undo.result.row_zero_count);
console.log(JSON.stringify({scope:'Freestanding wasm scorer, non-evaluation application, and undo in Node; original captured inputs; no UI/refill/history/AI ranking. Application evidence follows selected score capture: direct if application_state exists, otherwise split restore capture.',imports:[],wasm_sha256:hash(binary),node:process.version,score:score.result.score_bits,scorer_outputs_match:true,application_board_value_undo_match:true,undo_full_state_match:true,captures:[scoreName,...(score.application_state?[]:['game-restore-live']),'move-undo-live'].map(n=>({name:n,sha256:hash(fs.readFileSync(`analysis/toolchain/${n}.json`))}))},null,2));
