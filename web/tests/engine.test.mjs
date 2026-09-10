/* Engine bridge acceptance: the browser module must reproduce the recorded
 * original rankings through its own Kibitz dispatch, and commit human moves
 * exactly as the original turn commit did. Run: node --test web/tests/ */
import test from 'node:test';
import assert from 'node:assert/strict';
import fs from 'node:fs';
import zlib from 'node:zlib';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { Engine, RESOURCE_FILES, packResources, positionFromCGP, STATUS } from '../engine/host.mjs';

const ROOT = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '../..');
const LOG = path.join(ROOT, 'analysis/toolchain/overnight-20260909/games.positions.jsonl.gz');
const DICT = path.join(ROOT, '../../media/maven/session/share/maven2.1');
const WASM = path.join(ROOT, 'web/build/maven-app.wasm');
const LIMIT = +(process.env.MAVEN_TEST_POSITIONS || 400);

const resources = packResources(RESOURCE_FILES.map(f => fs.readFileSync(path.join(ROOT, 'resources', f))));
const dictionary = fs.readFileSync(DICT);
const wasm = fs.readFileSync(WASM);

function loadRecords(limit) {
  const data = zlib.gunzipSync(fs.readFileSync(LOG));
  const out = [];
  let start = 0;
  while (out.length < limit && start < data.length) {
    let end = data.indexOf(10, start); if (end < 0) end = data.length;
    if (end > start) out.push(JSON.parse(data.subarray(start, end).toString('utf8')));
    start = end + 1;
  }
  return out;
}
function initialToPosition(initial, cgp) {
  const board = Buffer.from(initial.board, 'hex'), values = Buffer.from(initial.values, 'hex');
  const letters = [], blanks = [];
  for (let i = 0; i < 225; i++) { const k = (Math.floor(i / 15) + 1) * 17 + i % 15 + 1; letters.push(board[k] ? String.fromCharCode(board[k]) : ''); blanks.push(board[k] && !values.readUInt16BE(2 * k) ? 1 : 0); }
  const rack = h => Buffer.from(h, 'hex').toString('latin1').split('\0')[0];
  const scores = cgp.split(' ')[2].split('/').map(Number);
  return { letters, blanks, racks: [rack(initial.rack), rack(initial.opponent)], scores, zero: initial.zero, side: 0 };
}

test('recorded original rankings through app Kibitz dispatch', async () => {
  const clocks = { queue: [] };
  const engine = await Engine.instantiate(wasm, { elapsedSeconds: () => { if (!clocks.queue.length) throw new Error('clock exhausted'); return clocks.queue.shift(); } });
  assert.equal(engine.create(resources, dictionary), 0);
  const records = loadRecords(LIMIT);
  const kinds = {};
  let ranked = 0;
  for (const row of records) {
    const cap = row.original;
    assert.equal(engine.setPosition(initialToPosition(cap.initial, row.cgp)), 0, `set ${row.game}/${row.turn}`);
    if (cap.kind === 'endgame') {
      clocks.queue = cap.clocks.slice();
      // Kibitz seeds its endgame hash from the running private stream; the
      // recorded run used the seed captured from the original, so use it.
      engine.setSeeds(cap.seed, 1);
    }
    const status = engine.kibitz(1, 1, cap.budget || 120);
    assert.equal(status, 0, `kibitz ${row.game}/${row.turn} ${STATUS[status]}`);
    const r = engine.ranking();
    assert.equal(r.kind, cap.kind, `kind ${row.game}/${row.turn}`);
    assert.equal(r.count, cap.count, `count ${row.game}/${row.turn}`);
    assert.equal(Buffer.from(r.raw).toString('hex'), cap.moves, `moves ${row.game}/${row.turn} (${cap.kind})`);
    if (cap.kind === 'heuristic') assert.equal(r.cutoff, cap.cutoff >>> 0);
    if (cap.kind === 'endgame') assert.equal(clocks.queue.length, 0, 'all recorded clock reads consumed');
    kinds[cap.kind] = (kinds[cap.kind] || 0) + 1;
    ranked += cap.count;
    if (row.player === 'original_maven' && !('exchange' in row.chosen)) {
      const play = engine.playRanked(0);
      assert.equal(play.status, 0, `play ${row.game}/${row.turn}`);
    }
  }
  console.log(JSON.stringify({ positions: records.length, ranked, kinds }));
});

test('human move commit matches original BURIN capture', async () => {
  const turn = JSON.parse(fs.readFileSync(path.join(ROOT, 'analysis/toolchain/turn-commit-burin-fresh-live.json')));
  assert(turn.complete);
  const events = [];
  for (const f of turn.turn.refills) for (const ev of f.events) if (ev.kind !== 'private_random') events.push(ev);
  const ticks = events.filter(e => e.kind === 'ticks').map(e => e.value);
  const randoms = events.filter(e => e.kind !== 'ticks').map(e => e.value);
  // Feed the original's tick readings; Toolbox Random values cannot be
  // injected through the live bridge, so racks after refill will differ.
  const engine = await Engine.instantiate(wasm, { ticks: () => ticks.length ? ticks.shift() : 0 });
  assert.equal(engine.create(resources, dictionary), 0);
  const init = turn.turn.initial;
  const board = Buffer.from(init.board, 'hex'), values = Buffer.from(init.values, 'hex');
  const letters = [], blanks = [];
  for (let i = 0; i < 225; i++) { const k = (Math.floor(i / 15) + 1) * 17 + i % 15 + 1; letters.push(board[k] ? String.fromCharCode(board[k]) : ''); blanks.push(board[k] && !values.readUInt16BE(2 * k) ? 1 : 0); }
  const rack = h => Buffer.from(h, 'hex').toString('latin1').split('\0')[0];
  const pos = { letters, blanks, racks: [rack(init.rack0), rack(init.rack1)], scores: [init.totals[0] / 100, init.totals[1] / 100], zero: init.row_zero_count, side: 0 };
  assert.equal(engine.setPosition(pos), 0);
  engine.setSeeds(turn.turn.refills[0].private_seed, 1);
  const move = Buffer.from(turn.move, 'hex');
  const word = move.subarray(0, 16).toString('latin1').split('\0')[0];
  const vertical = move[32] > 15, row = vertical ? move[33] - 1 : move[32] - 1, col = vertical ? move[32] - 16 : move[33] - 1;
  const newTile = [], blank = [];
  for (let i = 0; i < word.length; i++) { const r = row + (vertical ? i : 0), c = col + (vertical ? 0 : i); newTile.push(!letters[r * 15 + c]); blank.push(false); }
  const play = engine.playMove(word, row, col, vertical, newTile, blank);
  assert.equal(play.status, 0, STATUS[play.status]);
  assert.equal(Buffer.from(play.result.move.raw).toString('hex'), turn.move, 'record including CODE8 display score');
  assert.deepEqual(play.result.features, turn.turn.final.features);
  assert.equal(play.result.evaluationBits, turn.result_bits >>> 0);
  const after = engine.getPosition();
  const fb = Buffer.from(turn.turn.final.board, 'hex');
  for (let i = 0; i < 225; i++) { const k = (Math.floor(i / 15) + 1) * 17 + i % 15 + 1; assert.equal(after.letters[i], fb[k] ? String.fromCharCode(fb[k]) : '', `board ${i}`); }
  assert.deepEqual(after.scoreBits, turn.turn.final.totals);
  assert.equal(after.side, 1);
  console.log(JSON.stringify({ word, row, col, vertical, score: play.result.move.score, randomsInOriginal: randoms.length }));
});

test('deal, exchange, pass, word checks, lexicon, save/load round trip', async () => {
  const engine = await Engine.instantiate(wasm, {});
  assert.equal(engine.create(resources, dictionary), 0);
  engine.setSeeds(12345, 6789);
  assert.equal(engine.deal(0), 0);
  const p = engine.getPosition();
  assert.equal(p.racks[0].length, 7); assert.equal(p.racks[1].length, 7); assert.equal(p.side, 0);
  assert.equal(engine.unseen().total, 100 - 7);
  assert(engine.wordAcceptable('aa')); assert(!engine.wordAcceptable('zzzz'));
  assert(engine.wordAcceptable('quizzify'), 'section 2 word visible with both lexica');
  assert.equal(engine.setLexicon(0), 0); assert(!engine.wordAcceptable('quizzify'), 'North American only');
  assert.equal(engine.setLexicon(2), 0); assert(engine.wordAcceptable('quizzify'));
  const ex = engine.playExchange(p.racks[0].slice(0, 3));
  assert.equal(ex.status, 0, STATUS[ex.status]);
  const q = engine.getPosition();
  assert.equal(q.side, 1); assert.equal(q.racks[0].length, 7); assert.equal(q.zero, 1);
  const pass = engine.playExchange('');
  assert.equal(pass.status, 0);
  assert.equal(engine.getPosition().zero, 2);
  assert.equal(engine.getPosition().side, 0);
  assert.equal(engine.kibitz(), 0);
  const r = engine.ranking();
  assert(r.count > 0);
  const play = engine.playRanked(0);
  assert.equal(play.status, 0);
  const wire = engine.save();
  assert(wire.length > 300);
  const before = engine.getPosition();
  assert.equal(engine.load(wire), 0);
  const after = engine.getPosition();
  assert.deepEqual(after.letters, before.letters);
  assert.equal(engine.historyCount() > 0, true);
  const list = engine.wordList({ rack: 'retains', min: 7, max: 7 });
  assert(list.words.includes('retains') || list.words.includes('nastier'), JSON.stringify(list).slice(0, 200));
  console.log(JSON.stringify({ dealt: p.racks, afterExchange: q.racks[0], kibitz: r.moves[0], history: engine.historyCount(), sevens: list.count }));
});
