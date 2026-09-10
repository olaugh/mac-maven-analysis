// Tests for web/gcg.js. Run with:  node --test web/tests/
import { test, describe } from 'node:test';
import assert from 'node:assert/strict';
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

import {
  parseGCG, positionAfter, positionBefore, toCGP, parseCGP,
  gcgSourceFromUrl, fetchGCG, crossTablesGcgUrl, TILE_DISTRIBUTION, tileCounts,
  parseCoordinate, formatCoordinate, GCGError,
} from '../gcg.js';

const here = path.dirname(fileURLToPath(import.meta.url));
const fixture = (name) => fs.readFileSync(path.join(here, 'fixtures', name), 'utf8');

// Fixtures:
//   full_game.gcg           - every event type (exchange, phony + withdrawal, pass, challenge
//                             bonus, blanks, end bonus, time penalty, notes, #rack2)
//   woogles_style.gcg       - Macondo/woogles pragmas, blank, exchange by count, six-pass ending
//   crosstables_style.gcg   - CRLF, trailing whitespace, unknown pragmas, HTML entities in notes,
//                             only player 1's racks recorded, plays written through existing letters
//   woogles_GfiCzf6rn6.gcg  - real game fetched from https://woogles.io/game/GfiCzf6rn6 via
//                             POST https://woogles.io/api/game_service.GameMetadataService/GetGCG
const FIXTURES = ['full_game.gcg', 'woogles_style.gcg', 'crosstables_style.gcg', 'woogles_GfiCzf6rn6.gcg'];

const sq = (row, col) => row * 15 + col;
const idx = (coord) => { const c = parseCoordinate(coord); return sq(c.row, c.col); };

function boardCounts(pos) {
  const counts = {};
  for (let i = 0; i < 225; i++) {
    if (!pos.board[i]) continue;
    const k = pos.blanks[i] ? '?' : pos.board[i];
    counts[k] = (counts[k] || 0) + 1;
  }
  return counts;
}

// ---------------------------------------------------------------------------
describe('invariants on every fixture', () => {
  for (const name of FIXTURES) {
    const game = parseGCG(fixture(name));

    test(`${name}: parses without warnings and one turn per event`, () => {
      assert.deepEqual(game.warnings, []);
      assert.equal(game.turns.length, game.events.length);
      assert.ok(game.turns.length > 0);
    });

    test(`${name}: cumulative score matches the TOTAL field on every event`, () => {
      game.turns.forEach((t, i) => {
        assert.equal(t.cumulative[t.player], game.events[i].total, `turn ${i}`);
        // the other player's total is unchanged by this event
        if (i > 0) assert.equal(t.cumulative[1 - t.player], game.turns[i - 1].cumulative[1 - t.player], `turn ${i} opp`);
      });
    });

    test(`${name}: tile inventory never goes negative (board + mover rack <= distribution)`, () => {
      for (let i = -1; i < game.turns.length; i++) {
        for (const pos of [positionAfter(game, i), i >= 0 ? positionBefore(game, i) : null]) {
          if (!pos) continue;
          for (const [k, n] of Object.entries(pos.unseenCounts)) {
            assert.ok(n >= 0, `turn ${i}: ${k} count ${n}`);
          }
          // and counting both racks when known
          const counts = { ...TILE_DISTRIBUTION };
          for (const [k, n] of Object.entries(boardCounts(pos))) counts[k] -= n;
          for (const r of pos.racks) for (const [k, n] of Object.entries(tileCounts(r))) counts[k] -= n;
          for (const [k, n] of Object.entries(counts)) assert.ok(n >= 0, `turn ${i}: ${k} over-used (${n})`);
          assert.ok(pos.bagCount >= 0);
          assert.equal(pos.unseen, [...pos.unseen].sort((a, b) => (a === '?') - (b === '?') || a.localeCompare(b)).join(''));
        }
      }
    });

    test(`${name}: board letters after each play match the word; withdrawals restore the board`, () => {
      game.turns.forEach((t, i) => {
        const pos = positionAfter(game, i);
        if (t.type === 'play') {
          assert.equal(t.word.length, game.events[i].wordAsWritten.length);
          assert.ok(!t.word.includes('.'), 'word fully expanded');
          let r = t.row, c = t.col;
          for (const ch of t.word) {
            assert.equal(pos.board[sq(r, c)], ch.toLowerCase(), `turn ${i} square ${formatCoordinate(r, c, false)}`);
            assert.equal(pos.blanks[sq(r, c)], ch === ch.toLowerCase() ? 1 : 0, `turn ${i} blank flag at ${formatCoordinate(r, c, false)}`);
            if (t.vertical) r++; else c++;
          }
          // tiles played are a subset of the rack (when the rack is known)
          if (t.rack && !t.rack.includes('_')) {
            const rack = tileCounts(t.rack);
            for (const [k, n] of Object.entries(tileCounts(t.tilesPlayed.replace(/[a-z]/g, '?')))) {
              assert.ok((rack[k] || 0) >= n, `turn ${i}: played ${k} not in rack ${t.rack}`);
            }
          }
        } else if (t.type === 'lost_challenge') {
          const before = positionAfter(game, t.withdraws - 1);
          assert.deepEqual(pos.board, before.board, `turn ${i}: board restored`);
          assert.deepEqual([...pos.blanks], [...before.blanks]);
          assert.deepEqual(pos.scores, before.scores, `turn ${i}: scores restored`);
          assert.equal(game.turns[t.withdraws].withdrawnBy, i);
        } else {
          // non-play events never touch the board
          assert.deepEqual(pos.board, positionAfter(game, i - 1).board);
        }
      });
    });

    test(`${name}: CGP round-trips`, () => {
      for (let i = -1; i < game.turns.length; i++) {
        const pos = positionAfter(game, i);
        const cgp = toCGP(pos);
        const back = parseCGP(cgp);
        assert.equal(toCGP(back), cgp);
        assert.deepEqual(back.board, pos.board);
        assert.deepEqual([...back.blanks], [...pos.blanks]);
        assert.equal(back.racks[0], pos.racks[pos.side].replace(/_/g, ''));
        assert.equal(back.racks[1], pos.racks[1 - pos.side].replace(/_/g, ''));
        assert.deepEqual(back.scores, [pos.scores[pos.side], pos.scores[1 - pos.side]]);
        assert.equal(back.zeroTurns, pos.zeroTurns);
        const rows = cgp.split(' ')[0].split('/');
        assert.equal(rows.length, 15);
        for (const row of rows) {
          let n = 0;
          for (const m of row.matchAll(/\d+|[A-Za-z]/g)) n += /\d/.test(m[0]) ? parseInt(m[0], 10) : 1;
          assert.equal(n, 15, `row ${row}`);
        }
      }
    });
  }
});

// ---------------------------------------------------------------------------
describe('full_game.gcg', () => {
  const game = parseGCG(fixture('full_game.gcg'));

  test('header pragmas', () => {
    assert.deepEqual(game.players, [{ nick: 'Alice', name: 'Alice Anderson' }, { nick: 'Bob', name: 'Bob Brown' }]);
    assert.equal(game.lexicon, 'NWL2023');
    assert.equal(game.title, 'Fixture: full game');
    assert.equal(game.characterEncoding, 'UTF-8');
  });

  test('event types in order', () => {
    assert.deepEqual(game.turns.slice(0, 10).map((t) => t.type), [
      'exchange', 'play', 'play', 'lost_challenge', 'pass', 'play', 'play', 'play', 'play', 'challenge_bonus',
    ]);
    assert.deepEqual(game.turns.slice(-3).map((t) => t.type), ['play', 'end_bonus', 'time_penalty']);
    assert.equal(game.turns[0].exchanged, 'RU');
    assert.equal(game.turns[0].exchangeCount, 2);
  });

  test('notes attach to the preceding event', () => {
    assert.equal(game.turns[0].note, 'Alice opens with an exchange of RU.');
    assert.equal(game.turns[2].note, 'Phony! AEROLIS* is not a word.');
    assert.equal(game.turns[3].note, 'Bob challenges and the play comes off.');
    assert.equal(game.turns[1].note, '');
    assert.equal(game.notes.length, 6);
    assert.equal(game.notes[0].event, 0);
  });

  test('first play: CLANK at 8H', () => {
    const t = game.turns[1];
    assert.equal(t.player, 1);
    assert.deepEqual([t.row, t.col, t.vertical], [7, 7, false]);
    assert.equal(t.word, 'CLANK');
    assert.equal(t.tilesPlayed, 'CLANK');
    assert.equal(t.leave, 'nw');
    const pos = positionAfter(game, 1);
    assert.deepEqual('HIJKL'.split('').map((col) => pos.board[idx(`8${col}`)]), ['c', 'l', 'a', 'n', 'k']);
    assert.equal(pos.board.filter(Boolean).length, 5);
    assert.deepEqual(pos.scores, [0, 32]);
    assert.equal(pos.side, 0);
    // racks: the mover's rack from her next line, Bob's from his next line
    assert.deepEqual(pos.racks, ['aeilors', 'aeffnww']);
    assert.equal(pos.bagCount, 100 - 5 - 7 - 7);
    assert.equal(toCGP(pos), '15/15/15/15/15/15/15/7CLANK3/15/15/15/15/15/15/15 AEILORS/AEFFNWW 0/32 0');
  });

  test('phony is placed then withdrawn by the lost challenge', () => {
    const phony = game.turns[2];
    assert.equal(phony.word, 'AEROLIS');
    assert.equal(phony.withdrawnBy, 3);
    let pos = positionAfter(game, 2);
    assert.equal(pos.board[idx('9G')], 'a');
    assert.equal(pos.board[idx('9M')], 's');
    assert.deepEqual(pos.scores, [71, 32]);
    assert.equal(pos.racks[0], '', 'at this instant Alice holds only her (empty) leave');

    const undo = game.turns[3];
    assert.equal(undo.type, 'lost_challenge');
    assert.equal(undo.withdraws, 2);
    assert.equal(undo.score, -71);
    pos = positionAfter(game, 3);
    assert.equal(pos.board[idx('9G')], '');
    assert.equal(pos.board[idx('9M')], '');
    assert.deepEqual(pos.board, positionAfter(game, 1).board);
    assert.deepEqual(pos.scores, [0, 32]);
    assert.equal(pos.side, 1, 'Bob moves after the phony is withdrawn');
    assert.equal(pos.racks[0], 'aeilors', 'tiles return to the rack');
    assert.equal(pos.zeroTurns, 1, 'a phony challenged off is one scoreless turn');
    assert.equal(positionAfter(game, 4).zeroTurns, 2, 'pass');
    assert.equal(positionAfter(game, 5).zeroTurns, 0, 'scoring play resets');
    assert.equal(positionAfter(game, 0).zeroTurns, 1, 'exchange');
  });

  test('ALIENORS plays through the N of CLANK', () => {
    const t = game.turns[5];
    assert.equal(t.word, 'ALIENORS');
    assert.equal(t.tilesPlayed, 'ALIEORS');
    assert.equal(t.vertical, true);
    assert.deepEqual([t.row, t.col], [3, 10]);
    assert.equal(t.leave, '');
  });

  test('challenge bonus adds 5 to the challenged player', () => {
    const t = game.turns[9];
    assert.equal(t.type, 'challenge_bonus');
    assert.equal(t.player, 1);
    assert.equal(t.score, 5);
    assert.equal(t.rack, '?EFI');
    assert.deepEqual(t.cumulative, [156, 99]);
    assert.deepEqual(positionAfter(game, 9).board, positionAfter(game, 8).board);
    assert.equal(positionAfter(game, 9).side, 0);
  });

  test('blanks are lowercase in the word and flagged on the board', () => {
    const t = game.turns[11];
    assert.equal(t.word, 'bEFINNED');
    assert.equal(t.tilesPlayed, 'bEFINNE');
    assert.equal(t.leave, '');
    const pos = positionAfter(game, 11);
    assert.equal(pos.board[idx('15A')], 'b');
    assert.equal(pos.blanks[idx('15A')], 1);
    assert.equal(pos.blanks[idx('15B')], 0);
    assert.equal(pos.board[idx('15H')], 'd');

    const th = game.turns[23];
    assert.equal(th.word, 'ThIOTEPA');
    assert.equal(th.tilesPlayed, 'ThIOTEA');
    const pos2 = positionAfter(game, 23);
    assert.equal(pos2.blanks[idx('F6')], 1);
    assert.equal(pos2.board[idx('F6')], 'h');
    assert.equal(pos2.blanks[idx('F5')], 0);
    // Both blanks now on the board
    assert.equal([...pos2.blanks].reduce((a, b) => a + b, 0), 2);
    assert.equal(pos2.unseenCounts['?'], 0);
    assert.ok(toCGP(pos2).includes('bEFINNED'));
    assert.ok(toCGP(pos2).split('/')[5].includes('h'));
  });

  test('end-of-game bonus, time penalty and final scores', () => {
    const bonus = game.turns[29];
    assert.equal(bonus.type, 'end_bonus');
    assert.equal(bonus.player, 0);
    assert.equal(bonus.tiles, 'IU');
    assert.equal(bonus.rack, '');
    const time = game.turns[30];
    assert.equal(time.type, 'time_penalty');
    assert.equal(time.score, -10);
    assert.deepEqual(game.finalScores, [427, 500]);
    assert.deepEqual(game.finalRacks, ['', 'IU']);

    const end = positionAfter(game, 30);
    assert.deepEqual(end.racks, ['', 'iu']);
    assert.equal(end.unseen, '');
    assert.equal(end.bagCount, 0);
    assert.deepEqual(end.scores, [427, 500]);
    assert.equal(end.board.filter(Boolean).length, 98);
  });

  test('position before the final play', () => {
    const pos = positionBefore(game, 28);
    assert.equal(pos.side, 0);
    assert.deepEqual(pos.racks, ['eelr', 'iu']);
    assert.equal(pos.unseen, 'iu');
    assert.equal(pos.bagCount, 0);
    assert.deepEqual(pos.scores, [413, 510]);
    assert.equal(pos.rackKnown[0], true);
    assert.equal(pos.note, undefined);
    const cgp = toCGP(pos, { lexicon: 'NWL2023' });
    assert.ok(cgp.endsWith(' EELR/IU 413/510 0 lex NWL2023;'), cgp);
    assert.equal(parseCGP(cgp).opcodes.lex, 'NWL2023');
  });

  test('positionBefore(i) equals positionAfter(i-1) for move events', () => {
    for (let i = 1; i < game.turns.length; i++) {
      const a = positionAfter(game, i - 1);
      const b = positionBefore(game, i);
      assert.deepEqual(a.board, b.board);
      assert.deepEqual(a.scores, b.scores);
      if (['play', 'exchange', 'pass'].includes(game.turns[i].type)) {
        assert.equal(b.side, game.turns[i].player);
        assert.equal(b.racks[b.side], game.turns[i].rack.toLowerCase());
      }
    }
  });

  test('starting position', () => {
    const pos = positionAfter(game, -1);
    assert.equal(pos.board.filter(Boolean).length, 0);
    assert.equal(pos.side, 0);
    assert.equal(pos.racks[0], 'aelrrsu');
    assert.equal(pos.unseen.length, 93);
    assert.equal(pos.bagCount, 86);
    assert.deepEqual(pos.scores, [0, 0]);
  });
});

// ---------------------------------------------------------------------------
describe('woogles_style.gcg', () => {
  const game = parseGCG(fixture('woogles_style.gcg'));

  test('pragmas', () => {
    assert.equal(game.id, 'io.woogles fixtureSixPass');
    assert.equal(game.lexicon, 'NWL23');
    assert.equal(game.description, 'Created with Macondo');
    assert.deepEqual(game.pragmas['game-type'], ['classic']);
    assert.deepEqual(game.players.map((p) => p.nick), ['alpha', 'beta']);
  });

  test('blank played through an existing tile', () => {
    const t = game.turns[1];
    assert.equal(t.word, 'sODA');
    assert.equal(t.tilesPlayed, 'sOA');
    assert.equal(t.vertical, true);
    const pos = positionAfter(game, 1);
    assert.equal(pos.blanks[idx('J6')], 1);
    assert.equal(pos.board[idx('J6')], 's');
    assert.equal(pos.board[idx('J8')], 'd');
    assert.equal(pos.blanks[idx('J8')], 0);
  });

  test('two-letter play written as "H."', () => {
    const t = game.turns[2];
    assert.equal(t.word, 'HA');
    assert.equal(t.tilesPlayed, 'H');
    assert.equal(t.leave, 'aceikl');
  });

  test('exchange by count', () => {
    const t = game.turns[4];
    assert.equal(t.type, 'exchange');
    assert.equal(t.exchangeCount, 3);
    assert.equal(t.exchanged, '');
  });

  test('six scoreless turns then rack penalties', () => {
    assert.equal(game.turns[8].zeroTurns, 6);
    assert.equal(game.turns[9].type, 'end_penalty');
    assert.equal(game.turns[9].tiles, 'AELNRST');
    assert.equal(game.turns[10].type, 'end_penalty');
    assert.deepEqual(game.finalScores, [83, 3]);
    assert.deepEqual(game.finalRacks, ['AELNRST', 'ABIMSNT']);
    const end = positionAfter(game, 10);
    assert.deepEqual(end.racks, ['aelnrst', 'abimsnt']);
    assert.equal(end.zeroTurns, 6);
    assert.equal(end.board.filter(Boolean).length, 11); // GROUTED + sOA + H
    assert.equal(end.bagCount, 100 - 11 - 14);
    assert.equal(toCGP(end), '15/15/15/15/15/9s5/9O5/3GROUTED5/8HA5/15/15/15/15/15/15 ABIMSNT/AELNRST 3/83 6');
  });

  test('notes', () => {
    assert.equal(game.turns[0].note, 'Only bingo available.');
    assert.equal(game.turns[8].note, 'Six consecutive scoreless turns end the game.');
  });
});

// ---------------------------------------------------------------------------
describe('crosstables_style.gcg', () => {
  const text = fixture('crosstables_style.gcg');
  const game = parseGCG(text);

  test('CRLF, trailing whitespace and unknown pragmas are tolerated', () => {
    assert.ok(text.includes('\r\n'));
    assert.deepEqual(game.players, [{ nick: 'Nigel', name: 'Nigel Richards' }, { nick: 'Dave', name: 'Dave Wiegand' }]);
    assert.deepEqual(game.pragmas.style, ['classic']);
    assert.ok(game.pragmas.htarget[0].startsWith('http://'));
    assert.equal(game.lexicon, 'TWL06');
    assert.equal(game.turns.length, 7);
  });

  test('notes keep HTML entities verbatim', () => {
    assert.equal(game.turns[0].note, 'Only 102: the &ldquo;Z&rdquo; is on a double letter square.');
    assert.equal(game.turns[2].note, 'Nigel keeps EGILM &mdash; a strong leave.');
    assert.equal(game.turns[4].note, 'Challenged off.');
  });

  test('plays written through existing letters without dots', () => {
    const zoa = game.turns[1];
    assert.equal(zoa.rack, '');
    assert.equal(zoa.word, 'ZOA');
    assert.equal(zoa.tilesPlayed, 'OA');
    assert.equal(zoa.vertical, true);
    const had = game.turns[2];
    assert.equal(had.word, 'HAD');
    assert.equal(had.tilesPlayed, 'HD');
    assert.equal(had.leave, 'egilm');
    const mos = game.turns[5];
    assert.equal(mos.word, 'MOS');
    assert.equal(mos.tilesPlayed, 'MO');
  });

  test('opponent racks are unknown', () => {
    const before = positionBefore(game, 1);
    assert.equal(before.side, 1);
    assert.equal(before.racks[1], '');
    assert.equal(before.rackKnown[1], false);
    assert.match(before.note, /not recorded/);
    // unseen pool then excludes only the board
    assert.equal(before.unseen.length, 100 - 7);
    assert.equal(before.bagCount, 100 - 7 - 7);
    // Nigel's rack is known before his own turns
    const b2 = positionBefore(game, 2);
    assert.equal(b2.racks[0], 'deghilm');
    assert.equal(b2.note, undefined);
  });

  test('lost challenge and exchange with empty rack field', () => {
    assert.equal(game.turns[3].type, 'play');
    assert.equal(game.turns[3].word, 'QUAX');
    assert.equal(game.turns[4].type, 'lost_challenge');
    assert.equal(game.turns[4].withdraws, 3);
    assert.deepEqual(game.turns[4].cumulative, [109, 12]);
    assert.equal(positionAfter(game, 4).board[idx('11B')], '');
    assert.equal(game.turns[6].type, 'exchange');
    assert.equal(game.turns[6].exchangeCount, 4);
  });

  test('#rack1 pragma after the last event gives the final rack', () => {
    assert.equal(game.finalRacks[0], 'EGILPRU');
    const end = positionAfter(game, 6);
    assert.equal(end.side, 0);
    assert.deepEqual(end.racks, ['egilpru', '']);
    assert.equal(toCGP(end), '15/15/15/15/15/8M6/8O6/3ZANIEST5/3O11/2HAD10/15/15/15/15/15 EGILPRU/ 115/12 1');
  });
});

// ---------------------------------------------------------------------------
describe('real woogles game GfiCzf6rn6', () => {
  const game = parseGCG(fixture('woogles_GfiCzf6rn6.gcg'));
  test('summary', () => {
    assert.equal(game.id, 'io.woogles GfiCzf6rn6');
    assert.equal(game.lexicon, 'CSW24');
    assert.deepEqual(game.players.map((p) => p.nick), ['Inverse', 'HastyBot']);
    assert.equal(game.turns.length, 26);
    assert.deepEqual(game.finalScores, [427, 505]);
    assert.equal(game.turns[25].type, 'end_bonus');
    assert.equal(game.turns[0].type, 'exchange');
    const end = positionAfter(game, 25);
    assert.equal(end.unseen, '');
    assert.deepEqual(end.racks, ['', 'iu']);
    assert.equal(end.board.filter(Boolean).length, 98);
  });
});

// ---------------------------------------------------------------------------
describe('parser edge cases and errors', () => {
  test('nick with spaces, players inferred without #player pragmas, bare scores', () => {
    const g = parseGCG('>Jane Doe: AEINRST 8H RETAINS +66 66\n>Bob: A - 0 0\n');
    assert.deepEqual(g.players.map((p) => p.nick), ['Jane Doe', 'Bob']);
    assert.equal(g.turns[1].type, 'pass');
  });

  test('BOM and blank lines', () => {
    const g = parseGCG('﻿#player1 a A\n\n#player2 b B\r\n>a: AB 8H AB +6 6\r\n');
    assert.equal(g.turns.length, 1);
    assert.equal(g.players[0].name, 'A');
  });

  test('unknown tiles "_" in racks', () => {
    const g = parseGCG('>a: AB_____ 8H AB +6 6\n>b: CD_____ -CD +0 0\n');
    assert.deepEqual(g.warnings, []);
    const pos = positionAfter(g, 0);
    assert.equal(pos.racks[1], 'cd_____');
    assert.equal(toCGP(pos).split(' ')[1], 'CD/');
  });

  test('cumulative mismatch is reported and the recorded total wins', () => {
    const g = parseGCG('>a: AB 8H AB +6 7\n');
    assert.equal(g.warnings.length, 1);
    assert.deepEqual(g.turns[0].cumulative, [7, 0]);
  });

  test('"." on an empty square is an error', () => {
    assert.throws(() => parseGCG('>a: AB 8H .B +6 6\n'), GCGError);
  });

  test('conflicting letter on an occupied square is an error', () => {
    assert.throws(() => parseGCG('>a: AB 8H AB +6 6\n>b: CD 8H CD +6 6\n'), /holds A, not C/);
  });

  test('running off the board is an error', () => {
    assert.throws(() => parseGCG('>a: ABCDEFG 8N ABCDEFG +6 6\n'), /runs off/);
  });

  test('withdrawal without a play is an error', () => {
    assert.throws(() => parseGCG('>a: AB -- -6 0\n'), /without a preceding play/);
  });

  test('coordinates', () => {
    assert.deepEqual(parseCoordinate('8D'), { row: 7, col: 3, vertical: false });
    assert.deepEqual(parseCoordinate('D8'), { row: 7, col: 3, vertical: true });
    assert.deepEqual(parseCoordinate('15o'), { row: 14, col: 14, vertical: false });
    assert.equal(parseCoordinate('16A'), null);
    assert.equal(parseCoordinate('P8'), null);
    assert.equal(formatCoordinate(7, 3, true), 'D8');
  });
});

// ---------------------------------------------------------------------------
describe('CGP', () => {
  test('parseCGP of a known position', () => {
    const cgp = '15/15/15/15/15/15/15/7CLANK3/15/15/15/15/15/15/15 AEILORS/AEFFNWW 0/32 0 lex CSW24;';
    const pos = parseCGP(cgp);
    assert.equal(pos.board[idx('8H')], 'c');
    assert.equal(pos.board[idx('8L')], 'k');
    assert.deepEqual(pos.racks, ['aeilors', 'aeffnww']);
    assert.deepEqual(pos.scores, [0, 32]);
    assert.equal(pos.side, 0);
    assert.equal(pos.zeroTurns, 0);
    assert.equal(pos.opcodes.lex, 'CSW24');
    assert.equal(pos.unseen.length, 100 - 5 - 7);
    assert.equal(pos.bagCount, 100 - 5 - 7 - 7);
    assert.equal(toCGP(pos), cgp);
  });

  test('blanks and multi-digit runs', () => {
    const pos = parseCGP('15/15/15/15/15/15/15/3QUIz8/15/15/15/15/15/15/15 ?/ 12/0 0');
    assert.equal(pos.board[idx('8G')], 'z');
    assert.equal(pos.blanks[idx('8G')], 1);
    assert.equal(pos.blanks[idx('8F')], 0);
    assert.equal(pos.racks[0], '?');
    assert.equal(pos.unseenCounts['?'], 0);
  });

  test('bad CGP is rejected', () => {
    assert.throws(() => parseCGP('15/15 A/B 0/0 0'), /rows/);
    assert.throws(() => parseCGP('15/15/15/15/15/15/15/16/15/15/15/15/15/15/15 A/B 0/0 0'), /squares/);
    assert.throws(() => parseCGP('hello'));
  });
});

// ---------------------------------------------------------------------------
describe('URL classifier', () => {
  test('cross-tables', () => {
    const s = gcgSourceFromUrl('https://www.cross-tables.com/annotated.php?u=47880');
    assert.equal(s.kind, 'crosstables');
    assert.equal(s.id, '47880');
    assert.equal(s.gcgUrl, 'https://www.cross-tables.com/annotated/selfgcg/478/anno47880.gcg');
    assert.equal(s.method, 'GET');
    assert.equal(gcgSourceFromUrl('47880').gcgUrl, s.gcgUrl);
    assert.equal(gcgSourceFromUrl(' 47880 ').id, '47880');
    assert.equal(gcgSourceFromUrl('cross-tables.com/annotated.php?u=47880&x=1').id, '47880');
    assert.equal(gcgSourceFromUrl('https://www.cross-tables.com/annotated/selfgcg/478/anno47880.gcg').kind, 'crosstables');
    assert.equal(crossTablesGcgUrl(12345), 'https://www.cross-tables.com/annotated/selfgcg/123/anno12345.gcg');
    assert.throws(() => gcgSourceFromUrl('https://www.cross-tables.com/players.php'));
  });

  test('woogles', () => {
    const s = gcgSourceFromUrl('https://woogles.io/game/GfiCzf6rn6');
    assert.equal(s.kind, 'woogles');
    assert.equal(s.id, 'GfiCzf6rn6');
    assert.equal(s.gcgUrl, 'https://woogles.io/api/game_service.GameMetadataService/GetGCG');
    assert.equal(s.method, 'POST');
    assert.deepEqual(JSON.parse(s.body), { game_id: 'GfiCzf6rn6' });
    assert.equal(s.headers['Content-Type'], 'application/json');
    assert.equal(gcgSourceFromUrl('https://woogles.io/game/GfiCzf6rn6?turn=12').id, 'GfiCzf6rn6');
    assert.equal(gcgSourceFromUrl('https://woogles.io/anno/game/abc_DEF-123').id, 'abc_DEF-123');
    assert.throws(() => gcgSourceFromUrl('https://woogles.io/profile/foo'));
  });

  test('raw .gcg links and garbage', () => {
    const s = gcgSourceFromUrl('https://example.org/games/round1.GCG');
    assert.equal(s.kind, 'raw');
    assert.equal(s.gcgUrl, 'https://example.org/games/round1.GCG');
    assert.throws(() => gcgSourceFromUrl('https://example.org/'));
    assert.throws(() => gcgSourceFromUrl(''));
    assert.throws(() => gcgSourceFromUrl('not a url at all'));
  });
});

// ---------------------------------------------------------------------------
describe('fetchGCG with a mocked fetch', () => {
  const gcgText = fixture('woogles_GfiCzf6rn6.gcg');

  test('woogles: POSTs JSON and unwraps {gcg}', async () => {
    const calls = [];
    const fake = async (url, init) => {
      calls.push({ url, init });
      return { ok: true, status: 200, json: async () => ({ gcg: gcgText }), text: async () => JSON.stringify({ gcg: gcgText }) };
    };
    const { text, source } = await fetchGCG('https://woogles.io/game/GfiCzf6rn6', fake);
    assert.equal(text, gcgText);
    assert.equal(source.kind, 'woogles');
    assert.equal(calls[0].init.method, 'POST');
    assert.deepEqual(JSON.parse(calls[0].init.body), { game_id: 'GfiCzf6rn6' });
    assert.equal(calls[0].init.headers['Content-Type'], 'application/json');
  });

  test('cross-tables: GETs the .gcg file', async () => {
    const fake = async (url, init) => {
      assert.equal(url, 'https://www.cross-tables.com/annotated/selfgcg/478/anno47880.gcg');
      assert.equal(init.method, 'GET');
      return { ok: true, status: 200, text: async () => fixture('crosstables_style.gcg') };
    };
    const { text, source } = await fetchGCG('47880', fake);
    assert.equal(source.kind, 'crosstables');
    assert.equal(parseGCG(text).players[0].nick, 'Nigel');
  });

  test('network/CORS failure tells the user to download and paste', async () => {
    const fake = async () => { throw new TypeError('Failed to fetch'); };
    await assert.rejects(fetchGCG('https://woogles.io/game/abc', fake), (e) => {
      assert.match(e.message, /Failed to fetch/);
      assert.match(e.message, /CORS/);
      assert.match(e.message, /Download the GCG file from https:\/\/woogles\.io\/game\/abc/);
      return true;
    });
  });

  test('HTTP error and bot-check pages are reported', async () => {
    await assert.rejects(fetchGCG('47880', async () => ({ ok: false, status: 403, text: async () => '' })), /HTTP 403.*Download the GCG/);
    await assert.rejects(fetchGCG('47880', async () => ({ ok: true, status: 200, text: async () => '<!DOCTYPE html><title>Just a moment...</title>' })), /does not look like a GCG/);
  });

  test('missing fetch implementation', async () => {
    // null (not undefined) so the default parameter does not pick up the real fetch.
    await assert.rejects(fetchGCG('47880', null), /fetch is not available/);
  });
});
