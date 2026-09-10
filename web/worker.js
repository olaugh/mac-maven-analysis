/* Engine worker: owns the single Maven engine instance for the page's
 * lifetime, exactly as one Maven application instance did on the Mac.
 * Long searches run synchronously here; cancellation uses a shared flag
 * when SharedArrayBuffer is available. */
import { Engine, packResources, positionFromCGP } from './engine/host.mjs';

let engine = null;
let cancelFlag = null; // Int32Array over a SharedArrayBuffer, or null
let searchStart = 0;
let resourcesPacket = null;

function post(msg) { self.postMessage(msg); }

async function init({ wasmUrl, resourceUrls, dictionaryUrl, dictionaryBytes, shared }) {
  const wasm = await (await fetch(wasmUrl)).arrayBuffer();
  const blobs = await Promise.all(resourceUrls.map(async u => new Uint8Array(await (await fetch(u)).arrayBuffer())));
  resourcesPacket = packResources(blobs);
  const dictionary = dictionaryBytes || new Uint8Array(await (await fetch(dictionaryUrl)).arrayBuffer());
  if (shared) cancelFlag = new Int32Array(shared);
  engine = await Engine.instantiate(wasm, {
    ticks: () => Math.floor(performance.now() * 60 / 1000),
    elapsedSeconds: () => Math.floor((performance.now() - searchStart) / 1000),
    cancelRequested: () => cancelFlag ? Atomics.load(cancelFlag, 0) !== 0 : false,
    publish: (moves, count) => post({ type: 'publish', moves, count }),
    progress: (kind, a, b) => { if ((a & 63) === 0) post({ type: 'progress', kind, a, b }); },
    searchStarted: (kind) => { searchStart = performance.now(); post({ type: 'searchStarted', kind }); },
  });
  const status = engine.create(resourcesPacket, dictionary);
  if (status) throw new Error('engine create failed: ' + status);
  const seed = (Math.floor(Math.random() * 0x7ffffffe) + 1) >>> 0;
  engine.setSeeds(seed, (Date.now() & 0x7fffffff) || 1);
  return { ok: true, dictionaryBytes: dictionary.length };
}

const handlers = {
  init,
  async setDictionary({ bytes }) {
    // Re-create the engine with a new dictionary. This is the equivalent of
    // relaunching Maven with a different data fork: search state restarts.
    const status = engine.create(resourcesPacket, bytes);
    if (status) throw new Error('dictionary rejected: ' + status);
    return { ok: true };
  },
  setLexicon({ mode }) { return engine.setLexicon(mode); },
  setLevel({ index, rating }) { engine.setLevel(index, rating); return { ok: true }; },
  levelReset() { engine.levelReset(); return { ok: true }; },
  move({ endgame, late, budget }) {
    if (cancelFlag) Atomics.store(cancelFlag, 0, 0);
    const status = engine.move(endgame ? 1 : 0, late ? 1 : 0, budget);
    return { status, ranking: status === 0 ? serializeRanking(engine.ranking()) : null, unseen: engine.unseen().tiles };
  },
  setPosition({ position }) { return engine.setPosition(position); },
  getPosition() { return engine.getPosition(); },
  deal({ firstSide }) { const s = engine.deal(firstSide); return { status: s, position: s === 0 ? engine.getPosition() : null }; },
  kibitz({ endgame, late, budget }) {
    if (cancelFlag) Atomics.store(cancelFlag, 0, 0);
    const status = engine.kibitz(endgame ? 1 : 0, late ? 1 : 0, budget);
    return { status, ranking: status === 0 ? serializeRanking(engine.ranking()) : null, unseen: engine.unseen().tiles };
  },
  playRanked({ index }) { const r = engine.playRanked(index); return { ...r, position: r.status === 0 ? engine.getPosition() : null, history: engine.historyCount() }; },
  playMove({ word, row, col, vertical, newTile, blank }) { const r = engine.playMove(word, row, col, vertical, newTile, blank); return { ...r, position: r.status === 0 ? engine.getPosition() : null, history: engine.historyCount() }; },
  playExchange({ tiles }) { const r = engine.playExchange(tiles); return { ...r, position: r.status === 0 ? engine.getPosition() : null, history: engine.historyCount() }; },
  wordAcceptable({ word }) { return engine.wordAcceptable(word); },
  wordsAcceptable({ words }) { return words.map(w => engine.wordAcceptable(w)); },
  wordList(q) { return engine.wordList(q); },
  save() { return engine.save(); },
  load({ wire }) { const s = engine.load(wire); return { status: s, position: s === 0 ? engine.getPosition() : null, history: engine.historyCount() }; },
  historySelect({ index }) { const s = engine.historySelect(index); return { status: s, position: s === 0 ? engine.getPosition() : null, history: engine.historyCount() }; },
  historyCount() { return engine.historyCount(); },
  statistics() { return engine.statistics(); },
  unseen() { return engine.unseen(); },
  letterValues() { return engine.letterValues(); },
  simulate(opts) {
    if (cancelFlag) Atomics.store(cancelFlag, 0, 0);
    const r = engine.simulate(opts);
    const out = { status: r.status };
    if (r.status === 0 || r.status === 6) {
      out.batches = r.batches; out.totalWeight = r.totalWeight; out.publications = r.publications; out.count = r.count; out.sessionStatus = r.sessionStatus;
      out.entries = decodeEntries(r.entries, r.count);
      out.ranking = serializeRanking(engine.ranking());
    }
    return out;
  },
  cgp({ cgp }) { return positionFromCGP(cgp); },
};

function serializeRanking(r) { return { count: r.count, kind: r.kind, cutoff: r.cutoff, moves: r.moves.map(m => ({ ...m, raw: Array.from(m.raw) })) }; }
function decodeEntries(bytes, count) {
  const v = new DataView(bytes.buffer, bytes.byteOffset, bytes.byteLength);
  const out = [];
  for (let i = 0; i < Math.min(count, 10); i++) {
    const o = i * 46; let word = ''; for (let k = 0; k < 16 && bytes[o + k]; k++) word += String.fromCharCode(bytes[o + k]);
    out.push({ word, score: v.getInt32(o + 16) / 100, total: v.getInt32(o + 34), samples: v.getInt32(o + 42), row: bytes[o + 32], col: bytes[o + 33] });
  }
  return out;
}

self.onmessage = async (ev) => {
  const { id, type, args } = ev.data;
  try {
    const h = handlers[type];
    if (!h) throw new Error('unknown request ' + type);
    const result = await h(args || {});
    post({ id, type, result });
  } catch (e) {
    post({ id, type, error: String(e && e.message || e) });
  }
};
