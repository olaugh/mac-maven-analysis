import fs from 'node:fs';
import zlib from 'node:zlib';
import crypto from 'node:crypto';
import assert from 'node:assert/strict';
const name=process.argv[2]||'endgame-search-live';
const j=JSON.parse(zlib.gunzipSync(fs.readFileSync(`analysis/toolchain/${name}.json.gz`)));
assert.ok(j.complete);
const hash=b=>crypto.createHash('sha256').update(b).digest('hex');
const data=fs.readFileSync('../../media/maven/session/share/maven2.1');assert.equal(hash(data),j.dictionary_sha256);
const wasm=fs.readFileSync('.build/maven-endgame.wasm');const module=await WebAssembly.compile(wasm);assert.deepEqual(WebAssembly.Module.imports(module),[]);const e=(await WebAssembly.instantiate(module,{})).exports;
const fields={board:[0,1],values:[1,2],letter_values:[2,2],word_multipliers:[3,1],letter_multipliers:[4,1],letter_class:[5,1],alphabet:[6,1],own:[7,1],other:[8,1],undo:[9,1],counts:[10,1],row_flags:[11,1],hash_table:[12,4],bit_masks:[13,4],dictionary:[14,1],sections:[15,4],sorted_rack:[16,1],canonical_masks:[17,2],tile_points:[18,2],occurrence_masks:[19,2],best:[20,4],second:[21,4],tables:[22,2],nodes:[23,0],ranking:[24,1],selected_move:[25,1],leave_values:[26,2],upper_scores:[27,4],lower_scores:[28,4],best_empty_move:[29,1],conflicts:[30,4],elapsed_ticks:[31,4]};
function put(name,value){const [id,width]=fields[name],p=e.maven_endgame_buffer(id),v=new DataView(e.memory.buffer);if(Array.isArray(value)){value.forEach((n,i)=>v.setUint32(p+i*4,n,true));return;}const b=typeof value==='string'?Buffer.from(value,'hex'):value;if(width===1)new Uint8Array(e.memory.buffer,p,b.length).set(b);else for(let i=0;i<b.length;i+=width){if(width===2)v.setUint16(p+i,b.readUInt16BE(i),true);else v.setUint32(p+i,b.readUInt32BE(i),true);}}
function get(name,length){const [id,width]=fields[name],p=e.maven_endgame_buffer(id);if(width===1)return Buffer.from(new Uint8Array(e.memory.buffer,p,length)).toString('hex');const b=Buffer.alloc(length),v=new DataView(e.memory.buffer);if(name==='nodes'){for(let i=0;i<length;i+=32){for(let off=0;off<12;off+=2)b.writeUInt16BE(v.getUint16(p+i+off,true),i+off);b.writeUInt32BE(v.getUint32(p+i+12,true),i+12);b.set(new Uint8Array(e.memory.buffer,p+i+16,16),i+16);}return b.toString('hex');}for(let i=0;i<length;i+=width){if(width===2)b.writeUInt16BE(v.getUint16(p+i,true),i);else b.writeUInt32BE(v.getUint32(p+i,true),i);}return b.toString('hex');}
put('dictionary',data);put('sections',[...j.sections.flatMap(s=>[s.offset,s.root]),0,0]);e.maven_endgame_initialize();
for(const [key,value]of Object.entries(j.fixed))if(key!=='bingo_bonus')put(key,value);
for(const key of ['board','values','counts','undo','row_flags','sorted_rack','canonical_masks','tile_points','occurrence_masks','best','second','leave_values','upper_scores','lower_scores','best_empty_move'])put(key,j.initial[key]);
if(!j.iterations.length){
 const raw=Buffer.from(j.initial.nodes,'hex'),p=e.maven_endgame_buffer(23),v=new DataView(e.memory.buffer);for(let i=0;i<raw.length;i+=32){for(let off=0;off<12;off+=2)v.setUint16(p+i+off,raw.readUInt16BE(i+off),true);v.setUint32(p+i+12,raw.readUInt32BE(i+12),true);new Uint8Array(e.memory.buffer,p+i+16,16).set(raw.subarray(i+16,i+32));}
 e.maven_endgame_set(11,j.initial.free_head);e.maven_endgame_set(12,j.initial.current);
}
put('conflicts',j.initial.conflicts);
put('selected_move',j.initial.best_empty_move);put('own',j.own);put('other',j.other);put('tables',['own','other'].flatMap(side=>['a','b','error'].map(k=>j.initial.tables[`${side}_${k}`])).join(''));put('elapsed_ticks',j.elapsed.map(x=>x.ticks));
[j.initial.row_zero_count,j.initial.new_tiles,...j.initial.rows,...j.initial.columns,j.initial.ranking.cutoff,j.initial.reserve_control,j.budget,j.start_ticks||0,j.fixed.bingo_bonus].forEach((v,i)=>e.maven_endgame_set(i,v));
const began=performance.now();e.maven_endgame_run();const ms=performance.now()-began;
assert.equal(e.maven_endgame_get(7),j.final.ranking.count);assert.equal(e.maven_endgame_get(6)>>>0,j.final.ranking.cutoff);assert.equal(e.maven_endgame_get(8),j.iterations.length);assert.equal(e.maven_endgame_get(9),j.elapsed.length);
assert.equal(get('ranking',340),j.final.ranking.moves);assert.equal(get('nodes',j.capacity*32),j.final.nodes);
for(const key of ['board','values','counts','undo','row_flags','sorted_rack','canonical_masks','tile_points','occurrence_masks','best','second','leave_values','conflicts'])assert.equal(get(key,j.final[key].length/2),j.final[key],key);
assert.equal(get('tables',13824),['own','other'].flatMap(side=>['a','b','error'].map(k=>j.final.tables[`${side}_${k}`])).join(''));
assert.equal(get('own',8),j.final_own);assert.equal(get('other',8),j.final_other);assert.equal(get('selected_move',34),j.initial.best_empty_move);assert.equal(get('letter_values',256),j.fixed.letter_values);
[j.final.row_zero_count,j.final.new_tiles,...j.final.rows,...j.final.columns].forEach((v,i)=>assert.equal(e.maven_endgame_get(i)>>>0,v>>>0,`state ${i}`));assert.equal(e.maven_endgame_get(10),j.fixed.bingo_bonus);assert.equal(e.maven_endgame_get(11),j.final.free_head);assert.equal(e.maven_endgame_get(12),j.final.current);assert.equal(e.maven_endgame_get(13),j.final.mask_count);
console.log(JSON.stringify({scope:'Complete CODE30/45/29 endgame search compiled to freestanding wasm; captured clock/hash inputs, all nodes, final rankings and documented state match',capture:name,iterations:j.iterations.length,ranked:j.final.ranking.count,imports:[],wasm_sha256:hash(wasm),milliseconds:Math.round(ms*100)/100,all_matched:true},null,2));
