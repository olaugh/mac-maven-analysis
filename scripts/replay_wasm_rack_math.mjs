import fs from 'node:fs';
import crypto from 'node:crypto';
import assert from 'node:assert/strict';
const hash=b=>crypto.createHash('sha256').update(b).digest('hex');
const names=['letter-expectation-live','rack-composition-live','rack-composition-baseline-live'];
const captures=names.map(n=>JSON.parse(fs.readFileSync(`analysis/toolchain/${n}.json`)));
const sourceHash=hash(fs.readFileSync('resources/CODE/32_32.bin'));
for(const c of captures)assert.equal(c.code32_sha256,sourceHash);
const binary=fs.readFileSync('.build/maven-rack-math.wasm'),module=await WebAssembly.compile(binary);
assert.deepEqual(WebAssembly.Module.imports(module),[]);
const {exports:e}=await WebAssembly.instantiate(module,{});
function put(scores){const view=new DataView(e.memory.buffer),p=e.maven_rack_math_scores();for(let i=0;i<8;++i)view.setUint32(p+4*i,scores?.[i]??0,true);}
for(const c of captures[0].calls){put(c.scores);assert.equal(e.maven_rack_math_expectation(c.total,c.letter_count)>>>0,c.result_bits);}
for(const c of captures.slice(1)){put(c.terminal_scores);assert.equal(e.maven_rack_math_composition(...c.args)>>>0,c.result_bits);}
console.log(JSON.stringify({scope:'Freestanding wasm exact-integer letter expectation and original integer rack composition, compared with captured original outputs; no UI or full ranking',imports:[],wasm_sha256:hash(binary),node:process.version,expectation_calls_matching:captures[0].calls.length,composition_calls_matching:2,captures:names.map(n=>({name:n,sha256:hash(fs.readFileSync(`analysis/toolchain/${n}.json`))}))},null,2));
