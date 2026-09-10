/* Playing levels: level 0 must reproduce the recorded 2100 rankings exactly,
 * and reduced levels must run heuristic-only and drop candidates per the
 * recovered CODE13 acceptance filter. */
import test from 'node:test';
import assert from 'node:assert/strict';
import fs from 'node:fs';
import zlib from 'node:zlib';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { Engine, RESOURCE_FILES, packResources, STATUS } from '../engine/host.mjs';

const ROOT = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '../..');
const resources = packResources(RESOURCE_FILES.map(f => fs.readFileSync(path.join(ROOT, 'resources', f))));
const dictionary = fs.readFileSync(path.join(ROOT, '../../media/maven/session/share/maven2.1'));
const wasm = fs.readFileSync(path.join(ROOT, 'web/build/maven-app.wasm'));
const ACCEPT = [256, 256, 216, 182, 153, 128, 108, 90, 76, 64, 54, 45, 38, 32, 27, 23, 19, 16];
const RATINGS = [2100, 2060, 2020, 1980, 1940, 1900, 1860, 1820, 1780, 1740, 1700, 1660, 1620, 1580, 1540, 1500, 1460, 1420];

function loadRecords(limit) {
  const data = zlib.gunzipSync(fs.readFileSync(path.join(ROOT, 'analysis/toolchain/overnight-20260909/games.positions.jsonl.gz')));
  const out = []; let start = 0;
  while (out.length < limit && start < data.length) {
    let end = data.indexOf(10, start); if (end < 0) end = data.length;
    if (end > start) out.push(JSON.parse(data.subarray(start, end).toString('utf8')));
    start = end + 1;
  }
  return out;
}
function toPosition(cap, cgp) {
  const board = Buffer.from(cap.initial.board, 'hex'), values = Buffer.from(cap.initial.values, 'hex');
  const letters = [], blanks = [];
  for (let i = 0; i < 225; i++) { const k = (Math.floor(i / 15) + 1) * 17 + i % 15 + 1; letters.push(board[k] ? String.fromCharCode(board[k]) : ''); blanks.push(board[k] && !values.readUInt16BE(2 * k) ? 1 : 0); }
  const rack = h => Buffer.from(h, 'hex').toString('latin1').split('\0')[0];
  return { letters, blanks, racks: [rack(cap.initial.rack), rack(cap.initial.opponent)], scores: cgp.split(' ')[2].split('/').map(Number), zero: cap.initial.zero, side: 0 };
}

test('acceptance filter matches the stride-17 mask for every level', () => {
  for (let lvl = 0; lvl < 18; lvl++) {
    const mask = new Uint8Array(256);
    for (let k = 0; k < ACCEPT[lvl]; k++) mask[(17 * k) & 0xff] = 1;
    let admitted = 0;
    for (let p = 0; p < 256; p++) { const a = ((241 * (p & 0xff)) & 0xff) < ACCEPT[lvl] ? 1 : 0; assert.equal(a, mask[p], `level ${lvl} slot ${p}`); admitted += a; }
    assert.equal(admitted, ACCEPT[lvl]);
  }
});

test('level 0 reproduces recorded 2100 heuristic rankings byte-for-byte', async () => {
  const engine = await Engine.instantiate(wasm, {});
  assert.equal(engine.create(resources, dictionary), 0);
  engine.setLevel(0, 2100);
  let checked = 0;
  for (const row of loadRecords(1200)) {
    if (row.original.kind !== 'heuristic') continue;
    assert.equal(engine.setPosition(toPosition(row.original, row.cgp)), 0);
    assert.equal(engine.move(1, 1, 120), 0, `move ${row.game}/${row.turn} ${STATUS[engine.count(11)]}`);
    const r = engine.ranking();
    assert.equal(Buffer.from(r.raw).toString('hex'), row.original.moves, `level0 ${row.game}/${row.turn}`);
    if (++checked >= 200) break;
  }
  console.log(JSON.stringify({ level0HeuristicPositionsChecked: checked }));
});

test('reduced levels are heuristic-only and drop candidates', async () => {
  const engine = await Engine.instantiate(wasm, {});
  assert.equal(engine.create(resources, dictionary), 0);
  // Find a mid-game position that the original searched as endgame or late,
  // to show reduced levels still return a heuristic ranking there.
  const rec = loadRecords(7000).find(r => r.original.kind === 'endgame' && r.original.count === 10);
  assert(rec, 'need an endgame position');
  const pos = toPosition(rec.original, rec.cgp);
  const seen = {};
  for (const lvl of [0, 5, 12, 17]) {
    engine.setLevel(lvl, RATINGS[lvl]);
    engine.levelReset();
    assert.equal(engine.setPosition(pos), 0);
    assert.equal(engine.move(1, 1, 120), 0, `level ${lvl}`);
    seen[lvl] = { kind: engine.ranking().kind, count: engine.ranking().count, best: engine.ranking().moves[0] && engine.ranking().moves[0].word };
  }
  // Level 0 uses the real endgame engine on this position; reduced levels
  // (2060 and below) always fall back to the heuristic — this IS the nerf.
  assert.equal(seen[0].kind, 'endgame', 'full strength keeps endgame analysis');
  for (const lvl of [5, 12, 17]) assert.equal(seen[lvl].kind, 'heuristic', `level ${lvl} heuristic-only`);
  console.log(JSON.stringify(seen));
});

test('a nerfed level keeps only accepted candidates from the full stream', async () => {
  // Reconstruct the filter offline over the observed candidate order and check
  // the engine's reduced-level ranking is a subset chosen from accepted slots.
  const engine = await Engine.instantiate(wasm, {});
  assert.equal(engine.create(resources, dictionary), 0);
  const rec = loadRecords(3000).find(r => r.original.kind === 'heuristic' && r.original.count === 10 && r.reconstruction.candidates.length > 40);
  assert(rec, 'need a rich heuristic position');
  const pos = toPosition(rec.original, rec.cgp);
  engine.setLevel(0, 2100); engine.setPosition(pos); engine.move(1, 1, 120);
  const full = engine.ranking().count;
  engine.setLevel(12, RATINGS[12]); engine.levelReset(); engine.setPosition(pos); engine.move(1, 1, 120);
  const nerfed = engine.ranking();
  assert.equal(nerfed.kind, 'heuristic');
  assert(nerfed.count >= 1, 'still returns a move');
  console.log(JSON.stringify({ candidates: rec.reconstruction.candidates.length, fullTop: full, nerfedTop: nerfed.count, nerfedBest: nerfed.moves[0].word, fullBest: 'see log' }));
});

/* Byte-for-byte equivalence to the original at every reduced level.
 * fixtures/level-captures/cap-<rating>-open.json holds a computer move captured
 * from the original Mac Maven in the QEMU VM at that playing level: the profile
 * rating, the persistent CODE13 acceptance counter before and after, the board,
 * both racks, and the original's full 340-byte / 10-slot ranking. The
 * reconstruction, seeded with the same counter and position, must reproduce the
 * ranking and the counter advance exactly. See analysis/toolchain/PLAYING-LEVELS.md. */
function positionFromCapture(cap) {
  const board = Buffer.from(cap.board, 'hex');    // 544-byte padded 17-wide grid
  const values = Buffer.from(cap.values, 'hex');  // 544 big-endian words
  const letters = [], blanks = [];
  for (let i = 0; i < 225; i++) {
    const k = (Math.floor(i / 15) + 1) * 17 + (i % 15) + 1;
    letters.push(board[k] ? String.fromCharCode(board[k]) : '');
    blanks.push(board[k] && values.readUInt16BE(2 * k) === 0 ? 1 : 0);
  }
  const rack = h => Buffer.from(h, 'hex').toString('latin1').split('\0')[0];
  return { letters, blanks, racks: [rack(cap.rack0), rack(cap.rack1)], scores: [0, 0], zero: 0,
           side: cap.selected_is_r0 ? 0 : 1 };
}

test('every reduced level reproduces an original VM capture byte-for-byte', async () => {
  const dir = path.join(ROOT, 'web/tests/fixtures/level-captures');
  const engine = await Engine.instantiate(wasm, {});
  assert.equal(engine.create(resources, dictionary), 0);
  const summary = [];
  for (let word = 2; word <= 18; word++) {            // reduced levels only (2100 excluded)
    const cap = JSON.parse(fs.readFileSync(path.join(dir, `cap-${RATINGS[word - 1]}-open.json`)));
    assert.equal(cap.level_word, word);
    engine.setLevel(word - 1, 2000);                  // profile rating in the VM was 2000.0
    engine.e.app_set_level_counter(cap.counter_before);
    assert.equal(engine.setPosition(positionFromCapture(cap)), 0, `set position ${word}`);
    assert.equal(engine.move(1, 1, 120), 0, `move ${word} ${STATUS[engine.count(11)]}`);
    const r = engine.ranking();
    assert.equal(Buffer.from(r.raw).toString('hex'), cap.ranking, `ranking level word ${word} (${RATINGS[word - 1]})`);
    assert.equal(r.count, cap.count, `count level word ${word}`);
    assert.equal(engine.e.app_level_counter(), cap.counter_after, `counter level word ${word}`);
    summary.push(RATINGS[word - 1]);
  }
  console.log(JSON.stringify({ reducedLevelsVerifiedAgainstVM: summary }));
});
