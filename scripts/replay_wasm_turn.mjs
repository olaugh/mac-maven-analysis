import fs from 'node:fs';
import crypto from 'node:crypto';
import assert from 'node:assert/strict';
const hash=b=>crypto.createHash('sha256').update(b).digest('hex');
const name=process.argv[2]||'turn-commit-tiores-live';
const j=JSON.parse(fs.readFileSync(`analysis/toolchain/${name}.json`));
assert.ok(j.complete&&j.turn);

const wasm=fs.readFileSync('.build/maven-engine.wasm');
const module=await WebAssembly.compile(wasm);assert.deepEqual(WebAssembly.Module.imports(module),[]);
const e=(await WebAssembly.instantiate(module,{})).exports;
const fields={board:[0,1],values:[1,2],letter_values:[2,2],word_multipliers:[3,1],letter_multipliers:[4,1],letter_class:[5,1],alphabet:[6,1],rack:[7,1],opponent_rack:[8,1],undo:[9,1],counts:[10,1],distribution:[11,1],vowel_characters:[12,1],opening_scores:[13,4],small_pool_scores:[14,2],q_with_unseen_u:[15,2],q_without_held_u:[16,2],unseen_q_query:[17,1],held_u_query:[18,1],letter_scores:[19,4],composition_scores:[20,4],pattern_records:[21,1],pattern_strings:[22,1],pattern_scores:[23,1],dictionary:[24,1],sections:[25,4],balance_entries:[26,4],mask_generations:[27,4],occurrence_masks:[28,2],tile_points:[29,2],leave_values:[30,2],canonical_masks:[31,2],ranking:[32,1],trace:[33,1],pattern_stamps:[34,4],move:[35,1],features:[36,4],ids:[37,2],weights:[38,2],display:[39,1],classes:[40,1],callbacks:[41,1],statistics:[42,4]};
function put(name,value){const [id,width]=fields[name],p=e.maven_engine_buffer(id),v=new DataView(e.memory.buffer);if(Array.isArray(value)){value.forEach((n,i)=>v.setUint32(p+i*4,n,true));return;}const b=typeof value==='string'?Buffer.from(value,'hex'):value;if(width===1)new Uint8Array(e.memory.buffer,p,b.length).set(b);else for(let i=0;i<b.length;i+=width){if(width===2)v.setUint16(p+i,b.readUInt16BE(i),true);else v.setUint32(p+i,b.readUInt32BE(i),true);}}
function get(name,length){const [id,width]=fields[name],p=e.maven_engine_buffer(id);if(width===1)return Buffer.from(new Uint8Array(e.memory.buffer,p,length)).toString('hex');const b=Buffer.alloc(length),v=new DataView(e.memory.buffer);for(let i=0;i<length;i+=width){if(width===2)b.writeUInt16BE(v.getUint16(p+i,true),i);else b.writeUInt32BE(v.getUint32(p+i,true),i);}return b.toString('hex');}
for(const key of ['pattern_records','pattern_strings','pattern_scores'])put(key,j[key]);
put('sections',[0,0]);
e.maven_engine_initialize(j.pattern_record_count);
assert.equal(e.maven_engine_get(12),j.lookup_entries.length);
for(const key of ['board','values','rack','undo','counts','balance_entries'])put(key,j.initial[key]);
put('opponent_rack',j.turn.application_entry.rack1);
for(const [key,value] of Object.entries(j.fixed)){
 if(key==='penalties'){new Uint8Array(e.memory.buffer,e.maven_engine_penalties(),80).set(Buffer.from(value,'hex'));continue;}
 if(['vowel_characters','unseen_q_query','held_u_query'].includes(key))put(key,Buffer.from(value+'\0','ascii'));
 else if(['letter_scores','composition_scores'].includes(key))put(key,value.flatMap(row=>[...row,...Array(8-row.length).fill(0)]));
 else put(key,value);
}
put('pattern_stamps',j.lookup_entries.map(x=>x.accumulator));

put('move',j.move);put('display',j.display_supplement.display);put('classes',j.display_supplement.classes);
put('statistics',j.turn.application_entry.statistics[0]);
const setters=[j.initial.row_zero_count,j.initial.new_tiles,...j.initial.recorded_row,...j.initial.recorded_column,j.initial.balance_pool_vowels,j.initial.balance_pool_consonants];
setters.forEach((v,i)=>e.maven_engine_set(i,v));
const began=performance.now();const result=e.maven_engine_apply()>>>0;const elapsed=performance.now()-began;
assert.equal(result,j.result_bits);assert.equal(e.maven_engine_get(14),j.contributions.length);assert.equal(e.maven_engine_get(15),2);
function words(values,width){const b=Buffer.alloc(values.length*width);values.forEach((v,i)=>width===4?b.writeUInt32BE(v>>>0,i*width):b.writeUInt16BE(v&65535,i*width));return b.toString('hex');}
assert.equal(get('ids',(j.contributions.length+1)*2),words([...j.contributions.map(x=>x.id),0],2));
assert.equal(get('weights',(j.contributions.length+1)*2),words([...j.contributions.map(x=>x.weight),0],2));
const final=j.turn.application_return;
assert.equal(get('features',88),words(final.features,4));assert.equal(get('statistics',88),words(j.turn.statistics_return.statistics[0],4));
const callback=j.scored_callbacks.map(x=>x.move).join('');assert.equal(get('callbacks',136),callback+callback);
for(const key of ['board','values','undo','counts'])assert.equal(get(key,final[key].length/2),final[key],key);
assert.equal(get('rack',8),final.rack0);assert.equal(get('balance_entries',256),j.final.balance_entries);
const results=[final.row_zero_count,final.new_tiles,...final.recorded_row,...final.recorded_column,j.final.balance_pool_vowels,j.final.balance_pool_consonants];
results.forEach((v,i)=>assert.equal(e.maven_engine_get(i)>>>0,v>>>0,`state ${i}`));
console.log(JSON.stringify({scope:'Evaluated application, computed collector and display callback,22 feature and22 accumulated statistic words in wasm; prepared engine tables; refill/save excluded',capture:name,contributions:j.contributions.length,all_matched:true,imports:[],wasm_sha256:hash(wasm),milliseconds:Math.round(elapsed*100)/100},null,2));
