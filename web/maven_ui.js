/* Maven's game window, menus and commands, reproduced from the original
 * 640x480 screen layout, driving the reconstructed engine in a worker. */
import { C, SYS, Screen, Fonts, MenuBar, Dialog, pattern, PAT, fillRect, frameRect, hline, vline, fillPattern, drawButton, drawWindowFrame, drawTextCentered, drawTextRight, drawList, listRowAt, listScrollHit, listScroll, frameRoundRect, fillRoundRect } from './toolbox.js';
import { ditlDialog, alertDialog, promptDialog, loadDITL } from './dialogs.js';
import { parseGCG, positionBefore, positionAfter, fetchGCG, gcgSourceFromUrl, parseCGP, toCGP, TILE_DISTRIBUTION, formatCoordinate } from './gcg.js';

/* ---------- layout (measured from the original screen) ---------- */
const L = {
  W: 640, H: 480, menu: 20,
  win: { x: 0, y: 20, w: 639, h: 458 },
  board: { x: 19, y: 56, cell: 26 },
  unseen: { x: 437, y: 40, w: 200, h: 46 },
  play: { x: 442, y: 97, w: 30, h: 22 },
  clock: { x: 523, y: 96, w: 57, h: 24 },
  reset: { x: 587, y: 96, w: 52, h: 24 },
  rack: { x: 437, y: 150, w: 26, h: 28, pitch: 28 },
  score: { x: 437, y: 184, w: 200, h: 15 },  // top/bottom double-framed
  listHeader: { x: 437, y: 198, w: 200, h: 13 },
  list: { x: 437, y: 210, w: 200, h: 124 },
};
const PREMIUM = (() => {
  const g = [];
  const tw = '0,0 0,7 0,14 7,0 7,14 14,0 14,7 14,14', dw = '1,1 2,2 3,3 4,4 1,13 2,12 3,11 4,10 13,1 12,2 11,3 10,4 13,13 12,12 11,11 10,10 7,7';
  const tl = '1,5 1,9 5,1 5,5 5,9 5,13 9,1 9,5 9,9 9,13 13,5 13,9';
  const dl = '0,3 0,11 2,6 2,8 3,0 3,7 3,14 6,2 6,6 6,8 6,12 7,3 7,11 8,2 8,6 8,8 8,12 11,0 11,7 11,14 12,6 12,8 14,3 14,11';
  for (let i = 0; i < 225; i++) g.push('');
  const set = (s, k) => s.split(' ').forEach(p => { const [r, c] = p.split(',').map(Number); g[r * 15 + c] = k; });
  set(tw, 'TW'); set(dw, 'DW'); set(tl, 'TL'); set(dl, 'DL'); g[112] = 'DW';
  return g;
})();
const LETTER_VALUES = { a: 1, b: 3, c: 3, d: 2, e: 1, f: 4, g: 2, h: 4, i: 1, j: 8, k: 5, l: 1, m: 3, n: 1, o: 1, p: 3, q: 10, r: 1, s: 1, t: 1, u: 1, v: 4, w: 4, x: 8, y: 4, z: 10, '?': 0 };
const LEVELS = ['2100 - Give Up Hope', '2060 - Overwhelming', '2020 - Crushing', '1980 - Devastating', '1940 - Murderous', '1900 - Deadly', '1860 - Master', '1820 - Expert', '1780 - Dangerous', '1740 - Strong', '1700 - Tough', '1660 - Interesting', '1620 - Plays Well', '1580 - Plays Decently', '1540 - Plays OK', '1500 - Plays So-So', '1460 - Plays', '1420 - Plays Legal Moves'];
const BOARD_FONT = 'Geneva-24-tt', RACK_FONT = 'Geneva-20-tt', LIST_FONT = 'Monaco-9', ROW_FONT = 'Geneva-9', SMALL = 'Geneva-9';
// Kibitzer/History column x-offsets inside the list, measured from the emulator.
const COL = { label: 1, word: 83, pos: 97, score: 139, leave: 145, total: 195 };

/* ---------- worker client ---------- */
class EngineClient {
  constructor(worker) { this.worker = worker; this.pending = new Map(); this.next = 1; this.listeners = []; worker.onmessage = ev => this.onMessage(ev.data); }
  onMessage(m) {
    if (m.id) { const p = this.pending.get(m.id); if (!p) return; this.pending.delete(m.id); if (m.error) p.reject(new Error(m.error)); else p.resolve(m.result); }
    else for (const l of this.listeners) l(m);
  }
  request(type, args, transfer) { return new Promise((resolve, reject) => { const id = this.next++; this.pending.set(id, { resolve, reject }); this.worker.postMessage({ id, type, args }, transfer || []); }); }
  on(fn) { this.listeners.push(fn); }
}

/* ---------- game state helpers ---------- */
function emptyPosition() { return { letters: Array(225).fill(''), blanks: Array(225).fill(0), racks: ['', ''], scores: [0, 0], zero: 0, side: 0 }; }
function positionToWire(p) { return { letters: p.letters.slice(), blanks: Array.from(p.blanks), racks: p.racks.slice(), scores: p.scores.slice(), zero: p.zero || 0, side: p.side || 0 }; }
function fmt(n, w) { const s = String(n); return s.length >= w ? s : ' '.repeat(w - s.length) + s; }
function pad(s, w) { return s.length >= w ? s : s + ' '.repeat(w - s.length); }
function coordText(m) { if (m.exchange) return ''; return formatCoordinate(m.row, m.col, m.vertical); }
function coordinateText(row, col, vertical) { return vertical ? String.fromCharCode(65 + col) + (row + 1) : (row + 1) + String.fromCharCode(65 + col); }
function displayWord(word, blanksMask) { let s = ''; for (let i = 0; i < word.length; i++) s += blanksMask && blanksMask[i] ? word[i].toUpperCase() : word[i]; return s; }

export class MavenApp {
  constructor(canvas, sprites) {
    this.screen = new Screen(canvas);
    this.ctx = this.screen.ctx;
    this.sprites = sprites;
    this.dialogs = [];
    this.windowOpen = false;
    this.game = null;
    this.staging = new Map(); this.cursor = null; this.exchangeSel = new Set(); this.drag = null;
    this.list = { mode: 'kibitz', header: " KIBITZER'S CHOICES ", rows: [], top: 0, selected: -1, columns: [22, 107] };
    this.kibitz = null; this.kibitzPositionKey = null;
    this.view = { labels: false, values: true, unseen: true, rowcol: true, clock: true };
    this.analyzers = { end: true, late: true };
    this.lexiconMode = 2; this.dictionary = 'MAVEN-1995.dawg'; this.dictionaries = [];
    this.level = 0; this.varyLevel = false; this.rating = 2100;
    this.thinking = false; this.simulating = false; this.status = '';
    this.clock = { running: false, start: 0, base: 0 };
    this.names = ['', 'MAVEN'];
    this.rating = 0;
    this.review = null; // GCG review state
    this.pressed = null; this.needsRedraw = true;
    this.buildMenus();
  }

  /* ---------- startup ---------- */
  async start(workerUrl) {
    await Fonts.load('./', ['Charcoal-12', 'Chicago-12', 'Geneva-9', 'Geneva-12', 'Geneva-14', 'Geneva-18', 'Monaco-9', 'Geneva-24-tt', 'Geneva-20-tt', 'Geneva-12-tt']);
    await loadDITL('ditl.json');
    try { this.dictionaries = await (await fetch('dictionaries/index.json')).json(); } catch (e) { this.dictionaries = [{ file: 'MAVEN-1995.dawg', label: 'Maven 1995 (TWL98 / OSW)' }]; }
    const saved = JSON.parse(localStorage.getItem('maven.prefs') || '{}');
    if (saved.names) this.names = saved.names; if (saved.view) Object.assign(this.view, saved.view); if (saved.analyzers) Object.assign(this.analyzers, saved.analyzers);
    if (saved.lexiconMode != null) this.lexiconMode = saved.lexiconMode; if (saved.dictionary) this.dictionary = saved.dictionary; if (saved.rating) this.rating = saved.rating; if (saved.level) this.level = saved.level;
    this.shared = typeof SharedArrayBuffer !== 'undefined' ? new SharedArrayBuffer(4) : null;
    this.cancelFlag = this.shared ? new Int32Array(this.shared) : null;
    this.worker = new Worker(workerUrl, { type: 'module' });
    this.engine = new EngineClient(this.worker);
    this.engine.on(m => this.onEngineEvent(m));
    this.status = 'Loading engine…'; this.redraw();
    const resources = await (await fetch('resources/index.json')).json();
    const dictionaryBytes = await this.loadDictionaryBytes(this.dictionary);
    await this.engine.request('init', { wasmUrl: new URL('build/maven-app.wasm', location.href).href, resourceUrls: resources.map(f => new URL('resources/' + f, location.href).href), dictionaryBytes, shared: this.shared }, dictionaryBytes ? [dictionaryBytes.buffer] : []);
    await this.engine.request('setLexicon', { mode: this.lexiconMode });
    await this.engine.request('setLevel', { index: this.level, rating: this.rating });
    this.status = '';
    this.buildMenus(); this.windowOpen = true;
    if (!saved.names) await this.askName();
    const autosave = localStorage.getItem('maven.autosave');
    if (autosave) {
      const r = await this.runDialog(alertDialog('A game was in progress when Maven was last closed.  Resume it?', [{ text: 'Discard', id: 'discard' }, { text: 'Resume', id: 'resume', default: true }], { icon: 'note' }));
      if (r === 'resume') await this.restoreAutosave(JSON.parse(autosave)); else localStorage.removeItem('maven.autosave');
    }
    this.redraw();
    setInterval(() => { if (this.clock.running || this.dialogs.length === 0) this.redraw(); }, 1000);
  }
  async loadDictionaryBytes(file) {
    if (file === 'custom' && this.customDictionary) return this.customDictionary.slice();
    const r = await fetch('dictionaries/' + file); if (!r.ok) throw new Error('dictionary ' + file);
    return new Uint8Array(await r.arrayBuffer());
  }
  savePrefs() { localStorage.setItem('maven.prefs', JSON.stringify({ names: this.names, view: this.view, analyzers: this.analyzers, lexiconMode: this.lexiconMode, dictionary: this.dictionary, rating: this.rating, level: this.level })); }
  async askName() {
    const d = ditlDialog(1018, { defaultId: 0, edits: { 1: '' } });
    await this.runDialog(d);
    const name = (d.items.find(i => i.type === 'edit').text || '').trim().toUpperCase().slice(0, 10);
    this.names[0] = name; this.savePrefs();
  }
  onEngineEvent(m) {
    if (m.type === 'publish') { this.showSimulationPublication(m.moves, m.count); }
    else if (m.type === 'progress') { this.simProgress = m; this.redraw(); }
  }

  /* ---------- menus ---------- */
  buildMenus() {
    const g = this.game, inGame = !!g && !g.finished && !this.thinking, open = this.windowOpen;
    const human = inGame && g.position.side === 0;
    this.menuBar = new MenuBar([
      { apple: true, title: '', items: [{ label: 'About Maven™ Software...', action: () => this.about() }, { separator: true }, { label: 'Reconstruction notes...', action: () => this.notes() }] },
      { title: 'File', items: [
        { label: 'New Game', key: 'N', action: () => this.newGame() },
        { label: 'Open...', key: 'O', action: () => this.openFile() },
        { label: 'Close', key: 'W', enabled: open, action: () => this.closeWindow() },
        { separator: true },
        { label: 'Save', key: 'S', enabled: !!g, action: () => this.save(false) },
        { label: 'Save As...', enabled: !!g, action: () => this.save(true) },
        { label: 'Export GCG...', enabled: !!g, action: () => this.exportGCG() },
        { separator: true },
        { label: 'Quit', key: 'Q', action: () => this.quit() }] },
      { title: 'Edit', items: [
        { label: 'Undo', key: 'Z', enabled: !!g && g.turns.length > 0 && !this.thinking, action: () => this.undo() },
        { label: 'Cut', key: 'X', enabled: false }, { label: 'Copy Position (CGP)', key: 'C', enabled: !!g, action: () => this.copyCGP() }, { label: 'Paste Position', key: 'V', action: () => this.pastePosition() }] },
      { title: 'Stuff', items: [
        { label: 'Kibitz', key: 'K', enabled: inGame || !!this.review, action: () => this.doKibitz() },
        { label: 'Word List...', key: 'L', enabled: open, action: () => this.wordListDialog() },
        { label: 'Simulate...', enabled: (inGame || !!this.review) && !this.simulating, action: () => this.simulateDialog() },
        { label: 'Alter Rack & Position', key: 'A', enabled: open && !this.thinking, action: () => this.alterPosition() },
        { label: 'Change Tile Order...', enabled: !!g, action: () => this.changeTileOrder() },
        { label: this.list.mode === 'history' ? 'Hide Playing History' : 'Show History', key: 'H', enabled: !!g, action: () => this.toggleHistory() },
        { label: 'Compare To Best Move', enabled: !!g && !!g.lastComparison, action: () => this.compareToBest() },
        { label: 'Configure The Board...', enabled: false }] },
      { title: 'Level', items: [...LEVELS.map((l, i) => ({ label: l, checked: i === this.level, action: () => this.setPlayLevel(i) })), { separator: true }, { label: 'Vary Level By Result', enabled: false, checked: this.varyLevel }] },
      { title: 'View', items: [
        { label: 'Premium Square Labels', checked: this.view.labels, action: () => this.toggleView('labels') },
        { label: 'Tile Values', checked: this.view.values, action: () => this.toggleView('values') },
        { label: 'Unseen Tiles', checked: this.view.unseen, action: () => this.toggleView('unseen') },
        { label: 'Row & Column Labels', checked: this.view.rowcol, action: () => this.toggleView('rowcol') },
        { label: 'Clock', checked: this.view.clock, action: () => this.toggleView('clock') }] },
      { title: 'Lexicon', items: [
        { label: 'North American', checked: this.lexiconMode === 0, action: () => this.setLexicon(0) },
        { label: 'United Kingdom', checked: this.lexiconMode === 1, action: () => this.setLexicon(1) },
        { label: 'Both N.A. And U.K.', checked: this.lexiconMode === 2, action: () => this.setLexicon(2) },
        { separator: true },
        ...this.dictionaries.map(d => ({ label: d.label || d.file, checked: this.dictionary === d.file, enabled: !this.thinking && !this.simulating, action: () => this.setDictionary(d.file) })),
        { label: 'Compile Word Lists...', enabled: !this.thinking, action: () => this.compileWordLists() }] },
      { title: 'Help', items: [{ label: 'How To Play', action: () => this.help() }] },
    ], this.sprites);
  }
  toggleView(k) { this.view[k] = !this.view[k]; this.savePrefs(); this.buildMenus(); this.redraw(); }
  async setLexicon(mode) { this.lexiconMode = mode; await this.engine.request('setLexicon', { mode }); this.savePrefs(); this.invalidateKibitz(); this.buildMenus(); this.redraw(); }
  async setPlayLevel(i) {
    this.level = i;
    await this.engine.request('setLevel', { index: i, rating: this.rating });
    this.savePrefs(); this.invalidateKibitz(); this.buildMenus(); this.redraw();
    if (i > 0 && !this.ratingAsked) { this.ratingAsked = true; await this.askRating(); }
  }
  async askRating() {
    const d = ditlDialog(1017, { defaultId: 0, edits: { 1: String(this.rating) } });
    const edit = d.items.find(x => x.type === 'edit'); if (edit) { edit.filter = c => /\d/.test(c); edit.maxLength = 4; }
    const r = await this.runDialog(d); if (r == null) return;
    const v = parseInt((d.items.find(x => x.type === 'edit') || {}).text || '', 10);
    if (v >= 500 && v <= 3000) { this.rating = v; await this.engine.request('setLevel', { index: this.level, rating: v }); this.savePrefs(); this.invalidateKibitz(); }
  }
  async setDictionary(file) {
    if (file === this.dictionary) return;
    if (this.game && this.game.turns.length && !this.game.finished) {
      const r = await this.runDialog(alertDialog('Changing the dictionary restarts the engine, as if Maven were relaunched with a different data fork.  The current game position is kept.  Continue?', [{ text: 'Cancel', id: 'cancel', cancel: true }, { text: 'Change', id: 'ok', default: true }]));
      if (r !== 'ok') return;
    }
    this.status = 'Loading dictionary…'; this.redraw();
    try {
      const bytes = await this.loadDictionaryBytes(file);
      await this.engine.request('setDictionary', { bytes }, [bytes.buffer]);
      await this.engine.request('setLexicon', { mode: this.lexiconMode });
      this.dictionary = file; this.savePrefs();
      if (this.game) { await this.engine.request('setPosition', { position: positionToWire(this.game.position) }); this.game.engineHistory = 0; }
      this.invalidateKibitz();
    } catch (e) { await this.runDialog(alertDialog('Cannot read the word list.\r' + e.message, [{ text: 'OK', id: 'ok', default: true }], { icon: 'stop' })); }
    this.status = ''; this.buildMenus(); this.redraw();
  }
  async compileWordLists() {
    const r = await this.runDialog(alertDialog('Choose one or two word list text files (one word per line).  The first becomes the North American section, the second the United Kingdom section.', [{ text: 'Cancel', id: 'cancel', cancel: true }, { text: 'Choose Files', id: 'ok', default: true }], { icon: 'note', width: 360 }));
    if (r !== 'ok') return;
    const files = await pickFiles(true);
    if (!files.length) return;
    this.status = 'Compiling word lists…'; this.redraw();
    try {
      const mod = await import('./dawg_compiler.js');
      const texts = await Promise.all(files.slice(0, 2).map(f => f.text()));
      const lists = texts.map(t => mod.parseWordList ? mod.parseWordList(t) : t.split(/\r?\n/).map(w => w.trim().toLowerCase()).filter(w => /^[a-z]{2,15}$/.test(w)));
      const bytes = mod.compileDawg(lists[0], lists[1] || lists[0], { maxLength: 15 });
      this.customDictionary = bytes;
      const label = files.map(f => f.name.replace(/\.[^.]*$/, '')).join(' / ');
      this.dictionaries = this.dictionaries.filter(d => d.file !== 'custom').concat([{ file: 'custom', label }]);
      await this.setDictionary('custom');
    } catch (e) { await this.runDialog(alertDialog('Cannot compile the word list.\r' + e.message, [{ text: 'OK', id: 'ok', default: true }], { icon: 'stop' })); }
    this.status = ''; this.buildMenus(); this.redraw();
  }

  /* ---------- drawing ---------- */
  redraw() { this.needsRedraw = true; if (!this.raf) this.raf = requestAnimationFrame(() => { this.raf = null; this.paint(); }); }
  paint() {
    const ctx = this.ctx;
    // desktop
    fillPattern(ctx, 0, 0, L.W, L.H, pattern(ctx, PAT.checker, '#7777bb', '#9999dd'));
    if (this.windowOpen) this.drawWindow(ctx);
    for (const d of this.dialogs) d.draw(ctx);
    this.menuBar.draw(ctx, L.W);
    if (this.status) { const w = Fonts.measure(SYS, this.status) + 20; fillRect(ctx, 320 - w / 2, 440, w, 20, C.platinum); frameRect(ctx, 320 - w / 2, 440, w, 20, C.black); drawTextCentered(ctx, SYS, this.status, 320, 454, C.black); }
    this.screen.flip();
  }
  windowTitle() {
    if (!this.game) return 'Maven™ Software Position';
    if (this.review) return this.review.title;
    return this.game.fileName ? this.game.fileName : this.game.turns.length || this.game.started ? 'New Game' : 'Maven™ Software Position';
  }
  drawWindow(ctx) {
    drawWindowFrame(ctx, L.win, this.windowTitle(), { active: this.dialogs.length === 0 });
    this.drawBoard(ctx);
    if (this.view.unseen) this.drawUnseen(ctx);
    this.drawControls(ctx);
    this.drawRack(ctx);
    this.drawScoreBox(ctx);
    this.drawListArea(ctx);
  }
  cellRect(r, c) { return { x: L.board.x + 1 + c * L.board.cell, y: L.board.y + 1 + r * L.board.cell, w: 25, h: 25 }; }
  drawBoard(ctx) {
    const b = L.board; const size = 15 * b.cell + 1;
    fillRect(ctx, b.x, b.y, size, size, C.cream);
    const p = this.game ? this.game.position : emptyPosition();
    for (let r = 0; r < 15; r++) for (let c = 0; c < 15; c++) {
      const cr = this.cellRect(r, c); const k = r * 15 + c; const prem = PREMIUM[k];
      if (prem === 'TW') fillRect(ctx, cr.x, cr.y, cr.w, cr.h, C.red);
      else if (prem === 'TL') fillPattern(ctx, cr.x, cr.y, cr.w, cr.h, pattern(ctx, PAT.tl75, C.blue, C.white));
      else if (prem === 'DW') fillPattern(ctx, cr.x, cr.y, cr.w, cr.h, pattern(ctx, PAT.checker, C.red, C.white));
      else if (prem === 'DL') fillPattern(ctx, cr.x, cr.y, cr.w, cr.h, pattern(ctx, PAT.dl25, C.blue, C.white));
      if (k === 112 && !p.letters[112] && !this.staging.has(112)) this.drawStar(ctx, cr);
      if (this.view.labels && prem && !p.letters[k]) { drawTextCentered(ctx, SMALL, prem, cr.x + cr.w / 2, cr.y + 16, prem === 'TW' ? C.white : C.black); }
      const letter = p.letters[k];
      if (letter) this.drawBoardLetter(ctx, cr, letter, !!p.blanks[k], false);
      else if (this.staging.has(k)) { const s = this.staging.get(k); this.drawBoardLetter(ctx, cr, s.letter, s.blank, true); }
    }
    for (let i = 0; i <= 15; i++) { hline(ctx, b.x, b.x + size - 1, b.y + i * b.cell, C.black); vline(ctx, b.x + i * b.cell, b.y, b.y + size - 1, C.black); }
    if (this.view.rowcol) {
      for (let c = 0; c < 15; c++) drawTextCentered(ctx, SYS, String.fromCharCode(65 + c), b.x + 13 + c * b.cell, 54, C.black);
      for (let r = 0; r < 15; r++) drawTextRight(ctx, SYS, String(r + 1), 17, b.y + 18 + r * b.cell, C.black);
    }
    if (this.cursor && this.game && !this.game.finished && this.game.position.side === 0 && !this.thinking) this.drawCursor(ctx, this.cursor);
    if (this.drag && this.drag.x != null) { this.drawTile(ctx, this.drag.x - 13, this.drag.y - 14, this.drag.letter, this.drag.blank, false); }
  }
  drawStar(ctx, cr) {
    // 8x8 five-point star bitmap centered in the square (1-bit, no curves).
    const rows = ['00010000','00010000','00111000','11111110','01111100','00111000','00101000','01000100'];
    const ox = cr.x + Math.round((cr.w - 8) / 2), oy = cr.y + Math.round((cr.h - 8) / 2);
    ctx.fillStyle = C.black;
    rows.forEach((r, y) => { for (let x = 0; x < 8; x++) if (r[x] === '1') ctx.fillRect(ox + x, oy + y, 1, 1); });
  }
  drawBoardLetter(ctx, cr, letter, blank, staged) {
    if (staged) { fillRect(ctx, cr.x + 1, cr.y + 1, cr.w - 2, cr.h - 2, C.white); frameRoundRect(ctx, cr.x + 1, cr.y + 1, cr.w - 2, cr.h - 2, 3, C.black); hline(ctx, cr.x + 3, cr.x + cr.w - 2, cr.y + cr.h - 2, C.dark); vline(ctx, cr.x + cr.w - 2, cr.y + 3, cr.y + cr.h - 2, C.dark); }
    const up = letter.toUpperCase();
    const font = Fonts.get(BOARD_FONT) ? BOARD_FONT : 'Geneva-24';
    // Baseline measured from the emulator: a capital sits with its bottom at
    // cr.y+22 (glyph draws 1px above the passed baseline), horizontally centered.
    drawTextCentered(ctx, font, up, cr.x + 12, cr.y + 23, C.black);
    if (blank) frameRect(ctx, cr.x + 3, cr.y + 2, cr.w - 6, cr.h - 4, C.black);
    // Placed board tiles show the letter only; the point value is not drawn
    // (verified against the emulator). Rack tiles keep their value subscript.
  }
  drawCursor(ctx, cur) {
    const cr = this.cellRect(cur.row, cur.col); const x = cr.x + 3, y = cr.y + 3;
    const right = ['0000001000000', '0000001100000', '1111111110000', '1000000011000', '1111111110000', '0000001100000', '0000001000000'];
    const down = right[0].length; void down;
    const rows = cur.dir === 'across' ? right : transpose(right);
    rows.forEach((row, j) => { for (let i = 0; i < row.length; i++) if (row[i] === '1') { ctx.fillStyle = C.black; ctx.fillRect(x + i, y + j, 1, 1); } });
    // white interior
    if (cur.dir === 'across') { fillRect(ctx, x + 1, y + 3, 8, 1, C.white); }
    else { fillRect(ctx, x + 3, y + 1, 1, 8, C.white); }
  }
  drawUnseen(ctx) {
    const u = L.unseen; fillRect(ctx, u.x, u.y, u.w, u.h, C.white); frameRect(ctx, u.x, u.y, u.w, u.h, C.black);
    const tiles = this.unseenTiles();
    const groups = []; let last = null;
    for (const t of tiles) { if (t === last) groups[groups.length - 1] += t.toUpperCase(); else { groups.push(t.toUpperCase()); last = t; } }
    const lines = []; let line = '';
    for (const gp of groups) { const cand = line ? line + ' ' + gp : gp; if (Fonts.measure(LIST_FONT, cand) > u.w - 34) { lines.push(line); line = gp; } else line = cand; }
    lines.push(line);
    lines.slice(0, 4).forEach((ln, i) => Fonts.draw(ctx, LIST_FONT, ln, u.x + 3, u.y + 10 + i * 10, C.black));
    drawTextRight(ctx, LIST_FONT, String(tiles.length), u.x + u.w - 4, u.y + 10 + Math.min(3, lines.length - 1) * 10, C.black);
  }
  unseenTiles() {
    const p = this.game ? this.game.position : null;
    const counts = { ...TILE_DISTRIBUTION };
    if (p) { for (let i = 0; i < 225; i++) if (p.letters[i]) counts[p.blanks[i] ? '?' : p.letters[i]]--; for (const ch of p.racks[0]) counts[ch]--; }
    let s = ''; for (const k of 'abcdefghijklmnopqrstuvwxyz?') s += k.repeat(Math.max(0, counts[k] || 0));
    return s;
  }
  drawControls(ctx) {
    const enabledPlay = !!this.game && !this.game.finished && this.game.position.side === 0 && !this.thinking && !this.review;
    drawButton(ctx, L.play, 'Play', { enabled: enabledPlay, isDefault: true, pressed: this.pressed === 'play' });
    fillRect(ctx, L.clock.x, L.clock.y, L.clock.w, L.clock.h, C.white); frameRect(ctx, L.clock.x, L.clock.y, L.clock.w, L.clock.h, C.black);
    if (this.view.clock) { const t = this.clockText(); const f = Fonts.get('Geneva-18') ? 'Geneva-18' : SYS; drawTextRight(ctx, f, t, L.clock.x + L.clock.w - 5, L.clock.y + 20, C.black); }
    drawButton(ctx, L.reset, 'Reset', { enabled: this.staging.size > 0 || this.exchangeSel.size > 0, pressed: this.pressed === 'reset' });
  }
  clockText() { const ms = this.clock.base + (this.clock.running ? performance.now() - this.clock.start : 0); const s = Math.floor(ms / 1000); return `${Math.floor(s / 60)}:${String(s % 60).padStart(2, '0')}`; }
  drawTile(ctx, x, y, letter, blank, ghost) {
    // A real Maven tile is a square 26x26 white cell with a black outline and
    // a 1px drop shadow on the right and bottom (measured from the emulator),
    // not a rounded rect. The letter is Geneva 20 with its cap near the top and
    // the point value as a small digit in the bottom-right.
    const w = 26, h = 26;
    if (ghost) { frameRect(ctx, x, y, w, h, C.dark); return; }
    fillRect(ctx, x, y, w, h, C.white);
    frameRect(ctx, x, y, w, h, C.black);
    vline(ctx, x + w, y + 1, y + h, C.black);   // right drop shadow
    hline(ctx, x + 1, x + w, y + h, C.black);    // bottom drop shadow
    const font = Fonts.get(RACK_FONT) ? RACK_FONT : 'Geneva-18';
    const text = blank ? (letter ? letter.toUpperCase() : '') : letter.toUpperCase();
    drawTextCentered(ctx, font, text, x + 10, y + 20, C.black);
    if (this.view.values && !blank) drawTextRight(ctx, SMALL, String(LETTER_VALUES[letter] || 0), x + w - 2, y + h - 2, C.black);
  }
  rackTiles() {
    if (!this.game) return [];
    const rack = this.game.position.racks[0];
    const used = new Map();
    for (const s of this.staging.values()) { const t = s.blank ? '?' : s.letter; used.set(t, (used.get(t) || 0) + 1); }
    const shown = [];
    for (const t of rack) { if (used.get(t)) { used.set(t, used.get(t) - 1); shown.push({ tile: t, placed: true }); } else shown.push({ tile: t, placed: false }); }
    if (this.drag && this.drag.fromRack != null) shown[this.drag.fromRack] = { ...shown[this.drag.fromRack], placed: true };
    return shown;
  }
  drawRack(ctx) {
    const tiles = this.rackTiles();
    tiles.forEach((t, i) => {
      const x = L.rack.x + i * L.rack.pitch, y = L.rack.y;
      if (t.placed || this.exchangeSel.has(i)) this.drawTile(ctx, x, y, t.tile, t.tile === '?', true);
      else if (this.hand === i && !(this.drag && this.drag.moved)) { this.drawTile(ctx, x, y, t.tile, t.tile === '?', true); this.drawTile(ctx, x, y - 6, t.tile === '?' ? '' : t.tile, t.tile === '?', false); }
      else this.drawTile(ctx, x, y, t.tile === '?' ? '' : t.tile, t.tile === '?', false);
    });
  }
  drawScoreBox(ctx) {
    const s = L.score;
    fillRect(ctx, s.x, s.y, s.w, s.h, C.white);
    frameRect(ctx, s.x, s.y, s.w, s.h, C.black); frameRect(ctx, s.x + 1, s.y + 1, s.w - 2, s.h - 2, C.black);
    const p = this.game ? this.game.position : null;
    const names = this.game && this.game.positionOnly ? ['MOVER', 'OPPON'] : [this.names[0] || 'PLAYER', this.names[1]];
    const a = p ? Math.round(p.scores[0]) : 0, b = p ? Math.round(p.scores[1]) : 0;
    fillPattern(ctx, s.x + 100, s.y + 2, 1, s.h - 4, pattern(ctx, PAT.dotted, C.black, null));
    const bold = { bold: true };
    drawTextRight(ctx, LIST_FONT, names[0] + ':', s.x + 60, s.y + 11, C.black, bold); drawTextRight(ctx, LIST_FONT, String(a), s.x + 92, s.y + 11, C.black, bold);
    drawTextRight(ctx, LIST_FONT, names[1] + ':', s.x + 160, s.y + 11, C.black, bold); drawTextRight(ctx, LIST_FONT, String(b), s.x + 192, s.y + 11, C.black, bold);
  }
  drawListArea(ctx) {
    const h = L.listHeader;
    fillPattern(ctx, h.x, h.y, h.w, h.h, pattern(ctx, PAT.checker, C.black, C.white));
    frameRect(ctx, h.x, h.y, h.w, h.h, C.black); frameRect(ctx, h.x + 1, h.y + 1, h.w - 2, h.h - 2, C.black);
    const title = this.list.header; const tw = Fonts.measure(LIST_FONT, title, { bold: true });
    fillRect(ctx, h.x + (h.w - tw) / 2 - 2, h.y + 2, tw + 4, h.h - 4, C.white);
    drawTextCentered(ctx, LIST_FONT, title, h.x + h.w / 2, h.y + 11, C.black, { bold: true });
    // checkbox at left of header toggles history
    fillRect(ctx, h.x + 6, h.y + 3, 9, 9, C.white); frameRect(ctx, h.x + 6, h.y + 3, 9, 9, C.black);
    if (this.list.mode === 'history') { ctx.fillStyle = C.black; for (let i = 0; i < 5; i++) { ctx.fillRect(h.x + 8 + i, h.y + 5 + i, 1, 1); ctx.fillRect(h.x + 12 - i, h.y + 5 + i, 1, 1); } }
    drawList(ctx, L.list, this.list);
  }

  /* ---------- list content ---------- */
  setList(mode, header, rows, columns) {
    this.list.mode = mode; this.list.header = header; this.list.rows = rows; this.list.top = 0; this.list.selected = -1; this.list.columns = null;
    const tabular = mode === 'kibitz' || mode === 'history' || mode === 'review' || mode === 'comparison';
    this.list.font = tabular ? ROW_FONT : LIST_FONT;
    this.list.lineHeight = tabular ? 12 : (mode === 'wordlist' ? 11 : 12);
    this.buildMenus(); this.redraw();
  }
  kibitzRows(ranking) {
    const rows = [];
    const p = this.game ? this.game.position : null; const rack = p ? p.racks[p.side] : '';
    const best = ranking.moves.length ? ranking.moves[0].equity : 0;
    ranking.moves.forEach((m, i) => {
      const label = i === 0 ? 'BEST:' : best - m.equity <= 2 ? 'GOOD:' : 'ALSO:';
      const word = m.exchange ? (m.tiles ? '-' + m.tiles : 'pass') : displayWord(m.word, this.blankMaskFor(m, p));
      const leave = this.leaveAfter(rack, m, p);
      rows.push({ invert: i === 0, seg: [
        { x: COL.label, text: label },
        { x: COL.word, text: word, align: 'right' },
        { x: COL.pos, text: coordText(m) },
        { x: COL.score, text: String(Math.round(m.score)), align: 'right' },
        { x: COL.leave, text: leave },
      ] });
    });
    return rows;
  }
  blankMaskFor(m, p) {
    if (!p || m.exchange) return null;
    const mask = []; let rack = p.racks[p.side].split('');
    for (let i = 0; i < m.word.length; i++) { const r = m.row + (m.vertical ? i : 0), c = m.col + (m.vertical ? 0 : i); const k = r * 15 + c; if (p.letters[k]) { mask.push(!!p.blanks[k]); continue; } const j = rack.indexOf(m.word[i]); if (j >= 0) { rack.splice(j, 1); mask.push(false); } else { const q = rack.indexOf('?'); if (q >= 0) rack.splice(q, 1); mask.push(true); } }
    return mask;
  }
  leaveAfter(rack, m, p) {
    let r = rack.split('');
    if (m.exchange) { for (const t of m.tiles || '') { const j = r.indexOf(t); if (j >= 0) r.splice(j, 1); } return r.join(''); }
    for (let i = 0; i < m.word.length; i++) { const rr = m.row + (m.vertical ? i : 0), c = m.col + (m.vertical ? 0 : i); if (p && p.letters[rr * 15 + c]) continue; const j = r.indexOf(m.word[i]); if (j >= 0) r.splice(j, 1); else { const q = r.indexOf('?'); if (q >= 0) r.splice(q, 1); } }
    return r.join('');
  }
  historyRows() {
    const rows = [];
    if (!this.game) return rows;
    this.game.turns.forEach((t, i) => {
      const side = t.side === 0 ? 'H' : 'M'; const n = t.turnNumber;
      const word = t.exchange ? (t.tiles ? '-' + t.tiles : 'pass') : displayWord(t.word, t.blankMask);
      rows.push({ seg: [
        { x: COL.label, text: side + n },
        { x: COL.word, text: word, align: 'right' },
        { x: COL.pos, text: t.exchange ? '' : coordinateText(t.row, t.col, t.vertical) },
        { x: COL.score, text: String(Math.round(t.score)), align: 'right' },
        { x: COL.total, text: String(Math.round(t.total)), align: 'right' },
      ] });
    });
    if (this.game.finished) rows.push(`END ${this.names[0]} ${Math.round(this.game.position.scores[0])}  ${this.names[1]} ${Math.round(this.game.position.scores[1])}`);
    return rows;
  }
  toggleHistory() { if (this.list.mode === 'history') this.showKibitzList(); else this.setList('history', ' HISTORY ', this.historyRows(), [22, 107]); }
  showKibitzList() { if (this.kibitz) this.setList('kibitz', " KIBITZER'S CHOICES ", this.kibitzRows(this.kibitz), [22, 107]); else this.setList('kibitz', " KIBITZER'S CHOICES ", [], [22, 107]); }
  positionKey() { const p = this.game.position; return p.letters.join(',') + '|' + p.blanks.join('') + '|' + p.racks.join('/') + '|' + p.side; }
  invalidateKibitz() { this.kibitz = null; this.kibitzPositionKey = null; if (this.list.mode === 'kibitz') this.setList('kibitz', " KIBITZER'S CHOICES ", [], [22, 107]); }

  /* ---------- input ---------- */
  mouseDown(x, y, ev) {
    if (this.dialogs.length) { const d = this.dialogs[this.dialogs.length - 1]; const it = d.itemAt(x, y); if (it) { if (it.type === 'list') { this.listClick(d, it, x, y); return; } if (['button', 'default', 'cancel', 'checkbox'].includes(it.type)) { this.pressedItem = it; d.pressed = it; this.redraw(); return; } const r = d.activate(it); if (r != null) this.finishDialog(d, r); this.redraw(); } return; }
    const t = this.menuBar.titleAt(x, y);
    if (t >= 0) { this.menuBar.open = t; this.menuBar.hover = -1; this.menuTracking = true; this.redraw(); return; }
    if (this.menuBar.open >= 0) { const j = this.menuBar.itemAt(x, y); if (j >= 0) this.menuSelect(this.menuBar.open, j); this.menuBar.open = -1; this.redraw(); return; }
    if (!this.windowOpen) return;
    if (this.thinking) return;
    // controls
    if (inRect(x, y, L.play) && this.game && this.game.position.side === 0 && !this.game.finished && !this.review) { this.pressed = 'play'; this.redraw(); return; }
    if (inRect(x, y, L.reset) && (this.staging.size || this.exchangeSel.size)) { this.pressed = 'reset'; this.redraw(); return; }
    // rack
    if (this.game && !this.game.finished && this.game.position.side === 0) {
      for (let i = 0; i < 7; i++) { const r = { x: L.rack.x + i * L.rack.pitch, y: L.rack.y, w: L.rack.w, h: L.rack.h }; if (inRect(x, y, r)) { this.rackDown(i, x, y); return; } }
    }
    // board
    const cell = this.cellAt(x, y);
    if (cell && this.game && this.game.position.side === 0 && !this.game.finished) {
      if (this.hand != null) { const t = this.rackTiles()[this.hand]; this.hand = null; if (t && !t.placed) { this.placeTile(cell.row, cell.col, t.tile); return; } }
      this.boardClick(cell.row, cell.col); return;
    }
    if (this.hand != null) { this.hand = null; this.redraw(); }
    // list
    if (inRect(x, y, L.list)) { const sh = listScrollHit(L.list, this.list, x, y); if (sh) { listScroll(this.list, L.list, sh); this.redraw(); return; } const row = listRowAt(L.list, this.list, x, y); if (row >= 0) this.listRowClicked(row); return; }
    if (inRect(x, y, { x: L.listHeader.x + 4, y: L.listHeader.y + 2, w: 14, h: 12 })) { if (this.game) this.toggleHistory(); return; }
  }
  mouseMove(x, y) {
    if (this.dialogs.length) { const d = this.dialogs[this.dialogs.length - 1]; if (this.pressedItem) { const it = d.itemAt(x, y); d.pressed = it === this.pressedItem ? it : null; this.redraw(); } return; }
    if (this.menuBar.open >= 0) { const t = this.menuBar.titleAt(x, y); if (t >= 0 && t !== this.menuBar.open) { this.menuBar.open = t; } this.menuBar.hover = this.menuBar.itemAt(x, y); this.redraw(); return; }
    if (this.drag) { this.drag.x = x; this.drag.y = y; this.redraw(); }
    if (this.pressed) { const r = this.pressed === 'play' ? L.play : L.reset; const now = inRect(x, y, r) ? this.pressed : null; if (now !== this.pressedShown) { this.pressedShown = now; this.redraw(); } }
  }
  mouseUp(x, y) {
    if (this.dialogs.length) { const d = this.dialogs[this.dialogs.length - 1]; if (this.pressedItem) { const it = d.itemAt(x, y); const target = this.pressedItem; this.pressedItem = null; d.pressed = null; if (it === target) { const r = d.activate(it); if (r != null) this.finishDialog(d, r); } this.redraw(); } return; }
    if (this.menuBar.open >= 0 && this.menuTracking) { this.menuTracking = false; const j = this.menuBar.itemAt(x, y); if (j >= 0) { this.menuSelect(this.menuBar.open, j); this.menuBar.open = -1; } else if (this.menuBar.titleAt(x, y) < 0) this.menuBar.open = -1; this.redraw(); return; }
    if (this.drag) { const d = this.drag; this.drag = null; const cell = this.cellAt(x, y); if (cell && d.moved) { this.hand = null; this.placeTile(cell.row, cell.col, d.tile); } this.redraw(); return; }
    if (this.pressed) { const p = this.pressed; this.pressed = null; const r = p === 'play' ? L.play : L.reset; if (inRect(x, y, r)) { if (p === 'play') this.playPressed(); else this.resetStaging(); } this.redraw(); }
  }
  keyDown(ev) {
    if (this.dialogs.length) { const d = this.dialogs[this.dialogs.length - 1]; const r = d.key(ev); if (r != null) this.finishDialog(d, r); this.redraw(); return true; }
    if (ev.metaKey || ev.ctrlKey) {
      const k = ev.key.toUpperCase();
      for (const m of this.menuBar.menus) for (const it of m.items) if (it.key === k && it.enabled !== false && it.action) { it.action(); return true; }
      return false;
    }
    if (this.menuBar.open >= 0) { if (ev.key === 'Escape') { this.menuBar.open = -1; this.redraw(); } return true; }
    if (this.simulating && ev.key === 'Escape') { this.cancelSimulation(); return true; }
    if (!this.game || this.game.finished || this.game.position.side !== 0 || this.thinking || this.review) return false;
    if (ev.key === 'Enter') { this.playPressed(); return true; }
    if (ev.key === 'Escape') { this.resetStaging(); return true; }
    if (ev.key === 'Backspace') { this.backspace(); return true; }
    if (ev.key === 'ArrowRight' || ev.key === 'ArrowDown' || ev.key === 'ArrowLeft' || ev.key === 'ArrowUp') { this.moveCursor(ev.key); return true; }
    if (/^[a-zA-Z?]$/.test(ev.key)) { this.typeLetter(ev.key.toLowerCase()); return true; }
    return false;
  }
  cellAt(x, y) { const b = L.board; if (x < b.x || y < b.y) return null; const c = Math.floor((x - b.x) / b.cell), r = Math.floor((y - b.y) / b.cell); if (r > 14 || c > 14) return null; return { row: r, col: c }; }
  menuSelect(i, j) { const it = this.menuBar.menus[i].items[j]; if (it && it.enabled !== false && it.action) it.action(); }

  /* ---------- staging tiles ---------- */
  boardClick(row, col) {
    const k = row * 15 + col;
    if (this.game.position.letters[k]) return;
    if (this.staging.has(k)) { this.staging.delete(k); this.cursor = { row, col, dir: this.cursor ? this.cursor.dir : 'across' }; this.redraw(); return; }
    if (this.cursor && this.cursor.row === row && this.cursor.col === col) this.cursor.dir = this.cursor.dir === 'across' ? 'down' : 'across';
    else this.cursor = { row, col, dir: 'across' };
    this.redraw();
  }
  rackDown(i, x, y) {
    const tiles = this.rackTiles(); const t = tiles[i]; if (!t || t.placed) return;
    if (this.hand === i) { this.hand = null; this.toggleExchange(i); return; }
    if (this.exchangeSel.has(i)) { this.exchangeSel.delete(i); this.redraw(); return; }
    this.hand = i;
    this.drag = { fromRack: i, tile: t.tile, letter: t.tile === '?' ? '' : t.tile, blank: t.tile === '?', x: null, y: null, startX: x, startY: y, moved: false };
    const move = (ev) => { const p = this.screen.toLogical(ev.clientX, ev.clientY); if (Math.abs(p.x - x) + Math.abs(p.y - y) > 3) this.drag.moved = true; };
    const up = () => { window.removeEventListener('mousemove', move); window.removeEventListener('mouseup', up); };
    window.addEventListener('mousemove', move); window.addEventListener('mouseup', up);
  }
  toggleExchange(i) { if (this.staging.size) { this.runDialog(ditlDialog(1007, { defaultId: 0 })); return; } if (this.exchangeSel.has(i)) this.exchangeSel.delete(i); else this.exchangeSel.add(i); this.redraw(); }
  async placeTile(row, col, tile) {
    const k = row * 15 + col; if (this.game.position.letters[k] || this.staging.has(k)) { await this.runDialog(ditlDialog(1005, { defaultId: 0 })); return; }
    if (this.exchangeSel.size) { await this.runDialog(ditlDialog(1007, { defaultId: 0 })); return; }
    let letter = tile, blank = false;
    if (tile === '?') { const l = await this.askBlankLetter(); if (!l) return; letter = l; blank = true; }
    this.staging.set(k, { letter, blank }); this.cursor = { row, col, dir: this.cursor ? this.cursor.dir : 'across' }; this.advanceCursor(); this.redraw();
  }
  async askBlankLetter() {
    const d = ditlDialog(1010, { width: 262, height: 160 }); let chosen = null;
    d.onKey = (k) => { if (/^[a-zA-Z]$/.test(k)) { chosen = k.toLowerCase(); return 'ok'; } return null; };
    'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('').forEach((ch, i) => { d.items.push({ id: 'L' + ch, type: 'button', rect: { x: 14 + (i % 9) * 26, y: 74 + Math.floor(i / 9) * 22, w: 22, h: 18 }, text: ch, onClick: () => { chosen = ch.toLowerCase(); } }); });
    d.items.push({ id: 'cancel', type: 'cancel', rect: { x: 190, y: 134, w: 60, h: 18 }, text: 'Cancel' });
    const r = await this.runDialog(d); return r === 'cancel' || r == null ? null : chosen;
  }
  availableTiles() { const rack = this.game.position.racks[0].split(''); for (const s of this.staging.values()) { const t = s.blank ? '?' : s.letter; const j = rack.indexOf(t); if (j >= 0) rack.splice(j, 1); } return rack; }
  async typeLetter(ch) {
    if (!this.cursor) this.cursor = { row: 7, col: 7, dir: 'across' };
    if (this.exchangeSel.size) { await this.runDialog(ditlDialog(1007, { defaultId: 0 })); return; }
    // skip occupied squares
    while (this.cursor && this.game.position.letters[this.cursor.row * 15 + this.cursor.col]) if (!this.advanceCursor()) return;
    if (!this.cursor) return;
    const avail = this.availableTiles(); const k = this.cursor.row * 15 + this.cursor.col;
    if (this.staging.has(k)) return;
    if (ch === '?') { if (!avail.includes('?')) return; const l = await this.askBlankLetter(); if (!l) return; this.staging.set(k, { letter: l, blank: true }); }
    else if (avail.includes(ch)) this.staging.set(k, { letter: ch, blank: false });
    else if (avail.includes('?')) this.staging.set(k, { letter: ch, blank: true });
    else return;
    this.advanceCursor(); this.redraw();
  }
  advanceCursor() {
    const c = this.cursor; if (!c) return false;
    let r = c.row, col = c.col;
    do { if (c.dir === 'across') col++; else r++; if (r > 14 || col > 14) { return false; } } while (this.game.position.letters[r * 15 + col]);
    this.cursor = { row: r, col, dir: c.dir }; return true;
  }
  moveCursor(key) {
    if (!this.cursor) this.cursor = { row: 7, col: 7, dir: 'across' };
    const c = this.cursor;
    if (key === 'ArrowRight') { if (c.dir !== 'across') c.dir = 'across'; else c.col = Math.min(14, c.col + 1); }
    else if (key === 'ArrowDown') { if (c.dir !== 'down') c.dir = 'down'; else c.row = Math.min(14, c.row + 1); }
    else if (key === 'ArrowLeft') c.col = Math.max(0, c.col - 1); else c.row = Math.max(0, c.row - 1);
    this.redraw();
  }
  backspace() {
    if (!this.staging.size) return;
    // remove the most recently staged tile before the cursor along its line
    const keys = [...this.staging.keys()]; const last = keys[keys.length - 1];
    this.staging.delete(last); this.cursor = { row: Math.floor(last / 15), col: last % 15, dir: this.cursor ? this.cursor.dir : 'across' }; this.redraw();
  }
  resetStaging() { this.staging.clear(); this.exchangeSel.clear(); this.hand = null; this.redraw(); }

  /* ---------- committing a human turn ---------- */
  async playPressed() {
    if (!this.game || this.game.finished || this.game.position.side !== 0 || this.thinking) return;
    if (this.exchangeSel.size && this.staging.size) { await this.runDialog(ditlDialog(1007, { defaultId: 0 })); return; }
    if (this.exchangeSel.size) { const rack = this.game.position.racks[0]; const tiles = [...this.exchangeSel].map(i => rack[i]).join(''); if (this.unseenTiles().length - this.game.position.racks[1].length < 7 && this.unseenTiles().length < 7) { await this.runDialog(alertDialog('There are fewer than seven tiles in the bag, so tiles cannot be exchanged.', [{ text: 'OK', id: 'ok', default: true }])); return; } await this.commitExchange(tiles); return; }
    if (!this.staging.size) { const r = await this.runDialog(ditlDialog(1008, { defaultId: 0, cancelId: 0 })); if (r === 1) await this.commitExchange(''); return; }
    const mv = this.resolveStaging();
    if (mv.error) { await this.runDialog(ditlDialog(mv.error, { defaultId: 0 })); return; }
    const words = [mv.word, ...mv.crossWords];
    const ok = await this.engine.request('wordsAcceptable', { words: words.map(w => w.toLowerCase()) });
    const bad = words.filter((w, i) => !ok[i]);
    if (bad.length) {
      const r = await this.runDialog(ditlDialog(1019, { sub: [bad[0].toUpperCase()], defaultId: 0, cancelId: 0 }));
      if (r === 0 || r == null) return;
      if (r === 2) { await this.commitExchange(''); return; }
    }
    await this.commitMove(mv);
  }
  resolveStaging() {
    const p = this.game.position; const cells = [...this.staging.keys()].sort((a, b) => a - b);
    const rows = new Set(cells.map(k => Math.floor(k / 15))), cols = new Set(cells.map(k => k % 15));
    if (rows.size > 1 && cols.size > 1) return { error: 1004 };
    const occupied = k => p.letters[k] || this.staging.has(k);
    const letterAt = k => p.letters[k] || this.staging.get(k).letter;
    let vertical = rows.size > 1 || (cells.length === 1 && cols.size === 1 && rows.size === 1 && this.isVerticalSingle(cells[0]));
    const r0 = Math.floor(cells[0] / 15), c0 = cells[0] % 15;
    // contiguity along the line
    const first = cells[0], last = cells[cells.length - 1]; const step = vertical ? 15 : 1;
    for (let k = first; k <= last; k += step) if (!occupied(k)) return { error: 1003 };
    // extend to full word
    let start = first; while ((vertical ? start >= 15 : start % 15 > 0) && occupied(start - step)) start -= step;
    let end = last; while ((vertical ? end + 15 < 225 : end % 15 < 14) && occupied(end + step)) end += step;
    let word = '', newTile = [], blank = [];
    for (let k = start; k <= end; k += step) { word += letterAt(k); newTile.push(this.staging.has(k)); blank.push(this.staging.has(k) ? !!this.staging.get(k).blank : !!p.blanks[k]); }
    const boardEmpty = !p.letters.some(Boolean);
    if (boardEmpty) { if (!this.staging.has(112)) return { error: 1001 }; if (cells.length === 1) return { error: 1003 }; }
    else {
      // must touch existing tiles: either the main word contains existing letters or a cross word exists
      let touches = false;
      for (let k = start; k <= end; k += step) if (p.letters[k]) touches = true;
      const crossWords = [];
      for (const k of cells) { const cw = this.crossWordAt(k, vertical, letterAt); if (cw) { crossWords.push(cw); touches = true; } }
      if (!touches) return { error: 1002 };
      if (word.length < 2) return { error: 1003 };
      return { word, row: Math.floor(start / 15), col: start % 15, vertical, newTile, blank, crossWords };
    }
    const crossWords = [];
    return { word, row: Math.floor(start / 15), col: start % 15, vertical, newTile, blank, crossWords };
  }
  isVerticalSingle(k) {
    const p = this.game.position; const r = Math.floor(k / 15), c = k % 15;
    const h = (c > 0 && p.letters[k - 1]) || (c < 14 && p.letters[k + 1]);
    const v = (r > 0 && p.letters[k - 15]) || (r < 14 && p.letters[k + 15]);
    if (h) return false; if (v) return true; return this.cursor && this.cursor.dir === 'down';
  }
  crossWordAt(k, vertical, letterAt) {
    const p = this.game.position; const step = vertical ? 1 : 15; const r = Math.floor(k / 15), c = k % 15;
    const canBack = kk => vertical ? kk % 15 > 0 : kk >= 15; const canFwd = kk => vertical ? kk % 15 < 14 : kk + 15 < 225;
    let s = k; while (canBack(s) && p.letters[s - step]) s -= step;
    let e = k; while (canFwd(e) && p.letters[e + step]) e += step;
    if (s === e) return null;
    let w = ''; for (let kk = s; kk <= e; kk += step) w += kk === k ? letterAt(k) : p.letters[kk];
    return w;
  }
  async commitMove(mv) {
    this.staging.clear(); this.exchangeSel.clear();
    const before = positionToWire(this.game.position);
    // Kibitz for comparison, as the original does before it lets you play
    const res = await this.engine.request('playMove', { word: mv.word, row: mv.row, col: mv.col, vertical: mv.vertical, newTile: mv.newTile, blank: mv.blank });
    if (res.status !== 0) { await this.runDialog(alertDialog('Maven could not play that move (engine status ' + res.status + ').', [{ text: 'OK', id: 'ok', default: true }], { icon: 'stop' })); return; }
    this.afterPlay(res, { side: 0, word: mv.word, row: mv.row, col: mv.col, vertical: mv.vertical, blankMask: mv.blank, exchange: false, score: res.result.move.score, before });
    await this.afterHumanTurn();
  }
  async commitExchange(tiles) {
    this.staging.clear(); this.exchangeSel.clear();
    const before = positionToWire(this.game.position);
    const res = await this.engine.request('playExchange', { tiles });
    if (res.status !== 0) { await this.runDialog(alertDialog(res.status === 5 ? 'There are not enough tiles in the bag to exchange.' : 'Maven could not exchange those tiles (status ' + res.status + ').', [{ text: 'OK', id: 'ok', default: true }], { icon: 'stop' })); return; }
    this.afterPlay(res, { side: 0, exchange: true, tiles, score: 0, before });
    await this.afterHumanTurn();
  }
  afterPlay(res, turn) {
    const g = this.game; const side = turn.side;
    g.position = res.position; g.engineHistory = res.history; g.dirty = true; g.started = true;
    const total = g.position.scores[side];
    g.turns.push({ ...turn, total, turnNumber: g.turns.filter(t => t.side === side).length + 1, recordIndex: res.history - 1, phase: res.result.phase });
    g.finished = res.result.phase === 5 || g.position.side === 2;
    this.cursor = null; this.invalidateKibitz();
    if (this.list.mode === 'history') this.setList('history', ' HISTORY ', this.historyRows(), [22, 107]);
    this.autosave(); this.buildMenus(); this.redraw();
  }
  async afterHumanTurn() {
    if (this.game.finished) { await this.gameOver(); return; }
    await this.mavenTurn();
  }
  async mavenTurn() {
    const g = this.game; if (!g || g.finished || g.position.side !== 1) return;
    this.thinking = true; this.startClock(); this.buildMenus(); this.redraw();
    try {
      const k = await this.engine.request('move', { endgame: this.analyzers.end, late: this.analyzers.late, budget: 120 });
      if (k.status !== 0) throw new Error('search status ' + k.status);
      this.kibitz = k.ranking; this.kibitzSide = 1; const rowsBefore = this.kibitzRows(k.ranking);
      if (!k.ranking.count) { const res = await this.engine.request('playExchange', { tiles: '' }); this.afterPlay(res, { side: 1, exchange: true, tiles: '', score: 0 }); await this.runDialog(ditlDialog(1000, { sub: ['0'], defaultId: 0 })); }
      else {
        const res = await this.engine.request('playRanked', { index: 0 });
        if (res.status !== 0) throw new Error('play status ' + res.status);
        const m = res.result.move;
        const before = g.position;
        this.afterPlay(res, m.exchange ? { side: 1, exchange: true, tiles: m.tiles, score: 0 } : { side: 1, word: m.word, row: m.row, col: m.col, vertical: m.vertical, blankMask: this.blankMaskFor(m, before), exchange: false, score: m.score });
        this.lastMavenMove = m;
        if (this.list.mode === 'kibitz') this.setList('kibitz', " KIBITZER'S CHOICES ", rowsBefore, [22, 107]);
        if (m.exchange) await this.runDialog(ditlDialog(1000, { sub: [String((m.tiles || '').length)], defaultId: 0 }));
      }
    } catch (e) { await this.runDialog(alertDialog('Maven could not move: ' + e.message, [{ text: 'OK', id: 'ok', default: true }], { icon: 'stop' })); }
    this.thinking = false; this.stopClock(); this.resetClock(); this.buildMenus(); this.redraw();
    if (this.game.finished) await this.gameOver();
  }
  async gameOver() {
    this.stopClock(); this.setList('history', ' HISTORY ', this.historyRows(), [22, 107]);
    const p = this.game.position; const a = Math.round(p.scores[0]), b = Math.round(p.scores[1]);
    await this.runDialog(alertDialog(`The game is over.\r${this.names[0]} ${a}, ${this.names[1]} ${b}.`, [{ text: 'OK', id: 'ok', default: true }], { icon: 'note' }));
    localStorage.removeItem('maven.autosave'); this.buildMenus(); this.redraw();
  }
  startClock() { this.clock.running = true; this.clock.start = performance.now(); }
  stopClock() { if (this.clock.running) { this.clock.base += performance.now() - this.clock.start; this.clock.running = false; } }
  resetClock() { this.clock.base = 0; }

  /* ---------- commands ---------- */
  async confirmDiscard(ditlId) {
    if (!this.game || !this.game.dirty || this.game.finished) return true;
    const r = await this.runDialog(ditlDialog(ditlId, { defaultId: 0, cancelId: 4 }));
    if (r === 0) { await this.save(false); return true; }
    return r === 1;
  }
  async newGame() {
    if (!(await this.confirmDiscard(1025))) return;
    this.review = null; this.windowOpen = true;
    const first = (JSON.parse(localStorage.getItem('maven.games') || '0') % 2);
    localStorage.setItem('maven.games', JSON.stringify((JSON.parse(localStorage.getItem('maven.games') || '0') + 1)));
    await this.engine.request('levelReset', {});
    const res = await this.engine.request('deal', { firstSide: first });
    if (res.status !== 0) { await this.runDialog(alertDialog('Could not start a game (status ' + res.status + ').', [{ text: 'OK', id: 'ok', default: true }], { icon: 'stop' })); return; }
    this.game = { position: res.position, turns: [], started: true, finished: false, dirty: false, fileName: null, engineHistory: 0 };
    this.staging.clear(); this.exchangeSel.clear(); this.cursor = { row: 7, col: 7, dir: 'across' }; this.invalidateKibitz(); this.resetClock();
    this.setList('kibitz', " KIBITZER'S CHOICES ", [], [22, 107]); this.buildMenus(); this.redraw();
    if (res.position.side === 1) await this.mavenTurn();
  }
  async closeWindow() { if (!(await this.confirmDiscard(1026))) return; this.windowOpen = false; this.game = null; this.review = null; localStorage.removeItem('maven.autosave'); this.buildMenus(); this.redraw(); }
  async quit() { if (!(await this.confirmDiscard(1027))) return; this.windowOpen = false; this.game = null; localStorage.removeItem('maven.autosave'); this.buildMenus(); this.redraw(); await this.runDialog(alertDialog('Maven has quit.  Reload the page to start again.', [{ text: 'OK', id: 'ok', default: true }], { icon: 'note' })); }
  async doKibitz() {
    if (!this.game || this.thinking) return;
    const key = this.positionKey();
    if (this.kibitz && this.kibitzPositionKey === key) { this.showKibitzList(); return; }
    this.thinking = true; this.status = 'Kibitzing…'; this.startClock(); this.buildMenus(); this.redraw();
    try {
      const k = await this.engine.request('kibitz', { endgame: this.analyzers.end, late: this.analyzers.late, budget: 120 });
      if (k.status !== 0) throw new Error('status ' + k.status);
      this.kibitz = k.ranking; this.kibitzPositionKey = key; this.showKibitzList();
    } catch (e) { await this.runDialog(alertDialog('Kibitz failed: ' + e.message, [{ text: 'OK', id: 'ok', default: true }], { icon: 'stop' })); }
    this.thinking = false; this.status = ''; this.stopClock(); this.resetClock(); this.buildMenus(); this.redraw();
  }
  async listRowClicked(row) {
    this.list.selected = row; this.redraw();
    if (this.list.mode === 'kibitz' && this.kibitz && this.game && this.kibitzPositionKey === this.positionKey() && this.game.position.side === 0 && !this.game.finished && !this.review) {
      // stage the chosen move on the board
      const m = this.kibitz.moves[row]; if (!m) return;
      this.staging.clear(); this.exchangeSel.clear();
      if (m.exchange) { const rack = this.game.position.racks[0]; const used = new Map(); for (const t of m.tiles || '') { let idx = -1; for (let i = 0; i < rack.length; i++) if (rack[i] === t && !used.get(i)) { idx = i; break; } if (idx >= 0) { used.set(idx, true); this.exchangeSel.add(idx); } } }
      else { const mask = this.blankMaskFor(m, this.game.position); for (let i = 0; i < m.word.length; i++) { const r = m.row + (m.vertical ? i : 0), c = m.col + (m.vertical ? 0 : i); const k = r * 15 + c; if (!this.game.position.letters[k]) this.staging.set(k, { letter: m.word[i], blank: mask[i] }); } }
      this.redraw();
    } else if (this.list.mode === 'review' && this.review) { await this.reviewSelect(row); }
  }
  async undo() {
    const g = this.game; if (!g || !g.turns.length || this.thinking) return;
    // Undo back to the human's previous decision: the record of the last human turn.
    let idx = g.turns.length - 1; while (idx > 0 && g.turns[idx].side !== 0) idx--;
    const turn = g.turns[idx];
    const res = await this.engine.request('historySelect', { index: turn.recordIndex });
    if (res.status !== 0) { await this.runDialog(alertDialog('Cannot undo (status ' + res.status + ').', [{ text: 'OK', id: 'ok', default: true }], { icon: 'stop' })); return; }
    g.position = res.position; g.turns = g.turns.slice(0, idx); g.finished = false; g.dirty = true; g.engineHistory = res.history;
    this.staging.clear(); this.exchangeSel.clear(); this.invalidateKibitz(); this.autosave();
    if (this.list.mode === 'history') this.setList('history', ' HISTORY ', this.historyRows(), [22, 107]);
    this.buildMenus(); this.redraw();
    if (g.position.side === 1) await this.mavenTurn();
  }
  async save(as) {
    if (!this.game) return;
    let name = this.game.fileName;
    if (as || !name) { const d = promptDialog('Save game as:', name || 'Maven Game', { maxLength: 31 }); const r = await this.runDialog(d); if (r !== 'ok') return; name = d.items.find(i => i.type === 'edit').text.trim() || 'Maven Game'; }
    const wire = await this.engine.request('save');
    downloadBytes(new Uint8Array(wire), name.endsWith('.maven') ? name : name + '.maven');
    this.game.fileName = name; this.game.dirty = false; this.buildMenus(); this.redraw();
  }
  exportGCG() {
    const g = this.game; if (!g) return;
    const lines = [`#character-encoding UTF-8`, `#player1 ${this.names[0]} ${this.names[0]}`, `#player2 ${this.names[1]} ${this.names[1]}`, `#lexicon ${this.dictionary}`];
    for (const t of g.turns) {
      const nick = this.names[t.side]; const rack = (t.before ? t.before.racks[t.side] : '').toUpperCase();
      if (t.exchange) lines.push(`>${nick}: ${rack} ${t.tiles ? '-' + t.tiles.toUpperCase() : '-'} +0 ${Math.round(t.total)}`);
      else { let w = ''; for (let i = 0; i < t.word.length; i++) { const r = t.row + (t.vertical ? i : 0), c = t.col + (t.vertical ? 0 : i); const wasThere = t.before && t.before.letters[r * 15 + c]; w += wasThere ? '.' : (t.blankMask && t.blankMask[i] ? t.word[i].toLowerCase() : t.word[i].toUpperCase()); } lines.push(`>${nick}: ${rack} ${coordinateText(t.row, t.col, t.vertical)} ${w} +${Math.round(t.score)} ${Math.round(t.total)}`); }
    }
    downloadBytes(new TextEncoder().encode(lines.join('\n') + '\n'), (g.fileName || 'Maven Game') + '.gcg');
  }
  async openFile() {
    if (!(await this.confirmDiscard(1026))) return;
    const files = await pickFiles(false); if (!files.length) return;
    const f = files[0]; const bytes = new Uint8Array(await f.arrayBuffer());
    await this.openBytes(bytes, f.name);
  }
  async openBytes(bytes, name) {
    const head = new TextDecoder().decode(bytes.subarray(0, Math.min(bytes.length, 4000)));
    if (/^\s*(#|>)/.test(head)) { await this.openGCGText(new TextDecoder().decode(bytes), name); return; }
    if (/^[0-9A-Za-z\/]+\s+[A-Za-z?]*\/[A-Za-z?]*\s+\d+\/\d+/.test(head.trim())) { await this.openCGP(head.trim().split('\n')[0]); return; }
    // original Maven save file
    const res = await this.engine.request('load', { wire: bytes }, [bytes.buffer]);
    if (res.status !== 0) { await this.runDialog(alertDialog('That file is not a Maven game, a GCG game or a CGP position.', [{ text: 'OK', id: 'ok', default: true }], { icon: 'stop' })); return; }
    this.review = null; this.windowOpen = true;
    this.game = { position: res.position, turns: [], started: true, finished: res.position.side === 2, dirty: false, fileName: name.replace(/\.maven$/, ''), engineHistory: res.history, positionOnly: false };
    this.staging.clear(); this.exchangeSel.clear(); this.cursor = { row: 7, col: 7, dir: 'across' }; this.invalidateKibitz();
    this.setList('kibitz', " KIBITZER'S CHOICES ", [], [22, 107]); this.buildMenus(); this.redraw();
    if (this.game.position.side === 1 && !this.game.finished) await this.mavenTurn();
  }
  async openGCGText(text, name) {
    let game;
    try { game = parseGCG(text); } catch (e) { await this.runDialog(alertDialog('Cannot read that GCG file: ' + e.message, [{ text: 'OK', id: 'ok', default: true }], { icon: 'stop' })); return; }
    if (!game.turns.length) { await this.runDialog(alertDialog('That game has no turns.', [{ text: 'OK', id: 'ok', default: true }], { icon: 'stop' })); return; }
    this.review = { game, title: (game.players[0].nick + ' vs ' + game.players[1].nick).slice(0, 40), name, index: -1 };
    this.windowOpen = true; this.game = { position: emptyPosition(), turns: [], started: true, finished: false, dirty: false, fileName: name, engineHistory: 0, positionOnly: true };
    const initials = game.players.map((p, i) => (p.nick || String(i + 1)).charAt(0).toUpperCase());
    const rows = game.turns.map((t, i) => { const who = initials[t.player]; const w = t.type === 'play' ? t.word : t.type === 'exchange' ? '-' + (t.tiles || t.exchangeCount || '') : t.type === 'pass' ? 'pass' : t.type.replace('_', ' '); return who + pad(String(i + 1), 2) + ' ' + pad(w.slice(0, 8), 8) + ' ' + pad(t.type === 'play' ? formatCoordinate(t.row, t.col, t.vertical) : '', 3) + fmt(Math.round(t.score), 3) + ' ' + fmt(t.cumulative[t.player], 4); });
    this.setList('review', ' HISTORY ', rows, [22, 107]);
    let last = game.turns.length - 1; while (last > 0 && game.turns[last].type !== 'play' && game.turns[last].type !== 'exchange' && game.turns[last].type !== 'pass') last--;
    await this.reviewSelect(last, false);
    await this.runDialog(alertDialog(`Loaded ${game.players[0].nick} vs ${game.players[1].nick} (${game.turns.length} turns).  Click a turn to see the position before it; use Kibitz or Simulate to analyze, or Play From Here to continue against Maven.`, [{ text: 'OK', id: 'ok', default: true }], { icon: 'note', width: 380 }));
  }
  async reviewSelect(row, after = false) {
    const rv = this.review; if (!rv) return;
    const pos = after ? positionAfter(rv.game, row) : positionBefore(rv.game, row);
    rv.index = row; this.list.selected = row;
    const p = { letters: pos.board.map(x => x || ''), blanks: Array.from(pos.blanks), racks: [pos.racks[0] || '', pos.racks[1] || ''], scores: pos.scores.slice(), zero: pos.zeroTurns || 0, side: 0 };
    // The engine's position puts the mover in rack 0. Unknown racks are filled from the unseen pool.
    const mover = pos.side; const other = 1 - mover;
    let r0 = (pos.racks[mover] || '').toLowerCase().replace(/[^a-z?]/g, ''), r1 = (pos.racks[other] || '').toLowerCase().replace(/[^a-z?]/g, '');
    const unseen = this.unseenFrom(p.letters, p.blanks, r0);
    if (!r0) { r0 = unseen.slice(0, 7).join(''); }
    if (!r1) { const pool = removeTiles(unseen, r0 ? [] : r0.split('')); r1 = shuffle(pool).slice(0, 7).join(''); }
    p.racks = [r0, r1]; p.scores = [pos.scores[mover], pos.scores[other]];
    this.reviewSides = { mover, names: [rv.game.players[mover].nick.toUpperCase().slice(0, 6), rv.game.players[other].nick.toUpperCase().slice(0, 6)] };
    this.names = this.reviewSides.names;
    this.game.position = p; this.game.positionOnly = false; this.invalidateKibitz(); this.list.mode = 'review'; this.reviewAnalyzable = false;
    if (r0 && r1) {
      const status = await this.engine.request('setPosition', { position: p });
      if (status === 0) this.reviewAnalyzable = true;
      else await this.runDialog(alertDialog('Maven cannot analyze this position (status ' + status + ').', [{ text: 'OK', id: 'ok', default: true }], { icon: 'stop' }));
    }
    this.buildMenus(); this.redraw();
  }
  unseenFrom(letters, blanks, rack) {
    const counts = { ...TILE_DISTRIBUTION };
    for (let i = 0; i < 225; i++) if (letters[i]) counts[blanks[i] ? '?' : letters[i]]--;
    for (const ch of rack) counts[ch]--;
    const out = []; for (const k of 'abcdefghijklmnopqrstuvwxyz?') for (let i = 0; i < (counts[k] || 0); i++) out.push(k);
    return out;
  }
  async openCGP(cgp) {
    let pos; try { pos = parseCGP(cgp); } catch (e) { await this.runDialog(alertDialog('That is not a CGP position.', [{ text: 'OK', id: 'ok', default: true }], { icon: 'stop' })); return; }
    const p = { letters: pos.board.map(x => x || ''), blanks: Array.from(pos.blanks), racks: [pos.racks[0].toLowerCase(), pos.racks[1].toLowerCase()], scores: pos.scores.slice(), zero: pos.zeroTurns || 0, side: 0 };
    if (!p.racks[1]) p.racks[1] = shuffle(this.unseenFrom(p.letters, p.blanks, p.racks[0])).slice(0, 7).join('');
    const status = await this.engine.request('setPosition', { position: p });
    if (status !== 0) { await this.runDialog(alertDialog('Maven cannot use that position (status ' + status + ').', [{ text: 'OK', id: 'ok', default: true }], { icon: 'stop' })); return; }
    this.review = null; this.windowOpen = true;
    this.game = { position: p, turns: [], started: true, finished: false, dirty: false, fileName: 'Position', engineHistory: 0, positionOnly: true };
    this.staging.clear(); this.exchangeSel.clear(); this.cursor = { row: 7, col: 7, dir: 'across' }; this.invalidateKibitz();
    this.setList('kibitz', " KIBITZER'S CHOICES ", [], [22, 107]); this.buildMenus(); this.redraw();
  }
  async pastePosition() {
    let text = '';
    try { text = await navigator.clipboard.readText(); } catch (e) { const d = promptDialog('Paste a CGP position or GCG game:', '', { width: 420 }); const r = await this.runDialog(d); if (r !== 'ok') return; text = d.items.find(i => i.type === 'edit').text; }
    text = text.trim(); if (!text) return;
    if (/^\s*(#|>)/.test(text)) await this.openGCGText(text, 'pasted game'); else await this.openCGP(text.split('\n')[0]);
  }
  async copyCGP() { if (!this.game) return; const cgp = toCGP({ board: this.game.position.letters, blanks: this.game.position.blanks, racks: this.game.position.racks.map(r => r.toUpperCase()), scores: this.game.position.scores, zeroTurns: this.game.position.zero }); try { await navigator.clipboard.writeText(cgp); } catch (e) { await this.runDialog(promptDialog('Copy this position:', cgp, { width: 420, okText: 'Done' })); } }
  async alterPosition() {
    const p = this.game ? this.game.position : emptyPosition();
    const d = new Dialog([
      { type: 'static', rect: { x: 16, y: 12, w: 260, h: 16 }, text: 'Change Racks And Scores', font: SYS },
      { type: 'static', rect: { x: 16, y: 40, w: 90, h: 16 }, text: 'Your rack:', font: SYS }, { id: 'r0', type: 'edit', rect: { x: 110, y: 40, w: 90, h: 16 }, text: p.racks[0].toUpperCase(), upper: true, maxLength: 7, filter: c => /[A-Za-z?]/.test(c) },
      { type: 'static', rect: { x: 16, y: 64, w: 90, h: 16 }, text: "Maven's rack:", font: SYS }, { id: 'r1', type: 'edit', rect: { x: 110, y: 64, w: 90, h: 16 }, text: p.racks[1].toUpperCase(), upper: true, maxLength: 7, filter: c => /[A-Za-z?]/.test(c) },
      { type: 'static', rect: { x: 16, y: 88, w: 90, h: 16 }, text: 'Your score:', font: SYS }, { id: 's0', type: 'edit', rect: { x: 110, y: 88, w: 50, h: 16 }, text: String(Math.round(p.scores[0])), maxLength: 4, filter: c => /\d/.test(c) },
      { type: 'static', rect: { x: 16, y: 112, w: 90, h: 16 }, text: "Maven's score:", font: SYS }, { id: 's1', type: 'edit', rect: { x: 110, y: 112, w: 50, h: 16 }, text: String(Math.round(p.scores[1])), maxLength: 4, filter: c => /\d/.test(c) },
      { id: 'side0', type: 'radio', group: 'side', rect: { x: 16, y: 140, w: 120, h: 16 }, text: 'Your move', value: p.side === 0 }, { id: 'side1', type: 'radio', group: 'side', rect: { x: 150, y: 140, w: 120, h: 16 }, text: "Maven's move", value: p.side === 1 },
      { id: 'ok', type: 'default', rect: { x: 220, y: 170, w: 64, h: 20 }, text: 'OK' }, { id: 'cancel', type: 'cancel', rect: { x: 140, y: 170, w: 64, h: 20 }, text: 'Cancel' },
    ], { width: 300, height: 204 });
    const r = await this.runDialog(d); if (r !== 'ok') return;
    const get = id => d.items.find(i => i.id === id);
    const np = { letters: p.letters.slice(), blanks: Array.from(p.blanks), racks: [get('r0').text.toLowerCase(), get('r1').text.toLowerCase()], scores: [+get('s0').text || 0, +get('s1').text || 0], zero: p.zero || 0, side: get('side1').value ? 1 : 0 };
    const status = await this.engine.request('setPosition', { position: np });
    if (status !== 0) { await this.runDialog(alertDialog('Maven cannot use that position: the racks must be 1 to 7 tiles each and fit the tile inventory.', [{ text: 'OK', id: 'ok', default: true }], { icon: 'stop' })); return; }
    if (!this.game) { this.game = { position: np, turns: [], started: true, finished: false, dirty: true, fileName: 'Changed Position', engineHistory: 0, positionOnly: true }; }
    else { this.game.position = np; this.game.fileName = this.game.fileName || 'Changed Position'; this.game.dirty = true; }
    this.review = null; this.windowOpen = true; this.staging.clear(); this.exchangeSel.clear(); this.invalidateKibitz(); this.buildMenus(); this.redraw();
    if (np.side === 1) await this.mavenTurn();
  }
  async changeTileOrder() {
    if (!this.game) return;
    const d = ditlDialog(1022, { defaultId: 0, cancelId: 3, edits: { 1: this.game.position.racks[0].toUpperCase() } });
    const r = await this.runDialog(d); if (r !== 0) return;
    const text = d.items.find(i => i.type === 'edit').text.toLowerCase().replace(/[^a-z?]/g, '');
    const rack = this.game.position.racks[0];
    if (text.split('').sort().join('') !== rack.split('').sort().join('')) { await this.runDialog(alertDialog('That is not the same set of tiles.', [{ text: 'OK', id: 'ok', default: true }])); return; }
    this.game.position.racks[0] = text; this.redraw();
  }
  compareToBest() { if (this.game && this.game.lastComparison) this.setList('comparison', ' MOVE COMPARISON ', this.game.lastComparison, [22, 107]); }
  async wordListDialog() {
    const rack = this.game ? this.game.position.racks[0].toUpperCase() : '';
    const d = ditlDialog(1014, { defaultId: 0, edits: { 1: rack }, hide: [14, 15], width: 210, height: 152 });
    d.items.push({ id: 'cancel', type: 'cancel', rect: { x: 5, y: 8, w: 0, h: 0 }, text: '' });
    for (const it of d.items) if (it.type === 'edit') { it.upper = true; it.font = 'Geneva-12'; }
    const r = await this.runDialog(d); if (r == null || r === 'cancel') return;
    const get = idx => (d.items.find(i => i.id === idx) || {}).text || '';
    const q = { rack: get(1).toLowerCase().replace(/[^a-z?]/g, ''), onBoard: get(2).toLowerCase().replace(/[^a-z]/g, ''), prefix: get(3).toLowerCase().replace(/[^a-z]/g, ''), suffix: get(4).toLowerCase().replace(/[^a-z]/g, ''), bingos: r === 9, min: +get(10) || 0, max: +get(12) || 0 };
    this.status = 'Building word list…'; this.redraw();
    const res = await this.engine.request('wordList', q);
    this.status = '';
    const rows = res.words.map(w => w.toUpperCase()); rows.push(` ${res.count} words.`);
    this.setList('wordlist', ' WORD LIST ', rows, null);
  }
  async simulateDialog() {
    if (!this.game || this.thinking || this.simulating) return;
    if (!this.kibitz || this.kibitzPositionKey !== this.positionKey()) await this.doKibitz();
    if (!this.kibitz || !this.kibitz.count) return;
    const s = this.simSettings || (this.simSettings = { lookahead: 1, record: false, end: this.analyzers.end, late: this.analyzers.late, exhaustive: false, display: true });
    const d = ditlDialog(1015, { defaultId: 0, cancelId: 10, edits: { 4: String(s.lookahead) }, checks: { 1: s.record, 2: s.end, 3: s.late, 7: s.exhaustive, 9: s.display } });
    d.items.find(i => i.id === 4).filter = c => /\d/.test(c); d.items.find(i => i.id === 4).maxLength = 2;
    d.items.find(i => i.id === 5).onClick = () => { for (const it of d.items) { if (it.id === 4) it.text = '1'; if (it.type === 'checkbox') it.value = it.id === 2 || it.id === 3 || it.id === 9; } return false; };
    const r = await this.runDialog(d); if (r !== 0) return;
    const get = id => d.items.find(i => i.id === id);
    Object.assign(s, { lookahead: Math.max(1, +get(4).text || 1), record: get(1).value, end: get(2).value, late: get(3).value, exhaustive: get(7).value, display: get(9).value });
    this.analyzers.end = s.end; this.analyzers.late = s.late; this.savePrefs();
    await this.runSimulation(s);
  }
  async runSimulation(s) {
    this.simulating = true; this.simProgress = null; this.simPublications = 0; this.simLog = []; this.buildMenus();
    this.setList('simulation', ' SIMULATION OPTIONS ', ['Simulating… press Escape to stop.'], null);
    this.status = this.cancelFlag ? 'Simulating (Esc stops)' : 'Simulating (limited samples)'; this.startClock(); this.redraw();
    try {
      const sampleLimit = this.cancelFlag ? 200000000 : 300;
      const res = await this.engine.request('simulate', { lookahead: s.lookahead, exhaustive: s.exhaustive, late: s.late, endgame: s.end, sampleLimit, budget: 120 });
      if (res.status !== 0 && res.status !== 6) throw new Error('status ' + res.status);
      this.kibitz = res.ranking; this.kibitzPositionKey = this.positionKey();
      const rows = this.simulationRows(res.entries, res.batches);
      this.setList('simulation', ' SIMULATION OPTIONS ', rows, null);
      if (s.record) downloadBytes(new TextEncoder().encode(['Simulation Log', ...rows].join('\n') + '\n'), 'Simulation Log.txt');
    } catch (e) { await this.runDialog(alertDialog('Simulation failed: ' + e.message, [{ text: 'OK', id: 'ok', default: true }], { icon: 'stop' })); }
    this.simulating = false; this.status = ''; this.stopClock(); this.resetClock(); this.buildMenus(); this.redraw();
  }
  simRow(best, word, pos, equity) {
    // '%5s %8w %*P %5.1T points' -> label, word(right), pos, equity(tenths, right), 'points'
    return { invert: best, seg: [
      { x: COL.label, text: best ? 'BEST:' : 'ALSO:' },
      { x: COL.word, text: word, align: 'right' },
      { x: COL.pos, text: pos },
      { x: COL.score, text: equity.toFixed(1), align: 'right' },
      { x: COL.leave, text: 'points' },
    ] };
  }
  simulationRows(entries, batches) {
    const rows = [`b ${batches} ITERATIONS`];
    const sorted = entries.slice().sort((a, b) => (b.total / Math.max(1, b.samples)) - (a.total / Math.max(1, a.samples)));
    sorted.forEach((e, i) => { const avg = e.total / Math.max(1, e.samples) / 100; const pos = e.row ? coordinateText(e.row > 15 ? e.col - 1 : e.row - 1, e.row > 15 ? e.row - 16 : e.col - 1, e.row > 15) : ''; rows.push(this.simRow(i === 0, e.word || (e.row ? '' : 'exch'), pos, avg)); });
    return rows;
  }
  showSimulationPublication(moves, count) {
    if (!this.simulating) return;
    this.simPublications = (this.simPublications || 0) + 1;
    const rows = [`b ${this.simPublications} ITERATIONS`];
    const v = new DataView(moves.buffer, moves.byteOffset, moves.byteLength);
    for (let i = 0; i < count; i++) { const o = i * 34; let w = ''; for (let k = 0; k < 16 && moves[o + k]; k++) w += String.fromCharCode(moves[o + k]); const eq = (v.getInt32(o + 16) + v.getInt32(o + 20) + v.getInt32(o + 24)) / 100; const row = moves[o + 32], col = moves[o + 33]; const pos = row ? coordinateText(row > 15 ? col - 1 : row - 1, row > 15 ? row - 16 : col - 1, row > 15) : ''; rows.push(this.simRow(i === 0, w || (row ? '' : 'exch'), pos, eq)); }
    this.list.rows = rows; this.redraw();
  }
  cancelSimulation() { if (this.cancelFlag) Atomics.store(this.cancelFlag, 0, 1); }
  async about() {
    const d = ditlDialog(1024, { sub: ['Maven™ Software'], width: 345, height: 290 });
    d.items.push({ id: 'ok', type: 'default', rect: { x: 250, y: 258, w: 70, h: 20 }, text: 'OK' });
    d.items[1].text = 'Browser reconstruction of the 1995 Macintosh program.';
    d.items[3].draw = (ctx, r) => { Fonts.draw(ctx, SYS, `Dictionary: ${this.dictionaryLabel()}`, r.x, r.y + 12, C.black); };
    await this.runDialog(d);
  }
  dictionaryLabel() { const d = this.dictionaries.find(x => x.file === this.dictionary); return d ? (d.label || d.file) : this.dictionary; }
  async notes() {
    await this.runDialog(alertDialog('Search, evaluation, scoring, refill and history come from a byte-exact reconstruction of the original 68000 code. Level 2100 only: lower levels were never reconstructed, so they are disabled. Endgame time budgets follow real seconds, so very slow computers may differ from a fast one exactly as two Macs would.', [{ text: 'OK', id: 'ok', default: true }], { icon: 'note', width: 400 }));
  }
  async help() {
    await this.runDialog(alertDialog('Click a square (click again to turn the arrow) and type letters from your rack, or drag tiles from the rack. Type ? or drag the blank to play a blank. Click rack tiles to select them for exchange. Press Play or Return to move, Reset or Escape to take tiles back. Command-K kibitzes for the side to move.', [{ text: 'OK', id: 'ok', default: true }], { icon: 'note', width: 420 }));
  }

  /* ---------- autosave ---------- */
  async autosave() {
    if (!this.game || this.review || this.game.finished) return;
    try {
      const wire = await this.engine.request('save');
      const b64 = btoa(String.fromCharCode(...new Uint8Array(wire)));
      localStorage.setItem('maven.autosave', JSON.stringify({ wire: b64, turns: this.game.turns.map(t => ({ ...t, before: undefined })), names: this.names, fileName: this.game.fileName, position: this.game.position }));
    } catch (e) { /* ignore */ }
  }
  async restoreAutosave(saved) {
    const wire = Uint8Array.from(atob(saved.wire), c => c.charCodeAt(0));
    const res = await this.engine.request('load', { wire }, [wire.buffer]);
    if (res.status !== 0) { localStorage.removeItem('maven.autosave'); return; }
    // The original Open resets the side to the human orientation; restore the
    // actual side to move from the saved position.
    let position = res.position;
    if (saved.position && saved.position.side !== position.side) { const s = await this.engine.request('setPosition', { position: saved.position }); if (s === 0) position = saved.position; }
    this.game = { position, turns: saved.turns || [], started: true, finished: false, dirty: true, fileName: saved.fileName, engineHistory: res.history };
    this.names = saved.names || this.names; this.windowOpen = true; this.cursor = { row: 7, col: 7, dir: 'across' };
    this.setList('history', ' HISTORY ', this.historyRows(), [22, 107]); this.buildMenus(); this.redraw();
    if (position.side === 1) await this.mavenTurn();
  }

  /* ---------- dialogs ---------- */
  runDialog(d) { return new Promise(resolve => { d.resolve = resolve; this.dialogs.push(d); this.buildMenus(); this.redraw(); }); }
  finishDialog(d, result) { const i = this.dialogs.indexOf(d); if (i >= 0) this.dialogs.splice(i, 1); this.buildMenus(); this.redraw(); if (d.resolve) d.resolve(result); }
  listClick(d, it, x, y) { const r = { x: d.x + it.rect.x, y: d.y + it.rect.y, w: it.rect.w, h: it.rect.h }; const sh = listScrollHit(r, it, x, y); if (sh) listScroll(it, r, sh); else { const row = listRowAt(r, it, x, y); if (row >= 0) { it.selected = row; if (it.onSelect) it.onSelect(row); } } this.redraw(); }
}

/* ---------- utilities ---------- */
function transpose(rows) { const h = rows.length, w = rows[0].length; const out = []; for (let i = 0; i < w; i++) { let line = ''; for (let j = 0; j < h; j++) line += rows[j][i]; out.push(line); } return out; }
function inRect(x, y, r) { return x >= r.x && x < r.x + r.w && y >= r.y && y < r.y + r.h; }
function shuffle(a) { const arr = a.slice(); for (let i = arr.length - 1; i > 0; i--) { const j = Math.floor(Math.random() * (i + 1)); [arr[i], arr[j]] = [arr[j], arr[i]]; } return arr; }
function removeTiles(pool, tiles) { const p = pool.slice(); for (const t of tiles) { const j = p.indexOf(t); if (j >= 0) p.splice(j, 1); } return p; }
function pickFiles(multiple) {
  return new Promise(resolve => { const input = document.createElement('input'); input.type = 'file'; input.multiple = multiple; input.style.display = 'none'; document.body.appendChild(input); input.onchange = () => { resolve([...input.files]); input.remove(); }; input.oncancel = () => { resolve([]); input.remove(); }; input.click(); });
}
function downloadBytes(bytes, name) {
  const blob = new Blob([bytes], { type: 'application/octet-stream' }); const a = document.createElement('a'); a.href = URL.createObjectURL(blob); a.download = name; document.body.appendChild(a); a.click(); setTimeout(() => { URL.revokeObjectURL(a.href); a.remove(); }, 1000);
}
