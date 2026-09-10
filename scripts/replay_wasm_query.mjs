import fs from 'node:fs';
import crypto from 'node:crypto';
import assert from 'node:assert/strict';
const hash=b=>crypto.createHash('sha256').update(b).digest('hex');
const data=fs.readFileSync(process.argv[2]);
assert.equal(hash(data),'2619382321bca5b52967b3515d15b0592a8e1f641bce92f65edcf06ba10edb19');
const binary=fs.readFileSync('.build/maven-query.wasm');
const {instance}=await WebAssembly.instantiate(binary,{});
const e=instance.exports;
new Uint8Array(e.memory.buffer,e.maven_wasm_data(),data.length).set(data);
const cases=[['cat','cat','','',''],['blank','ca?','','',''],['filtered','ca?','c?','t',''],['required','ca?','','','t']];
const runs=[];
for(const [label,...fields] of cases) {
 const area=new Uint8Array(e.memory.buffer,e.maven_wasm_fields(),128);area.fill(0);
 fields.forEach((s,i)=>area.set(new TextEncoder().encode(s),i*32));
 const size=e.maven_wasm_query();
 const text=new TextDecoder().decode(new Uint8Array(e.memory.buffer,e.maven_wasm_output(),size));
 const path=`analysis/toolchain/word-enumerator-live-${label}.json`;
 const capture=JSON.parse(fs.readFileSync(path));
 const words=text.trimEnd().split('\n');assert.deepEqual(words,capture.original_words);
 runs.push({label,words:words.length,ordered_words_match:true,capture_sha256:hash(fs.readFileSync(path))});
}
console.log(JSON.stringify({scope:'Freestanding wasm table setup, preparation and enumeration in Node; staged fingerprinted data, no original filesystem/UI/error runtime',wasm_sha256:hash(binary),node:process.version,runs,total_words:runs.reduce((n,r)=>n+r.words,0)},null,2));
