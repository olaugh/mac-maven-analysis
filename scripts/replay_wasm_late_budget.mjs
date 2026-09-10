// Original natural and explicitly controlled CPU-gate inputs through wasm.
import fs from 'node:fs';
import assert from 'node:assert/strict';
import crypto from 'node:crypto';
const bytes=fs.readFileSync('.build/maven-simulation.wasm');
const {instance}=await WebAssembly.instantiate(bytes,{});
const api=instance.exports;
const base=api.memory.grow(1)*65536;
const view=new DataView(api.memory.buffer);
const results=[];
for(const name of ['late-budget-live','late-budget-controlled-live']) {
  const j=JSON.parse(fs.readFileSync(`analysis/toolchain/${name}.json`));
  assert(j.complete);
  for(const [rid,hash] of Object.entries(j.identities))
    assert.equal(crypto.createHash('sha256').update(fs.readFileSync(`resources/CODE/${rid}_${rid}.bin`)).digest('hex'),hash);
  const table=Buffer.from(j.table,'hex');
  for(let i=0;i<54;i++)view.setUint16(base+2*i,table.readUInt16BE(2*i),true);
  const decision=api.maven_late_search_decision(base,j.own_blanks,j.unseen_blanks,j.unseen_total,j.calibration,0,base+108);
  assert.equal(decision,Number(j.heuristic_fallback));
  assert.equal(view.getUint32(base+108,true),j.quotient);
  results.push({capture:name,estimate:j.quotient,fallback:!!decision,controlled_input:!!j.controlled_input});
}
assert.equal(api.maven_late_search_decision(0,99,99,99,0,1,base+108),0);
assert.equal(view.getUint32(base+108,true),0);
assert.equal(api.maven_late_search_decision(base,0,0,9,0,0,base+108),-1);
console.log(JSON.stringify({scope:'Original CPU budget decisions in freestanding wasm; native selector routing has separate tests',results,all_matched:true}));
