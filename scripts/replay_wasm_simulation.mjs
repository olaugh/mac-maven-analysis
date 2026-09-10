import fs from 'node:fs';
import crypto from 'node:crypto';
import assert from 'node:assert/strict';
const hash=b=>crypto.createHash('sha256').update(b).digest('hex');
const args=process.argv.slice(2),names=[];let drawName=null,rankingName=null,sessionMode=false;
for(let i=0;i<args.length;++i){if(args[i]==='--session')sessionMode=true;else if(args[i]==='--opponent-draw')drawName=args[++i];else if(args[i]==='--ranking')rankingName=args[++i];else names.push(args[i]);}
const draw=drawName?JSON.parse(fs.readFileSync(`analysis/toolchain/${drawName}.json`)):null;
if(!names.length)for(let i=1;i<=5;++i)names.push(`rollout-exhaustive-live-${String(i).padStart(2,'0')}`);
const captures=names.map(n=>JSON.parse(fs.readFileSync(`analysis/toolchain/${n}.json`))),j=captures[0],last=captures.at(-1);
assert.ok(captures.every(x=>x.complete));
const enumeration=JSON.parse(fs.readFileSync('analysis/toolchain/opponent-samples-live.json'));
const exhaustive=captures.length>1;
const rankingPath=rankingName?`analysis/toolchain/${rankingName}.json`:exhaustive?'analysis/toolchain/candidate-exhaustive-ranking-02-live.json':j.late_calls?.length?'analysis/toolchain/candidate-late-ranking-live.json':'analysis/toolchain/candidate-endgame-ranking-live.json';
const finalRanking=sessionMode?null:JSON.parse(fs.readFileSync(rankingPath)).calls[0];
if(finalRanking)assert.equal(finalRanking.entries,last.final_config.slice(48));
if(sessionMode)assert(last.session_tail && (exhaustive || draw));
for(let i=1;i<captures.length;++i){assert.deepEqual(captures[i].initial,captures[i-1].final);assert.equal(captures[i].config,captures[i-1].final_config);}
if(exhaustive)assert.deepEqual(captures.map(x=>[x.opponent_sample,x.weight]),enumeration.samples.map(x=>[x.rack,x.weight]));
const data=fs.readFileSync('../../media/maven/session/share/maven2.1');
assert.equal(hash(data),j.dictionary_sha256);
const wasm=fs.readFileSync('.build/maven-simulation.wasm');
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
put('rack',j.initial.rack0);put('opponent_rack',j.initial.rack1);
for(const [key,value] of Object.entries(j.fixed)){
 if(key==='penalties'){new Uint8Array(e.memory.buffer,e.maven_engine_penalties(),80).set(Buffer.from(value,'hex'));continue;}
 if(['vowel_characters','unseen_q_query','held_u_query'].includes(key))put(key,Buffer.from(value+'\0','ascii'));
 else if(['letter_scores','composition_scores'].includes(key))put(key,value.flatMap(row=>[...row,...Array(8-row.length).fill(0)]));
 else put(key,value);
}
put('pattern_stamps',j.lookup_entries.map(x=>x.accumulator));
const setters=[j.initial.row_zero_count,j.initial.new_tiles,...j.initial.recorded_row,...j.initial.recorded_column,j.initial.balance_pool_vowels,j.initial.balance_pool_consonants,j.initial.generation,j.initial.ranking.cutoff_bits,0,0];
setters.forEach((v,i)=>e.maven_engine_set(i,v));

function simPut(id,b,width=1){const p=e.maven_simulation_buffer(id),v=new DataView(e.memory.buffer);if(width===1)new Uint8Array(e.memory.buffer,p,b.length).set(b);else for(let i=0;i<b.length;i+=width)width===2?v.setUint16(p+i,b.readUInt16BE(i),true):v.setUint32(p+i,b.readUInt32BE(i),true);}
const be32=n=>{const b=Buffer.alloc(4);b.writeUInt32BE(n>>>0);return b;};
const refills=[...(draw?[{...draw,private_seed:draw.initial.private_seed,stack_ticks:draw.initial.stack_ticks}]:[]),...captures.flatMap(x=>x.refills)],random=refills.flatMap(x=>x.events);
simPut(0,Buffer.from(j.config.slice(48),'hex'));simPut(1,Buffer.from(enumeration.choose,'hex'),2);
simPut(2,Buffer.concat(random.flatMap(x=>[be32(['private_random','toolbox_random','ticks'].indexOf(x.kind)),be32(x.value)])),4);
simPut(3,Buffer.concat(refills.map(x=>be32(x.stack_ticks))),4);simPut(4,Buffer.from(j.initial.selected_move,'hex'));
const cfg=Buffer.from(j.config,'hex');[j.candidate_count,cfg.readInt16BE(8),j.initial.selected_rack_pointer===j.a5-0x3c9a?0:1,refills[0].private_seed,random.length,refills.length].forEach((v,i)=>e.maven_simulation_set(i,v));
e.maven_simulation_set(13,j.interrupted?j.events.length:0);
e.maven_simulation_set(10,sessionMode?(draw?4:3):draw?2:exhaustive?1:0);e.maven_simulation_set(11,j.weight);simPut(11,Buffer.from(j.opponent_sample+'\0'));
if(draw){
 assert.ok(!exhaustive);assert.equal(draw.final.private_seed,j.refills[0].private_seed);
 assert.equal(draw.final.board,j.initial.board);assert.equal(draw.initial.rack0,j.initial.rack0);assert.equal(draw.initial.rack1,j.initial.rack1);
 assert.equal(Buffer.from(draw.sample_callback.rack,'hex').subarray(0,7).toString(),j.opponent_sample);assert.equal(j.weight,1);
 put('board',draw.sample_before.board);put('rack',draw.sample_before.rack0);put('opponent_rack',draw.sample_before.rack1);simPut(11,Buffer.from(draw.sample_before.sample,'hex'));
}
const endCalls=captures.flatMap(x=>x.endgame_calls||[]),endClocks=[];let eventOffset=0,callRows=[];
for(const capture of captures){for(const call of capture.endgame_calls||[]){callRows.push([call.event_index+eventOffset,call.side,call.budget,call.reserve,call.start_ticks||0,endClocks.length,call.elapsed.length]);endClocks.push(...call.elapsed);}eventOffset+=capture.events.length;}
if(endCalls.length){assert.equal(j.search_fixed.capacity,8192);simPut(6,Buffer.from(j.search_fixed.bit_masks,'hex'),4);simPut(7,Buffer.from(j.search_fixed.hash_table,'hex'),4);simPut(8,Buffer.from(j.search_fixed.row_flags,'hex'));
simPut(9,Buffer.concat(callRows.flatMap(r=>r.map(be32))),4);simPut(10,Buffer.concat(endClocks.flatMap(x=>[be32(x.ticks),be32(x.result)])),4);}
if(j.late_calls?.length){const f=j.search_fixed;simPut(6,Buffer.from(f.bit_masks,'hex'),4);simPut(8,Buffer.from(f.row_flags,'hex'));simPut(12,Buffer.from(f.late_tables,'hex'),2);simPut(13,Buffer.from(f.priority,'hex'));simPut(14,Buffer.from(f.search_q_query+'\0'));simPut(15,Buffer.from(f.search_blank_query+'\0'));simPut(16,Buffer.from(f.exchange_q_string+'\0'));e.maven_simulation_set(12,f.leave_offset);}
e.maven_simulation_set(6,cfg.readInt16BE(20));e.maven_simulation_set(7,cfg.readInt16BE(18));e.maven_simulation_set(8,endCalls.length);e.maven_simulation_set(9,endClocks.length);
const began=performance.now();assert.equal(e.maven_simulation_run(),1);const elapsed=performance.now()-began;
const events=captures.flatMap(x=>x.events),kinds=['candidate_applied','candidate_refilled','reply_selected','reply_applied','reply_refilled','candidate_restored'];
assert.equal(e.maven_simulation_get(0),events.length);
events.forEach((event,i)=>{const st=event.state,kind=kinds.indexOf(event.kind),side=st.selected_rack_pointer===j.a5-0x3c9a?0:1;
const expected=Buffer.concat([... [kind,event.candidate,kind<2?0:event.reply,side,st.row_zero_count,st.new_tiles,...st.recorded_row,...st.recorded_column].map(be32),...['board','values','rack0','rack1','counts','undo','selected_move'].map(k=>Buffer.from(st[k],'hex')),Buffer.from(event.candidate_entries,'hex')]);
assert.equal(expected.length,e.maven_simulation_get(1));const actual=Buffer.from(new Uint8Array(e.memory.buffer,e.maven_simulation_event(i),expected.length));assert.deepEqual(actual,expected,`event ${i} ${event.kind}`);});
function simGet(id,n){return Buffer.from(new Uint8Array(e.memory.buffer,e.maven_simulation_buffer(id),n)).toString('hex');}
if(draw){assert.equal(simGet(11,8),draw.final.rack);assert.equal(simGet(17,draw.final.bag_workspace.length/2),draw.final.bag_workspace);}
assert.equal(simGet(0,j.candidate_count*46),last.final_config.slice(48));if(finalRanking)assert.equal(simGet(5,j.candidate_count*34),finalRanking.output);
if(sessionMode){
 let offset=0;const publications=[];
 for(const capture of captures){for(const publication of capture.publications??[])publications.push({...publication,event_index:publication.event_index+offset});offset+=capture.events.length;}
 if(publications.length){
  assert.equal(e.maven_simulation_get(13),publications.length);
  publications.forEach((p,i)=>{const expected=Buffer.concat([be32(p.count),be32(p.event_index),Buffer.from(p.moves,'hex')]);
   const actual=Buffer.from(new Uint8Array(e.memory.buffer,e.maven_simulation_buffer(19)+2184*i,expected.length));assert.deepEqual(actual,expected,`publication ${i}`);});
 }
 assert.equal(e.maven_simulation_get(10),3);assert.equal(e.maven_simulation_get(12),j.interrupted?4:draw?3:2);
 last.session_tail.slice(0,3).forEach((phase,i)=>{
  const st=phase.state,expected=Buffer.concat([...['board','values','rack0','rack1','counts','undo','leave_values','tile_points','canonical_masks','occurrence_masks','mask_generations'].map(k=>Buffer.from(st[k],'hex')),be32(st.generation)]);
  assert.equal(e.maven_simulation_get(11),expected.length);
  const actual=Buffer.from(new Uint8Array(e.memory.buffer,e.maven_simulation_buffer(18)+6000*i,expected.length));assert.deepEqual(actual,expected,phase.kind);
 });
}
const finalState=sessionMode?last.session_tail.at(-1).state:last.final;
for(const key of ['board','values','undo','counts'])assert.equal(get(key,finalState[key].length/2),finalState[key],key);
assert.equal(get('rack',8),finalState.rack0);assert.equal(get('opponent_rack',8),finalState.rack1);
assert.equal(e.maven_simulation_get(2),random.length);assert.equal(e.maven_simulation_get(3),refills.length);assert.equal(e.maven_simulation_get(4),refills.at(-1).final.private_seed);assert.equal(e.maven_simulation_get(5),j.interrupted?0:captures.length);assert.equal(e.maven_simulation_get(6),j.interrupted?0:captures.reduce((s,x)=>s+x.weight,0));
assert.equal(e.maven_simulation_get(7),endCalls.length);assert.equal(e.maven_simulation_get(8),endClocks.length);
console.log(JSON.stringify({computed_opponent_draw:!!draw,exhaustive,complete_session:sessionMode,final_ranking_compared:!!finalRanking,publications_compared:sessionMode?captures.reduce((n,c)=>n+(c.publications?.length??0),0):0,endgame_calls:endCalls.length,scope:sessionMode?'Session draw/batches, partial or complete candidate totals, and three original cleanup boundaries; observed external RNG/clock inputs':'Complete rollout computation and sampled ranking; observed external RNG/clock inputs',interrupted:!!j.interrupted,batches:captures.length,candidates:j.candidate_count,events:events.length,refills:refills.length,external_events:random.length,imports:[],wasm_sha256:hash(wasm),milliseconds:Math.round(elapsed*100)/100,all_matched:true},null,2));
