import fs from 'node:fs';
import zlib from 'node:zlib';
import crypto from 'node:crypto';
import assert from 'node:assert/strict';
const capture=process.argv[2]||'late-search-live';
const j=JSON.parse(zlib.gunzipSync(fs.readFileSync(`analysis/toolchain/${capture}.json.gz`)));
const l=JSON.parse(fs.readFileSync('analysis/toolchain/late-leave-table-live.json'));
const p=JSON.parse(zlib.gunzipSync(fs.readFileSync('analysis/toolchain/late-preparation-live.json.gz')));
assert.ok(j.complete);
const hash=b=>crypto.createHash('sha256').update(b).digest('hex');
const dictionary=fs.readFileSync('../../media/maven/session/share/maven2.1');assert.equal(hash(dictionary),j.dictionary_sha256);
const wasm=fs.readFileSync('.build/maven-late.wasm'),module=await WebAssembly.compile(wasm);assert.deepEqual(WebAssembly.Module.imports(module),[]);
const e=(await WebAssembly.instantiate(module,{})).exports;e.maven_late_initialize();
const fields={board:[0,1],values:[1,2],letter_values:[2,2],word_multipliers:[3,1],letter_multipliers:[4,1],letter_class:[5,1],alphabet:[6,1],rack:[7,1],undo:[8,1],counts:[9,1],row_flags:[10,1],bit_masks:[11,4],dictionary:[12,1],sections:[13,4],leave:[14,2],tile_points:[15,2],occurrences:[16,2],mask_generations:[17,4],canonical_masks:[18,2],balance_entries:[19,4],tables:[20,2],distribution:[21,1],q_with_unseen_u:[22,2],q_without_held_u:[23,2],vowel_characters:[24,1],held_u_query:[25,1],search_q_query:[26,1],search_blank_query:[27,1],priority:[28,1],letter_scores:[29,4],composition_scores:[30,4],pattern_strings:[31,1],pattern_scores:[32,1],entry_spec:[33,4],match_records:[34,1],match_strings:[35,1],match_scores:[36,1],pool_records:[37,1],letter_leave:[38,2],column_cache:[39,2],search_occurrences:[40,2],ranking:[41,1],local_records:[42,1],constraint_masks:[43,2],constraint_weights:[44,2],conflicts:[45,4]};
function put(name,value){const [id,width]=fields[name],ptr=e.maven_late_buffer(id),v=new DataView(e.memory.buffer);if(Array.isArray(value)){value.forEach((n,i)=>width===2?v.setUint16(ptr+i*2,n,true):v.setUint32(ptr+i*4,n,true));return;}const b=typeof value==='string'?Buffer.from(value,'hex'):value;if(width===1)new Uint8Array(e.memory.buffer,ptr,b.length).set(b);else for(let i=0;i<b.length;i+=width){if(width===2)v.setUint16(ptr+i,b.readUInt16BE(i),true);else v.setUint32(ptr+i,b.readUInt32BE(i),true);}}
function get(name,length){const [id,width]=fields[name],ptr=e.maven_late_buffer(id),v=new DataView(e.memory.buffer),b=Buffer.alloc(length);if(width===1)b.set(new Uint8Array(e.memory.buffer,ptr,length));else for(let i=0;i<length;i+=width){if(width===2)b.writeUInt16BE(v.getUint16(ptr+i,true),i);else b.writeUInt32BE(v.getUint32(ptr+i,true),i);}return b.toString('hex');}
for(const n of ['board','values','counts','undo','rack','leave','tile_points','occurrences','mask_generations','canonical_masks','balance_entries','row_flags'])put(n,j.initial[n]);
for(const n of ['letter_values','word_multipliers','letter_multipliers','letter_class','bit_masks','alphabet','tables'])put(n,j.fixed[n]);
for(const n of ['distribution','q_with_unseen_u','q_without_held_u'])put(n,l.fixed[n]);
for(const n of ['vowel_characters','held_u_query','search_q_query','search_blank_query'])put(n,Buffer.from(l.fixed[n]+'\0'));
put('letter_scores',l.fixed.letter_scores.flat());put('composition_scores',l.fixed.composition_scores.flatMap(r=>[...r,...Array(8-r.length).fill(0)]));
put('pattern_strings',l.pattern_strings);put('pattern_scores',l.pattern_scores);put('entry_spec',l.lookup_entries.flatMap((r,i)=>[r.string_offset,j.initial.lookup_stamps[i],r.table_index]));
put('dictionary',dictionary);put('sections',[...j.sections.flatMap(s=>[s.offset,s.root]),0,0]);put('priority',j.priority_order);
put('match_records',p.patterns.raw_records);put('match_scores',p.patterns.score_records);
const minimum=Math.min(0,...Object.keys(p.patterns.strings).map(Number)),maximum=Math.max(...Object.entries(p.patterns.strings).map(([off,s])=>+off+s.length+1)),strings=Buffer.alloc(maximum-minimum);
for(const [off,s]of Object.entries(p.patterns.strings))strings.write(s,+off-minimum,'ascii');put('match_strings',strings);
const ready=j.checkpoints[0].state;put('pool_records',ready.pool_records);put('letter_leave',Buffer.from(j.initial.globals,'hex').subarray(0x8da-0x888,0x8da-0x888+256));put('search_occurrences',j.initial.occurrences);
const cache=Buffer.from(ready.column_cache,'hex');put('column_cache',Array.from({length:16},(_,i)=>{const off=cache.readUInt32BE(i*4)-ready.pool_base;return off>=0&&off%66===0&&off<90*66?off/66:-1;}));
[j.initial.row_zero_count,j.initial.new_tiles,...j.initial.recorded_row,...j.initial.recorded_column,j.initial.generation,j.initial.started_generation,j.initial.balance_pool_vowels,j.initial.balance_pool_consonants,l.lookup_entries.length,p.patterns.record_count,-minimum,ready.pool_base,ready.local_base,j.initial.main_triple].forEach((v,i)=>e.maven_late_set(i,v));
const began=performance.now();assert.equal(e.maven_late_run(),1);const ms=performance.now()-began;
assert.equal(e.maven_late_get(0),j.final.ranking_count);assert.equal(e.maven_late_get(1),30);
for(const n of ['board','values','rack','ranking','leave','tile_points','canonical_masks'])assert.equal(get(n,j.final[n].length/2),j.final[n],n);
for(const [id,key]of [[2,'generation'],[3,'started_generation'],[4,'mask_count']])assert.equal(e.maven_late_get(id),j.final[key]);
const last=j.checkpoints.at(-1).state;const count=Buffer.from(last.globals,'hex').readUInt16BE(0x8da-0x80c);assert.equal(e.maven_late_get(5),count);
for(const n of ['constraint_masks','constraint_weights'])assert.equal(get(n,count*2),last[n].slice(0,count*4));
assert.equal(get('conflicts',17408),last.conflicts);
for(const n of ['pool_records','local_records']){const a=Buffer.from(get(n,5940),'hex'),b=Buffer.from(last[n],'hex');for(let i=0;i<90;++i)for(let k=4;k<66;++k)if(k<50||k>=54)assert.equal(a[i*66+k],b[i*66+k],`${n} record${i} byte${k}`);}
console.log(JSON.stringify({scope:'Complete CODE36 late search in freestanding wasm; ten ranked moves, both reply pools, constraints and leaves match original',capture,imports:[],checkpoints:30,ranked:j.final.ranking_count,wasm_sha256:hash(wasm),milliseconds:Math.round(ms*100)/100,all_matched:true},null,2));
