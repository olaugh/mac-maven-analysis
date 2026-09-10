// gcg.js - GCG (Scrabble game record) import for the browser Maven port.
//
// ES module, no dependencies, works in browsers and Node >= 18.
//
// Exports:
//   parseGCG(text)                  -> Game
//   positionAfter(game, turnIndex)  -> Position
//   positionBefore(game, turnIndex) -> Position
//   toCGP(position, opts?)          -> string
//   parseCGP(cgp)                   -> Position
//   gcgSourceFromUrl(input)         -> {kind, gcgUrl, id, pageUrl, method, body?}
//   fetchGCG(input, fetchImpl?)     -> Promise<{text, source}>
//   TILE_DISTRIBUTION, tileCounts, sortTiles (helpers)
//
// GCG reference: https://www.poslfit.com/scrabble/gcg/ (version 1.3).
// CGP reference: Macondo's "Crossword Game Position" notation. In CGP the
// racks and scores are written for the player ON TURN first, then the
// opponent; we follow that convention.

export const BOARD_SIZE = 15;
const N2 = BOARD_SIZE * BOARD_SIZE;

// Standard English distribution, 100 tiles. '?' is the blank.
export const TILE_DISTRIBUTION = Object.freeze({
  a: 9, b: 2, c: 2, d: 4, e: 12, f: 2, g: 3, h: 2, i: 9, j: 1, k: 1, l: 4, m: 2,
  n: 6, o: 8, p: 2, q: 1, r: 6, s: 4, t: 6, u: 4, v: 2, w: 2, x: 1, y: 2, z: 1,
  '?': 2,
});

const LETTERS = 'abcdefghijklmnopqrstuvwxyz';

// ---------------------------------------------------------------------------
// Small helpers
// ---------------------------------------------------------------------------

function isUpper(ch) { return ch >= 'A' && ch <= 'Z'; }
function isLower(ch) { return ch >= 'a' && ch <= 'z'; }
function isLetter(ch) { return isUpper(ch) || isLower(ch); }

/** Order tiles a-z, then '?' (blanks) last. '_' (unknown) after that. */
export function sortTiles(str) {
  const rank = (ch) => (ch === '?' ? 100 : ch === '_' ? 200 : ch.charCodeAt(0));
  return Array.from(str).sort((x, y) => rank(x) - rank(y)).join('');
}

/** Count tiles in a string (letters lowercased, '?' kept). Unknown '_' is ignored. */
export function tileCounts(str) {
  const counts = {};
  for (const ch of str) {
    if (ch === '_') continue;
    const k = ch === '?' ? '?' : ch.toLowerCase();
    counts[k] = (counts[k] || 0) + 1;
  }
  return counts;
}

function countsToString(counts) {
  let s = '';
  for (const k of [...LETTERS, '?']) {
    const n = counts[k] || 0;
    if (n > 0) s += k.repeat(n);
  }
  return s;
}

/** Rack as a lowercase tile string ('?' for blanks, '_' for unknown tiles). */
function normalizeRack(rack) {
  let out = '';
  for (const ch of rack || '') {
    if (isLetter(ch)) out += ch.toLowerCase();
    else if (ch === '?' || ch === '_') out += ch;
    // anything else (e.g. '|' tile separators) is dropped
  }
  return out;
}

/** Remove the tiles of `tiles` from `rack` (both normalized). Blanks in
 *  `tiles` are lowercase letters (blank designations) and consume a '?'.
 *  Returns null if the rack does not contain the tiles. */
function removeFromRack(rack, tiles) {
  const arr = Array.from(rack);
  for (const t of tiles) {
    let want = isLower(t) ? '?' : t.toLowerCase();
    let i = arr.indexOf(want);
    if (i < 0 && want === '?') i = -1;
    if (i < 0) {
      // Unknown tiles ('_') may stand in for anything.
      i = arr.indexOf('_');
      if (i < 0) return null;
    }
    arr.splice(i, 1);
  }
  return arr.join('');
}

// ---------------------------------------------------------------------------
// Coordinates
// ---------------------------------------------------------------------------

const RE_HORIZ = /^(\d{1,2})([A-Oa-o])$/;
const RE_VERT = /^([A-Oa-o])(\d{1,2})$/;

/** Parse "8D" (horizontal) / "D8" (vertical) -> {row, col, vertical} or null. */
export function parseCoordinate(tok) {
  let m = RE_HORIZ.exec(tok);
  if (m) {
    const row = parseInt(m[1], 10) - 1;
    const col = m[2].toUpperCase().charCodeAt(0) - 65;
    if (row < 0 || row >= BOARD_SIZE) return null;
    return { row, col, vertical: false };
  }
  m = RE_VERT.exec(tok);
  if (m) {
    const col = m[1].toUpperCase().charCodeAt(0) - 65;
    const row = parseInt(m[2], 10) - 1;
    if (row < 0 || row >= BOARD_SIZE) return null;
    return { row, col, vertical: true };
  }
  return null;
}

/** Format {row, col, vertical} back to GCG coordinates. */
export function formatCoordinate(row, col, vertical) {
  const letter = String.fromCharCode(65 + col);
  return vertical ? `${letter}${row + 1}` : `${row + 1}${letter}`;
}

// ---------------------------------------------------------------------------
// GCG parsing
// ---------------------------------------------------------------------------

class GCGError extends Error {
  constructor(message, lineNumber, line) {
    super(lineNumber ? `GCG line ${lineNumber}: ${message}\n    ${line}` : message);
    this.name = 'GCGError';
    this.lineNumber = lineNumber;
    this.line = line;
  }
}

const RE_RACK = /^[A-Za-z?_|]+$/;
const RE_SCORE = /^[+-]?\d+$/;

/**
 * Parse a raw event line (already known to begin with '>').
 * Returns {nick, rack, kind, ...} without resolving anything.
 */
function parseEventLine(line, lineNumber) {
  const colon = line.indexOf(':');
  if (colon < 0) throw new GCGError('event line has no "nick:" prefix', lineNumber, line);
  const nick = line.slice(1, colon).trim();
  if (!nick) throw new GCGError('empty player nickname', lineNumber, line);
  const rest = line.slice(colon + 1).trim();
  const tokens = rest.split(/\s+/).filter(Boolean);
  if (tokens.length < 2) throw new GCGError('event line is too short', lineNumber, line);

  // Score and cumulative total are always the last two tokens.
  const totalTok = tokens[tokens.length - 1];
  const scoreTok = tokens[tokens.length - 2];
  if (!RE_SCORE.test(totalTok) || !RE_SCORE.test(scoreTok)) {
    throw new GCGError('expected "+SCORE TOTAL" at end of event', lineNumber, line);
  }
  const score = parseInt(scoreTok, 10);
  const total = parseInt(totalTok, 10);
  const body = tokens.slice(0, -2);

  // Optional rack: letters, '?' blanks, '_' unknowns. Anything else (a
  // coordinate, '-', '--', '(...)') means the rack field is empty.
  // A legal event always has a descriptor after the rack, so if only one
  // token remains it is the descriptor and the rack is empty
  // (e.g. ">Dave: (G) +4 539" or ">Dave: -- -30 80").
  let rack = '';
  if (body.length >= 2 && RE_RACK.test(body[0])) rack = body.shift();

  if (!body.length) throw new GCGError('missing event description', lineNumber, line);
  const desc = body[0];
  const ev = { lineNumber, raw: line, nick, rack, score, total, kind: null };

  if (desc === '-') {
    ev.kind = 'pass';
  } else if (desc === '--') {
    ev.kind = 'lost_challenge';
  } else if (desc[0] === '-') {
    ev.kind = 'exchange';
    const arg = desc.slice(1);
    if (/^\d+$/.test(arg)) {
      ev.exchangeCount = parseInt(arg, 10);
      ev.exchanged = '';
    } else {
      ev.exchanged = arg;
      ev.exchangeCount = normalizeRack(arg).length;
    }
  } else if (desc[0] === '(') {
    const inner = desc.slice(1, desc.indexOf(')') > 0 ? desc.indexOf(')') : undefined);
    const key = inner.toLowerCase();
    if (key === 'challenge') ev.kind = 'challenge_bonus';
    else if (key === 'time') ev.kind = 'time_penalty';
    else {
      ev.tiles = inner;
      ev.kind = score < 0 ? 'end_penalty' : 'end_bonus';
    }
  } else {
    const coord = parseCoordinate(desc);
    if (!coord) throw new GCGError(`unrecognised event "${desc}"`, lineNumber, line);
    if (body.length < 2) throw new GCGError('play has no word', lineNumber, line);
    ev.kind = 'play';
    ev.row = coord.row;
    ev.col = coord.col;
    ev.vertical = coord.vertical;
    ev.wordAsWritten = body[1].replace(/\|/g, '');
  }
  return ev;
}

/** Empty simulation state. */
function newState() {
  return {
    board: new Array(N2).fill(''),
    blanks: new Uint8Array(N2),
    scores: [0, 0],
    zeroTurns: 0,
    side: 0,
  };
}

function snapshotBoard(state) {
  let s = '';
  for (let i = 0; i < N2; i++) {
    const ch = state.board[i];
    if (!ch) s += '.';
    else s += state.blanks[i] ? ch : ch.toUpperCase();
  }
  return s;
}

/**
 * Parse a GCG file into a Game with fully resolved turns.
 *
 * Game = {
 *   players: [{nick, name}, {nick, name}],
 *   title, description, lexicon, id, characterEncoding,
 *   pragmas: {keyword: [args...]},          // every pragma seen, incl. unknown
 *   notes: [{event, text}],                 // event = index of preceding event, -1 for header notes
 *   finalRacks: [rack|null, rack|null],     // from #rack1/#rack2 or (RACK) events
 *   events: [...],                          // raw parsed lines
 *   turns: [Turn],                          // one per event, resolved
 *   warnings: [string],
 * }
 */
export function parseGCG(text) {
  if (typeof text !== 'string') throw new TypeError('parseGCG expects a string');
  const lines = text.replace(/^\uFEFF/, '').split(/\r\n|\r|\n/);

  const game = {
    players: [{ nick: '', name: '' }, { nick: '', name: '' }],
    title: '',
    description: '',
    lexicon: '',
    id: '',
    characterEncoding: '',
    pragmas: {},
    notes: [],
    finalRacks: [null, null],
    events: [],
    turns: [],
    warnings: [],
  };
  const declared = [false, false];
  const rackPragmas = [null, null];

  const state = newState();
  const turns = game.turns;

  const playerIndex = (nick, lineNumber, line) => {
    const lower = nick.toLowerCase();
    for (let p = 0; p < 2; p++) {
      if (game.players[p].nick.toLowerCase() === lower) return p;
    }
    // Undeclared player: take the first free slot.
    for (let p = 0; p < 2; p++) {
      if (!declared[p] && !game.players[p].nick) {
        game.players[p].nick = nick;
        game.players[p].name = game.players[p].name || nick;
        return p;
      }
    }
    throw new GCGError(`unknown player "${nick}" (players are "${game.players[0].nick}" and "${game.players[1].nick}")`, lineNumber, line);
  };

  const lastPlayBy = (player) => {
    for (let i = turns.length - 1; i >= 0; i--) {
      const t = turns[i];
      if (t.player !== player) continue;
      if (t.type === 'play' && t.withdrawnBy === undefined) return i;
      if (t.type === 'play' || t.type === 'exchange' || t.type === 'pass') return -1;
    }
    return -1;
  };

  for (let li = 0; li < lines.length; li++) {
    const lineNumber = li + 1;
    const line = lines[li].trim();
    if (!line) continue;

    if (line[0] === '#') {
      const sp = line.search(/\s/);
      const keyword = (sp < 0 ? line.slice(1) : line.slice(1, sp)).toLowerCase();
      const argText = sp < 0 ? '' : line.slice(sp + 1).trim();
      (game.pragmas[keyword] ||= []).push(argText);
      switch (keyword) {
        case 'player1':
        case 'player2': {
          const p = keyword === 'player1' ? 0 : 1;
          const m = /^(\S+)\s*(.*)$/.exec(argText);
          if (m) {
            game.players[p].nick = m[1];
            game.players[p].name = m[2] || m[1];
            declared[p] = true;
          }
          break;
        }
        case 'title': game.title = argText; break;
        case 'description': game.description = argText; break;
        case 'lexicon': game.lexicon = argText; break;
        case 'id': game.id = argText; break;
        case 'character-encoding': game.characterEncoding = argText; break;
        case 'note':
        case 'comment': {
          const idx = turns.length - 1;
          game.notes.push({ event: idx, text: argText });
          if (idx >= 0) turns[idx].note = turns[idx].note ? `${turns[idx].note}\n${argText}` : argText;
          break;
        }
        case 'rack1': rackPragmas[0] = { rack: argText, after: turns.length - 1 }; break;
        case 'rack2': rackPragmas[1] = { rack: argText, after: turns.length - 1 }; break;
        default: break; // #incomplete, #game-type, #orientation, #tile, ... tolerated
      }
      continue;
    }

    if (line[0] !== '>') {
      game.warnings.push(`line ${lineNumber}: ignored unrecognised line "${line}"`);
      continue;
    }

    const ev = parseEventLine(line, lineNumber);
    const player = playerIndex(ev.nick, lineNumber, line);
    ev.player = player;
    game.events.push(ev);

    const index = turns.length;
    const turn = {
      index,
      player,
      nick: ev.nick,
      type: ev.kind,
      rack: ev.rack,
      score: ev.score,
      cumulative: null,
      note: '',
      lineNumber,
      zeroTurnsBefore: state.zeroTurns,
    };

    switch (ev.kind) {
      case 'play': {
        applyPlay(state, ev, turn, lineNumber, line);
        if (turn.rack && !turn.rack.includes('_')) {
          const leave = removeFromRack(normalizeRack(turn.rack), turn.tilesPlayed);
          if (leave === null) {
            game.warnings.push(`line ${lineNumber}: tiles played (${turn.tilesPlayed}) are not all in rack ${turn.rack}`);
            turn.leave = '';
          } else turn.leave = leave;
        } else turn.leave = '';
        state.scores[player] += ev.score;
        state.zeroTurns = ev.score > 0 ? 0 : state.zeroTurns + 1;
        state.side = 1 - player;
        break;
      }
      case 'exchange': {
        turn.exchanged = ev.exchanged;
        turn.exchangeCount = ev.exchangeCount;
        if (ev.exchanged && turn.rack && !turn.rack.includes('_') && !ev.exchanged.includes('_')) {
          // removeFromRack reads lowercase as blank designations, so feed it
          // uppercase tiles ('?' is unaffected).
          const left = removeFromRack(normalizeRack(turn.rack), normalizeRack(ev.exchanged).toUpperCase());
          if (left === null) game.warnings.push(`line ${lineNumber}: exchanged tiles ${ev.exchanged} are not all in rack ${turn.rack}`);
        }
        if (ev.score !== 0) game.warnings.push(`line ${lineNumber}: exchange with non-zero score`);
        state.scores[player] += ev.score;
        state.zeroTurns += 1;
        state.side = 1 - player;
        break;
      }
      case 'pass': {
        if (ev.score !== 0) game.warnings.push(`line ${lineNumber}: pass with non-zero score`);
        state.scores[player] += ev.score;
        state.zeroTurns += 1;
        state.side = 1 - player;
        break;
      }
      case 'lost_challenge': {
        const pi = lastPlayBy(player);
        if (pi < 0) throw new GCGError('challenge withdrawal ("--") without a preceding play by this player', lineNumber, line);
        const play = turns[pi];
        // Restore the board.
        for (const sq of play.placed) {
          state.board[sq] = '';
          state.blanks[sq] = 0;
        }
        play.withdrawnBy = index;
        turn.withdraws = pi;
        turn.row = play.row; turn.col = play.col; turn.vertical = play.vertical;
        turn.word = play.word; turn.tilesPlayed = play.tilesPlayed;
        if (!turn.rack) turn.rack = play.rack;
        if (ev.score !== -play.score) {
          game.warnings.push(`line ${lineNumber}: withdrawal score ${ev.score} does not match the play's +${play.score}`);
        }
        state.scores[player] += ev.score;
        // A phony challenged off is one scoreless turn.
        state.zeroTurns = play.zeroTurnsBefore + 1;
        state.side = 1 - player;
        break;
      }
      case 'challenge_bonus':
      case 'time_penalty': {
        state.scores[player] += ev.score;
        break;
      }
      case 'end_bonus': {
        // Player receives points for the opponent's remaining tiles.
        turn.tiles = ev.tiles;
        state.scores[player] += ev.score;
        if (game.finalRacks[1 - player] === null) game.finalRacks[1 - player] = ev.tiles.toUpperCase();
        if (game.finalRacks[player] === null) game.finalRacks[player] = '';
        break;
      }
      case 'end_penalty': {
        // Player loses points for their own remaining tiles.
        turn.tiles = ev.tiles;
        state.scores[player] += ev.score;
        if (game.finalRacks[player] === null) game.finalRacks[player] = ev.tiles.toUpperCase();
        break;
      }
      default:
        throw new GCGError(`unhandled event kind ${ev.kind}`, lineNumber, line);
    }

    if (state.scores[player] !== ev.total) {
      game.warnings.push(`line ${lineNumber}: cumulative score ${state.scores[player]} computed but ${ev.total} recorded; using recorded value`);
      state.scores[player] = ev.total;
    }

    turn.cumulative = [state.scores[0], state.scores[1]];
    turn.zeroTurns = state.zeroTurns;
    turn.side = state.side;
    turn.boardAfter = snapshotBoard(state);
    turns.push(turn);
  }

  for (let p = 0; p < 2; p++) {
    if (rackPragmas[p] && rackPragmas[p].after === turns.length - 1) {
      game.finalRacks[p] = rackPragmas[p].rack.toUpperCase();
    }
    if (rackPragmas[p]) game[`rack${p + 1}Pragma`] = rackPragmas[p];
  }
  game.finalScores = turns.length ? turns[turns.length - 1].cumulative.slice() : [0, 0];
  return game;
}

/** Place a play on the board, filling in the turn's row/col/word/tilesPlayed/placed. */
function applyPlay(state, ev, turn, lineNumber, line) {
  const { row, col, vertical } = ev;
  const written = ev.wordAsWritten;
  turn.row = row;
  turn.col = col;
  turn.vertical = vertical;

  let r = row, c = col;
  let word = '';
  let tilesPlayed = '';
  const placed = [];
  for (const ch of written) {
    if (r >= BOARD_SIZE || c >= BOARD_SIZE) {
      throw new GCGError(`word "${written}" at ${formatCoordinate(row, col, vertical)} runs off the board`, lineNumber, line);
    }
    const sq = r * BOARD_SIZE + c;
    const existing = state.board[sq];
    if (ch === '.') {
      if (!existing) throw new GCGError(`"." at ${formatCoordinate(r, c, vertical)} but the square is empty`, lineNumber, line);
      word += state.blanks[sq] ? existing : existing.toUpperCase();
    } else if (isLetter(ch)) {
      if (existing) {
        // Playing through an existing tile written out in full (common in
        // older files; the spec also writes played-through blanks in lower case).
        if (existing !== ch.toLowerCase()) {
          throw new GCGError(`"${written}" at ${formatCoordinate(row, col, vertical)}: square ${formatCoordinate(r, c, vertical)} holds ${existing.toUpperCase()}, not ${ch.toUpperCase()}`, lineNumber, line);
        }
        word += state.blanks[sq] ? existing : existing.toUpperCase();
      } else {
        state.board[sq] = ch.toLowerCase();
        state.blanks[sq] = isLower(ch) ? 1 : 0;
        placed.push(sq);
        word += ch;
        tilesPlayed += ch;
      }
    } else {
      throw new GCGError(`unexpected character "${ch}" in word "${written}"`, lineNumber, line);
    }
    if (vertical) r++; else c++;
  }
  if (!placed.length) {
    // Not fatal, but odd (e.g. a record of a play entirely through existing tiles).
    // Callers can inspect turn.tilesPlayed === ''.
  }
  turn.word = word;
  turn.tilesPlayed = tilesPlayed;
  turn.placed = placed;
}

// ---------------------------------------------------------------------------
// Positions
// ---------------------------------------------------------------------------

const RACK_TYPES = new Set(['play', 'exchange', 'pass', 'lost_challenge']);

function emptyPosition() {
  return {
    board: new Array(N2).fill(''),
    blanks: new Uint8Array(N2),
    racks: ['', ''],
    scores: [0, 0],
    side: 0,
    zeroTurns: 0,
    unseen: '',
    unseenCounts: {},
    bagCount: 100,
    rackKnown: [false, false],
    turnIndex: -1,
  };
}

function boardFromSnapshot(snapshot, pos) {
  for (let i = 0; i < N2; i++) {
    const ch = snapshot[i];
    if (ch === '.') { pos.board[i] = ''; pos.blanks[i] = 0; }
    else { pos.board[i] = ch.toLowerCase(); pos.blanks[i] = isLower(ch) ? 1 : 0; }
  }
}

/** Fill unseen/unseenCounts/bagCount from board + mover's rack. */
function computeUnseen(pos) {
  const counts = { ...TILE_DISTRIBUTION };
  for (let i = 0; i < N2; i++) {
    const ch = pos.board[i];
    if (!ch) continue;
    const k = pos.blanks[i] ? '?' : ch;
    counts[k] = (counts[k] || 0) - 1;
  }
  for (const ch of pos.racks[pos.side]) {
    if (ch === '_') continue;
    counts[ch] = (counts[ch] || 0) - 1;
  }
  pos.unseenCounts = counts;
  const clamped = {};
  let total = 0;
  for (const k of Object.keys(counts)) { clamped[k] = Math.max(0, counts[k]); total += clamped[k]; }
  pos.unseen = countsToString(clamped);
  const opp = pos.racks[1 - pos.side];
  const oppSize = pos.rackKnown[1 - pos.side] ? opp.length : Math.min(7, total);
  pos.bagCount = Math.max(0, total - oppSize);
  return pos;
}

/**
 * Rack of `player` immediately after event `turnIndex` (-1 = before the game).
 * Returns {rack, known}. The rack is taken from the player's next rack-bearing
 * event; failing that from the final racks (#rack1/#rack2 or "(RACK)" events).
 */
function rackAfter(game, player, turnIndex) {
  const turns = game.turns;
  // Special case: the player just made a play that is withdrawn by the very
  // next event - at this instant they hold the leave.
  if (turnIndex >= 0) {
    const t = turns[turnIndex];
    if (t.player === player && t.type === 'play' && t.withdrawnBy === turnIndex + 1 && t.rack) {
      return { rack: t.leave, known: true };
    }
  }
  for (let i = turnIndex + 1; i < turns.length; i++) {
    const t = turns[i];
    if (t.player === player && RACK_TYPES.has(t.type) && t.rack) {
      return { rack: normalizeRack(t.rack), known: true };
    }
    if (t.player === player && (t.type === 'challenge_bonus' || t.type === 'time_penalty' || t.type === 'end_penalty') && t.rack) {
      return { rack: normalizeRack(t.rack), known: true };
    }
  }
  // No later information from this player's own lines.
  if (game.finalRacks[player] !== null) {
    // Only valid once the player has made their last move.
    let lastMove = -1;
    for (let i = turns.length - 1; i >= 0; i--) {
      if (turns[i].player === player && RACK_TYPES.has(turns[i].type)) { lastMove = i; break; }
    }
    if (turnIndex >= lastMove) return { rack: normalizeRack(game.finalRacks[player]), known: true };
  }
  // A #rack1/#rack2 pragma placed right after this event.
  const pr = game[`rack${player + 1}Pragma`];
  if (pr && pr.after === turnIndex) return { rack: normalizeRack(pr.rack), known: true };
  // Otherwise the player's later draw is unrecorded (the leave alone is not a rack).
  return { rack: '', known: false };
}

/**
 * Position after event `turnIndex` (0-based). turnIndex = -1 gives the
 * starting position (empty board, player 1 to move with the rack of the
 * first event if known).
 */
export function positionAfter(game, turnIndex) {
  if (turnIndex >= game.turns.length) turnIndex = game.turns.length - 1;
  const pos = emptyPosition();
  pos.turnIndex = turnIndex;
  if (turnIndex >= 0) {
    const t = game.turns[turnIndex];
    boardFromSnapshot(t.boardAfter, pos);
    pos.scores = t.cumulative.slice();
    pos.side = t.side;
    pos.zeroTurns = t.zeroTurns;
  } else if (game.turns.length) {
    pos.side = game.turns[0].player;
  }
  for (let p = 0; p < 2; p++) {
    const { rack, known } = rackAfter(game, p, turnIndex);
    pos.racks[p] = rack;
    pos.rackKnown[p] = known;
  }
  computeUnseen(pos);
  if (!pos.rackKnown[pos.side]) {
    pos.note = 'The rack of the player to move is not recorded in this GCG file.';
  }
  return pos;
}

/** Position before event `turnIndex`: the mover is that event's player. */
export function positionBefore(game, turnIndex) {
  const pos = positionAfter(game, turnIndex - 1);
  if (turnIndex >= 0 && turnIndex < game.turns.length) {
    const t = game.turns[turnIndex];
    if (RACK_TYPES.has(t.type)) {
      pos.side = t.player;
      if (t.rack) {
        pos.racks[t.player] = normalizeRack(t.rack);
        pos.rackKnown[t.player] = true;
      }
      computeUnseen(pos);
      pos.note = pos.rackKnown[pos.side] ? undefined : 'The rack of the player to move is not recorded in this GCG file.';
      if (pos.note === undefined) delete pos.note;
    }
  }
  return pos;
}

// ---------------------------------------------------------------------------
// CGP
// ---------------------------------------------------------------------------

/**
 * Serialise a Position as a CGP string:
 *   "<15 rows joined by '/'> RACK_ON_TURN/RACK_OPP SCORE_ON_TURN/SCORE_OPP ZEROTURNS [lex NAME;]"
 * Empty runs are numbers, regular tiles uppercase, blanks lowercase, racks
 * uppercase with '?' for blanks (unknown '_' tiles are dropped).
 */
export function toCGP(position, opts = {}) {
  const rows = [];
  for (let r = 0; r < BOARD_SIZE; r++) {
    let s = '';
    let run = 0;
    for (let c = 0; c < BOARD_SIZE; c++) {
      const i = r * BOARD_SIZE + c;
      const ch = position.board[i];
      if (!ch) { run++; continue; }
      if (run) { s += run; run = 0; }
      s += position.blanks[i] ? ch.toLowerCase() : ch.toUpperCase();
    }
    if (run) s += run;
    rows.push(s);
  }
  const side = position.side || 0;
  const rackStr = (r) => (r || '').replace(/_/g, '').toUpperCase();
  const racks = `${rackStr(position.racks[side])}/${rackStr(position.racks[1 - side])}`;
  const scores = `${position.scores[side]}/${position.scores[1 - side]}`;
  let cgp = `${rows.join('/')} ${racks} ${scores} ${position.zeroTurns || 0}`;
  const lexicon = opts.lexicon || (position.opcodes && position.opcodes.lex);
  if (lexicon) cgp += ` lex ${lexicon};`;
  return cgp;
}

/**
 * Parse a CGP string into a Position. The player on turn becomes side 0.
 * Opcodes ("lex CSW21;" etc.) are collected in position.opcodes.
 */
export function parseCGP(cgp) {
  if (typeof cgp !== 'string') throw new TypeError('parseCGP expects a string');
  const text = cgp.trim();
  const m = /^(\S+)\s+(\S+)\s+(\S+)\s+(\d+)\s*(.*)$/s.exec(text);
  if (!m) {
    // Allow the minimal form "<board> <racks>" too.
    const m2 = /^(\S+)\s+(\S*)\s*$/.exec(text);
    if (!m2) throw new Error('Not a CGP string: expected "<board> <racks> <scores> <zero-turns>"');
    return parseCGP(`${m2[1]} ${m2[2] || '/'} 0/0 0`);
  }
  const [, boardText, racksText, scoresText, zeroText, opText] = m;
  const pos = emptyPosition();

  const rows = boardText.split('/');
  if (rows.length !== BOARD_SIZE) throw new Error(`CGP board has ${rows.length} rows, expected ${BOARD_SIZE}`);
  for (let r = 0; r < BOARD_SIZE; r++) {
    let c = 0;
    const row = rows[r];
    for (let k = 0; k < row.length;) {
      const ch = row[k];
      if (ch >= '0' && ch <= '9') {
        let j = k;
        while (j < row.length && row[j] >= '0' && row[j] <= '9') j++;
        c += parseInt(row.slice(k, j), 10);
        k = j;
      } else if (isLetter(ch)) {
        if (c >= BOARD_SIZE) throw new Error(`CGP row ${r + 1} is too long`);
        const i = r * BOARD_SIZE + c;
        pos.board[i] = ch.toLowerCase();
        pos.blanks[i] = isLower(ch) ? 1 : 0;
        c++; k++;
      } else {
        throw new Error(`CGP row ${r + 1}: unexpected character "${ch}"`);
      }
    }
    if (c !== BOARD_SIZE) throw new Error(`CGP row ${r + 1} has ${c} squares, expected ${BOARD_SIZE}`);
  }

  const rackParts = racksText.split('/');
  if (rackParts.length !== 2) throw new Error('CGP racks must be "RACK1/RACK2"');
  pos.racks = rackParts.map((r) => normalizeRack(r));
  pos.rackKnown = [true, true];

  const scoreParts = scoresText.split('/');
  if (scoreParts.length !== 2 || !scoreParts.every((s) => /^-?\d+$/.test(s))) {
    throw new Error('CGP scores must be "N/N"');
  }
  pos.scores = scoreParts.map((s) => parseInt(s, 10));
  pos.zeroTurns = parseInt(zeroText, 10);
  pos.side = 0;

  pos.opcodes = {};
  for (const op of opText.split(';')) {
    const t = op.trim();
    if (!t) continue;
    const sp = t.search(/\s/);
    if (sp < 0) pos.opcodes[t] = '';
    else pos.opcodes[t.slice(0, sp)] = t.slice(sp + 1).trim();
  }
  computeUnseen(pos);
  return pos;
}

// ---------------------------------------------------------------------------
// Sources and fetching
// ---------------------------------------------------------------------------

const WOOGLES_GCG_ENDPOINT = 'https://woogles.io/api/game_service.GameMetadataService/GetGCG';

/** Cross-tables stores anno<ID>.gcg under a directory named by the first three
 *  digits of the id (47880 -> 478). Verified only for 5-digit ids. */
export function crossTablesGcgUrl(id) {
  const s = String(id);
  const dir = s.slice(0, 3);
  return `https://www.cross-tables.com/annotated/selfgcg/${dir}/anno${s}.gcg`;
}

/**
 * Classify user input (URL or id) and work out where the GCG text lives.
 * Returns {kind: 'crosstables'|'woogles'|'raw', id, gcgUrl, pageUrl, method, headers?, body?}.
 */
export function gcgSourceFromUrl(input) {
  const s = String(input || '').trim();
  if (!s) throw new Error('Empty URL');

  if (/^\d+$/.test(s)) {
    return {
      kind: 'crosstables', id: s, method: 'GET',
      gcgUrl: crossTablesGcgUrl(s),
      pageUrl: `https://www.cross-tables.com/annotated.php?u=${s}`,
    };
  }

  let url;
  try {
    url = new URL(/^[a-z][a-z0-9+.-]*:\/\//i.test(s) ? s : `https://${s}`);
  } catch {
    throw new Error(`Not a URL or cross-tables game id: "${s}"`);
  }
  const host = url.hostname.toLowerCase();

  if (host === 'cross-tables.com' || host.endsWith('.cross-tables.com')) {
    let id = url.searchParams.get('u');
    if (!id) {
      const m = /anno(\d+)\.gcg$/i.exec(url.pathname);
      if (m) id = m[1];
    }
    if (!id || !/^\d+$/.test(id)) throw new Error(`Cannot find a game id in cross-tables URL "${s}"`);
    return {
      kind: 'crosstables', id, method: 'GET',
      gcgUrl: crossTablesGcgUrl(id),
      pageUrl: `https://www.cross-tables.com/annotated.php?u=${id}`,
    };
  }

  if (host === 'woogles.io' || host.endsWith('.woogles.io')) {
    const m = /^\/(?:anno\/)?game\/([A-Za-z0-9_-]+)/.exec(url.pathname);
    if (!m) throw new Error(`Cannot find a game id in woogles URL "${s}"`);
    const id = m[1];
    return {
      kind: 'woogles', id, method: 'POST',
      gcgUrl: WOOGLES_GCG_ENDPOINT,
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ game_id: id }),
      pageUrl: `https://woogles.io${url.pathname.startsWith('/anno/') ? '/anno' : ''}/game/${id}`,
    };
  }

  if (/\.gcg$/i.test(url.pathname)) {
    return { kind: 'raw', id: url.pathname.split('/').pop(), method: 'GET', gcgUrl: url.href, pageUrl: url.href };
  }

  throw new Error(`Unrecognised game URL "${s}" (expected a cross-tables.com annotated game, a woogles.io game, or a .gcg link)`);
}

function looksLikeGCG(text) {
  return typeof text === 'string' && /^\s*(#\w|>)/m.test(text) && /^>[^:]+:/m.test(text);
}

/**
 * Download GCG text for a game URL / id. Network and CORS failures are turned
 * into an Error telling the user to download the GCG file and paste/open it.
 */
export async function fetchGCG(input, fetchImpl = globalThis.fetch) {
  const source = gcgSourceFromUrl(input);
  if (typeof fetchImpl !== 'function') throw new Error('fetch is not available in this environment');

  const fallback = `Download the GCG file from ${source.pageUrl} and open or paste it here instead.`;
  let res;
  try {
    const init = { method: source.method };
    if (source.headers) init.headers = source.headers;
    if (source.body) init.body = source.body;
    res = await fetchImpl(source.gcgUrl, init);
  } catch (e) {
    throw new Error(
      `Could not download the game from ${source.gcgUrl} (${e && e.message ? e.message : e}). ` +
      `This is usually a CORS or network restriction: browsers are not allowed to read ${new URL(source.gcgUrl).hostname} directly. ${fallback}`);
  }
  if (!res.ok) {
    throw new Error(`${new URL(source.gcgUrl).hostname} answered HTTP ${res.status} for ${source.gcgUrl}. ${fallback}`);
  }

  let text;
  if (source.kind === 'woogles') {
    let json;
    try { json = await res.json(); } catch (e) { throw new Error(`woogles.io did not return JSON. ${fallback}`); }
    text = json && typeof json.gcg === 'string' ? json.gcg : '';
  } else {
    text = await res.text();
  }
  if (!looksLikeGCG(text)) {
    throw new Error(`The response from ${source.gcgUrl} does not look like a GCG file (it may be a bot-check page). ${fallback}`);
  }
  return { text, source };
}

export { GCGError };
