/* Shared engine host for Node tests and the browser worker: packs the
 * resource set, instantiates the application module with live callbacks and
 * exposes typed helpers over its bounded buffers. */
export const RESOURCE_FILES = ['DATA/0_0.bin', 'ZERO/0_0.bin', 'DREL/0_0.bin', 'prfs/0_0.bin', 'PATB/0_entries.bin',
  'ESTR/0_pattern_strings.bin', 'EXPR/0_full.bin', 'FRST/0_0.bin',
  ...Array.from('?abcdefghijklmnopqrstuvwxyz', c => `MUL${c}/0_0.bin`),
  ...Array.from('abcdefgh', c => `VCB${c}/0_0.bin`)];

export function packResources(blobs) {
  const total = 43 * 8 + blobs.reduce((n, b) => n + b.length, 0);
  const packet = new Uint8Array(total);
  const view = new DataView(packet.buffer);
  let offset = 43 * 8;
  blobs.forEach((b, i) => {
    view.setUint32(8 * i, offset);
    view.setUint32(8 * i + 4, b.length);
    packet.set(b, offset);
    offset += b.length;
  });
  return packet;
}

export const STATUS = ['OK', 'INVALID', 'ALLOCATION', 'NO_POSITION', 'DIAGNOSTIC', 'UNSUPPORTED', 'CANCELLED', 'EXTERNAL', 'CAPACITY'];
export const KINDS = ['heuristic', 'endgame', 'late'];

export class Engine {
  /** hooks: {ticks(), elapsedSeconds(), cancelRequested(), publish(moves,count), progress(kind,a,b), searchStarted(kind)} */
  static async instantiate(wasmBytes, hooks = {}) {
    const engine = new Engine();
    engine.hooks = hooks;
    engine.searchStart = 0;
    const imports = {
      env: {
        host_ticks: () => hooks.ticks ? hooks.ticks() >>> 0 : Math.floor(performance.now() * 60 / 1000) >>> 0,
        host_elapsed_seconds: () => hooks.elapsedSeconds ? hooks.elapsedSeconds() | 0 : Math.floor((performance.now() - engine.searchStart) / 1000) | 0,
        host_cancel_requested: () => hooks.cancelRequested ? (hooks.cancelRequested() ? 1 : 0) : 0,
        host_publish: (ptr, count) => { if (hooks.publish) hooks.publish(engine.bytes(ptr, count * 34).slice(), count); },
        host_progress: (kind, a, b) => { if (hooks.progress) hooks.progress(kind, a, b); },
        host_search_started: (kind) => { engine.searchStart = performance.now(); if (hooks.searchStarted) hooks.searchStarted(kind); },
      },
    };
    const { instance } = await WebAssembly.instantiate(wasmBytes, imports);
    engine.e = instance.exports;
    return engine;
  }
  bytes(ptr, n) { return new Uint8Array(this.e.memory.buffer, ptr, n); }
  buffer(id) { return this.bytes(this.e.app_buffer(id), this.e.app_capacity(id)); }
  write(id, data) { const b = this.buffer(id); if (data.length > b.length) throw new Error(`buffer ${id} overflow`); b.set(data); return data.length; }
  read(id, n) { return this.buffer(id).slice(0, n); }
  create(resources, dictionary) {
    this.write(0, resources); this.write(1, dictionary);
    const status = this.e.app_create(resources.length, dictionary.length);
    this.buffer(0).fill(0); this.buffer(1).fill(0);
    return status;
  }
  setLexicon(mode) { return this.e.app_set_lexicon(mode); }
  setSeeds(priv, toolbox) { this.e.app_set_seeds(priv >>> 0, toolbox >>> 0); }
  setPosition(p) { this.write(2, encodePosition(p)); return this.e.app_set_position(); }
  getPosition() { const s = this.e.app_get_position(); if (s) throw new Error('get_position ' + STATUS[s]); return decodePosition(this.read(2, 477)); }
  deal(firstSide) { return this.e.app_deal(firstSide); }
  kibitz(endgame = 1, late = 1, budget = 120) { return this.e.app_kibitz(endgame, late, budget); }
  setLevel(index, rating = 2100) { this.e.app_set_level(index, rating); }
  levelReset() { this.e.app_level_reset(); }
  move(endgame = 1, late = 1, budget = 120) { return this.e.app_move(endgame, late, budget); }
  searchHeuristic(dedup, offset = 0) { return this.e.app_search_heuristic(dedup ? 1 : 0, offset); }
  searchLate(force = 1) { return this.e.app_search_late(force); }
  searchEndgame(budget = 120) { return this.e.app_search_endgame(budget); }
  count(k) { return this.e.app_count(k) >>> 0; }
  ranking() { const n = this.count(0); const raw = this.read(3, 340); return { count: n, raw, moves: Array.from({ length: n }, (_, i) => decodeMove(raw.subarray(i * 34, i * 34 + 34))), kind: KINDS[this.count(1)], cutoff: this.count(2) };
  }
  playRanked(index) { const s = this.e.app_play_ranked(index); return { status: s, result: s === 0 ? decodePlay(this.read(7, 314)) : null }; }
  playMove(word, row, col, vertical, newTile, blank) {
    const b = new Uint8Array(64);
    for (let i = 0; i < word.length; i++) { b[i] = word.charCodeAt(i); b[16 + i] = newTile[i] ? 1 : 0; b[32 + i] = blank[i] ? 1 : 0; }
    b[48] = row; b[49] = col; b[50] = vertical ? 1 : 0;
    this.write(8, b);
    const s = this.e.app_play_move();
    return { status: s, result: s === 0 ? decodePlay(this.read(7, 314)) : null };
  }
  playExchange(tiles) {
    const b = new Uint8Array(64); for (let i = 0; i < tiles.length && i < 7; i++) b[i] = tiles.charCodeAt(i);
    this.write(8, b);
    const s = this.e.app_play_exchange();
    return { status: s, result: s === 0 ? decodePlay(this.read(7, 314)) : null };
  }
  save() { const s = this.e.app_save(); if (s) throw new Error('save ' + STATUS[s]); return this.read(4, this.count(6)); }
  load(wire) { this.write(4, wire); return this.e.app_load(wire.length); }
  historyCount() { return this.count(7); }
  historySelect(i) { return this.e.app_history_select(i); }
  statistics() { this.e.app_statistics(); const b = this.read(5, 176); const v = new DataView(b.buffer); return [0, 1].map(s => Array.from({ length: 22 }, (_, i) => v.getUint32((s * 22 + i) * 4))); }
  unseen() { const total = this.e.app_unseen(); const c = this.read(10, 128); let s = ''; for (let i = 0; i < 128; i++) s += String.fromCharCode(i).repeat(c[i]); return { total, counts: c, tiles: s }; }
  wordAcceptable(word) { const b = new Uint8Array(word.length + 1); for (let i = 0; i < word.length; i++) b[i] = word.charCodeAt(i); this.write(6, b); return this.e.app_word_acceptable() !== 0; }
  wordList({ rack = '', onBoard = '', prefix = '', suffix = '', bingos = false, min = 0, max = 0 }) {
    const enc = [rack, onBoard, prefix, suffix].map(s => s + '\0').join('');
    const b = new Uint8Array(enc.length); for (let i = 0; i < enc.length; i++) b[i] = enc.charCodeAt(i);
    this.write(6, b);
    const n = this.e.app_word_list(bingos ? 1 : 0, min, max);
    const text = new TextDecoder().decode(this.read(6, this.count(9)));
    return { count: n, words: text ? text.trimEnd().split('\n') : [] };
  }
  letterValues() { this.e.app_letter_values(); const b = this.read(6, 256); const values = {}, distribution = {}; for (let i = 0; i < 128; i++) { if (b[128 + i]) { values[String.fromCharCode(i)] = b[i]; distribution[String.fromCharCode(i)] = b[128 + i]; } } return { values, distribution }; }
  simulate({ lookahead = 1, exhaustive = false, late = true, endgame = true, sampleLimit = 100, budget = 120 }) {
    const flags = (exhaustive ? 1 : 0) | (late ? 2 : 0) | (endgame ? 4 : 0);
    const s = this.e.app_simulate(lookahead, flags, sampleLimit >>> 0, budget);
    if (s !== 0 && s !== 6) return { status: s };
    const b = this.read(9, 820); const v = new DataView(b.buffer);
    return { status: s, entries: b.subarray(0, 460), published: b.subarray(460, 800), batches: v.getUint32(800), totalWeight: v.getUint32(804), publications: v.getUint32(808), count: v.getUint32(812), sessionStatus: v.getUint32(816) };
  }
}

export function encodePosition(p) {
  const b = new Uint8Array(477); const v = new DataView(b.buffer);
  for (let i = 0; i < 225; i++) { const c = p.letters[i]; b[i] = c ? c.charCodeAt(0) : 0; b[225 + i] = p.blanks[i] ? 1 : 0; }
  for (let s = 0; s < 2; s++) for (let i = 0; i < p.racks[s].length && i < 7; i++) b[450 + 8 * s + i] = p.racks[s].charCodeAt(i);
  v.setUint32(466, (p.scores[0] * 100) >>> 0); v.setUint32(470, (p.scores[1] * 100) >>> 0);
  v.setUint16(474, p.zero || 0); b[476] = p.side || 0;
  return b;
}
export function decodePosition(b) {
  const v = new DataView(b.buffer, b.byteOffset, b.byteLength);
  const letters = [], blanks = [];
  for (let i = 0; i < 225; i++) { letters.push(b[i] ? String.fromCharCode(b[i]) : ''); blanks.push(b[225 + i]); }
  const rack = s => { let r = ''; for (let i = 0; i < 8 && b[450 + 8 * s + i]; i++) r += String.fromCharCode(b[450 + 8 * s + i]); return r; };
  return { letters, blanks, racks: [rack(0), rack(1)], scoreBits: [v.getUint32(466), v.getUint32(470)], scores: [v.getInt32(466) / 100, v.getInt32(470) / 100], zero: v.getUint16(474), side: b[476] };
}
export function decodeMove(raw) {
  const v = new DataView(raw.buffer, raw.byteOffset, raw.byteLength);
  let word = ''; for (let i = 0; i < 16 && raw[i]; i++) word += String.fromCharCode(raw[i]);
  const row = raw[32], col = raw[33];
  const score = v.getInt32(16), leave = v.getInt32(20), bonus = v.getInt32(24);
  const base = { word, score: score / 100, leave: leave / 100, bonus: bonus / 100, equity: ((score + leave + bonus) | 0) / 100, flags: v.getUint16(28), index: v.getUint16(30), raw: raw.slice() };
  if (!row) return { ...base, exchange: true, tiles: word };
  const vertical = row > 15;
  return { ...base, exchange: false, row: vertical ? col - 1 : row - 1, col: vertical ? row - 16 : col - 1, vertical };
}
export function decodePlay(b) {
  const v = new DataView(b.buffer, b.byteOffset, b.byteLength);
  return { move: decodeMove(b.subarray(0, 34)), features: Array.from({ length: 22 }, (_, i) => v.getUint32(34 + 4 * i)), statistics: [0, 1].map(s => Array.from({ length: 22 }, (_, i) => v.getUint32(122 + (s * 22 + i) * 4))), evaluationBits: v.getUint32(298), selectedSide: v.getUint32(302), phase: v.getUint32(306), historyRecords: v.getUint32(310) };
}
export function positionFromCGP(cgp) {
  const [rows, racks, scores, zero] = cgp.trim().split(/\s+/);
  const letters = [], blanks = [];
  for (const row of rows.split('/')) {
    let n = 0;
    for (const tok of row.match(/\d+|[A-Za-z]/g) || []) {
      if (/\d/.test(tok)) { for (let i = 0; i < +tok; i++) { letters.push(''); blanks.push(0); n++; } }
      else { letters.push(tok.toLowerCase()); blanks.push(tok === tok.toLowerCase() ? 1 : 0); n++; }
    }
    while (n++ < 15) { letters.push(''); blanks.push(0); }
  }
  const [r0, r1] = racks.split('/').map(r => r.toLowerCase());
  const [s0, s1] = scores.split('/').map(Number);
  return { letters, blanks, racks: [r0, r1], scores: [s0, s1], zero: +(zero || 0), side: 0 };
}
export function toCGP(p) {
  const rows = [];
  for (let r = 0; r < 15; r++) { let s = '', n = 0; for (let c = 0; c < 15; c++) { const ch = p.letters[r * 15 + c]; if (!ch) n++; else { if (n) s += n; n = 0; s += p.blanks[r * 15 + c] ? ch.toLowerCase() : ch.toUpperCase(); } } if (n) s += n; rows.push(s); }
  return `${rows.join('/')} ${p.racks[0].toUpperCase()}/${p.racks[1].toUpperCase()} ${p.scores[0]}/${p.scores[1]} ${p.zero || 0}`;
}
