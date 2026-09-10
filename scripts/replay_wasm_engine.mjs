import fs from 'node:fs';
import crypto from 'node:crypto';
import assert from 'node:assert/strict';
const hash=b=>crypto.createHash('sha256').update(b).digest('hex');
const name=process.argv[2]||'heuristic-search-live';
const j=JSON.parse(fs.readFileSync(`analysis/toolchain/${name}.json`));
assert.ok(j.complete&&j.search);
const data=fs.readFileSync('../../media/maven/session/share/maven2.1');
assert.equal(hash(data),j.dictionary_sha256);
const wasm=fs.readFileSync('.build/maven-engine.wasm');
const module=await WebAssembly.compile(wasm);assert.deepEqual(WebAssembly.Module.imports(module),[]);
const e=(await WebAssembly.instantiate(module,{})).exports;
const fields={board:[0,1],values:[1,2],letter_values:[2,2],word_multipliers:[3,1],letter_multipliers:[4,1],letter_class:[5,1],alphabet:[6,1],rack:[7,1],opponent_rack:[8,1],undo:[9,1],counts:[10,1],distribution:[11,1],vowel_characters:[12,1],opening_scores:[13,4],small_pool_scores:[14,2],q_with_unseen_u:[15,2],q_without_held_u:[16,2],unseen_q_query:[17,1],held_u_query:[18,1],letter_scores:[19,4],composition_scores:[20,4],pattern_records:[21,1],pattern_strings:[22,1],pattern_scores:[23,1],dictionary:[24,1],sections:[25,4],balance_entries:[26,4],mask_generations:[27,4],occurrence_masks:[28,2],tile_points:[29,2],leave_values:[30,2],canonical_masks:[31,2],ranking:[32,1],trace:[33,1],pattern_stamps:[34,4]};
function put(name,value){const [id,width]=fields[name],p=e.maven_engine_buffer(id),v=new DataView(e.memory.buffer);if(Array.isArray(value)){value.forEach((n,i)=>v.setUint32(p+i*4,n,true));return;}const b=typeof value==='string'?Buffer.from(value,'hex'):value;if(width===1)new Uint8Array(e.memory.buffer,p,b.length).set(b);else for(let i=0;i<b.length;i+=width){if(width===2)v.setUint16(p+i,b.readUInt16BE(i),true);else v.setUint32(p+i,b.readUInt32BE(i),true);}}
function get(name,length){const [id,width]=fields[name],p=e.maven_engine_buffer(id);if(width===1)return Buffer.from(new Uint8Array(e.memory.buffer,p,length)).toString('hex');const b=Buffer.alloc(length),v=new DataView(e.memory.buffer);for(let i=0;i<length;i+=width){if(width===2)b.writeUInt16BE(v.getUint16(p+i,true),i);else b.writeUInt32BE(v.getUint32(p+i,true),i);}return b.toString('hex');}
for(const key of ['pattern_records','pattern_strings','pattern_scores'])put(key,j[key]);
put('dictionary',data);put('sections',[...j.sections.flatMap(s=>[s.offset,s.root]),0,0]);
e.maven_engine_initialize(j.pattern_record_count);
assert.equal(e.maven_engine_get(12),j.lookup_entries.length);
for(const key of ['board','values','rack','undo','counts','balance_entries','mask_generations','occurrence_masks','tile_points'])put(key,j.initial[key]);
put('opponent_rack',j.opponent_rack);
for(const [key,value] of Object.entries(j.fixed)){
 if(key==='penalties'){new Uint8Array(e.memory.buffer,e.maven_engine_penalties(),80).set(Buffer.from(value,'hex'));continue;}
 if(['vowel_characters','unseen_q_query','held_u_query'].includes(key))put(key,Buffer.from(value+'\0','ascii'));
 else if(['letter_scores','composition_scores'].includes(key))put(key,value.flatMap(row=>[...row,...Array(8-row.length).fill(0)]));
 else put(key,value);
}
put('pattern_stamps',j.lookup_entries.map(x=>x.accumulator));
const setters=[j.initial.row_zero_count,j.initial.new_tiles,...j.initial.recorded_row,...j.initial.recorded_column,j.initial.balance_pool_vowels,j.initial.balance_pool_consonants,j.initial.generation,j.initial.ranking.cutoff_bits,j.leave_offset,j.extra_filter_pointer?1:0];
setters.forEach((v,i)=>e.maven_engine_set(i,v));
const began=performance.now();e.maven_engine_run();const elapsed=performance.now()-began;
assert.equal(e.maven_engine_get(11),j.candidates.length);
const trace=Buffer.from(get('trace',j.candidates.length*38),'hex');
j.candidates.forEach((c,i)=>{assert.equal(trace[i*38],c.phase,`phase ${i}`);assert.equal(trace.readInt16BE(i*38+2),c.mode,`mode ${i}`);assert.equal(trace.subarray(i*38+4,i*38+38).toString('hex'),c.move,`move ${i}`);});
assert.equal(get('ranking',340),j.final.ranking.moves);assert.equal(e.maven_engine_get(10),j.final.ranking.count);assert.equal(e.maven_engine_get(9)>>>0,j.final.ranking.cutoff_bits);
for(const key of ['board','values','rack','undo','counts','balance_entries','mask_generations','leave_values','canonical_masks'])assert.equal(get(key,j.final[key].length/2),j.final[key],key);
assert.equal(get('pattern_stamps',j.final_lookup_accumulators.length*4),Buffer.concat(j.final_lookup_accumulators.map(n=>{const b=Buffer.alloc(4);b.writeUInt32BE(n);return b;})).toString('hex'));
const results=[j.final.row_zero_count,j.final.new_tiles,...j.final.recorded_row,...j.final.recorded_column,j.final.balance_pool_vowels,j.final.balance_pool_consonants,j.final.generation];results.forEach((v,i)=>assert.equal(e.maven_engine_get(i)>>>0,v>>>0,`state ${i}`));
console.log(JSON.stringify({scope:'Complete recovered CODE28 heuristic search compiled to freestanding wasm; all original candidate phases, ranked moves and mutable state match; excludes multi-ply/endgame search and UI',capture:name,candidates:j.candidates.length,ranked:j.final.ranking.count,imports:[],wasm_sha256:hash(wasm),milliseconds:Math.round(elapsed*100)/100,all_matched:true},null,2));
