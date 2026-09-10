/* A small classic Mac OS "Toolbox" for a 640x480 canvas: QuickDraw-style
 * drawing with bitmap fonts, the menu bar, document windows, modal dialogs
 * with buttons, checkboxes, radio buttons, edit fields and lists, and Mac OS 8
 * platinum controls. Everything is drawn in logical 640x480 pixels and scaled
 * by an integer factor for the display. */

export const C = {
  white: '#ffffff', black: '#000000', cream: '#fff3d0', red: '#e70000', blue: '#0000e7',
  platinum: '#e7e7e7', light: '#f3f3f3', mid: '#dadada', dark: '#969696', shade: '#b3b3b3',
  shade2: '#a5a5a5', gray6: '#c0c0c0', disabled: '#7f7f7f', menuGray: '#dddddd', hilite: '#333399',
};

export const SYS = 'Charcoal-12';
let patternCache = new Map();
/** Create a pixel-aligned fill pattern from rows of '01' strings. */
export function pattern(ctx, rows, fg, bg) {
  const key = rows.join('/') + fg + bg;
  if (patternCache.has(key)) return patternCache.get(key);
  const w = rows[0].length, h = rows.length;
  const c = document.createElement('canvas'); c.width = w; c.height = h;
  const g = c.getContext('2d');
  if (bg) { g.fillStyle = bg; g.fillRect(0, 0, w, h); }
  g.fillStyle = fg;
  rows.forEach((r, y) => { for (let x = 0; x < w; x++) if (r[x] === '1') g.fillRect(x, y, 1, 1); });
  const p = ctx.createPattern(c, 'repeat');
  patternCache.set(key, p);
  return p;
}
export const PAT = {
  checker: ['10', '01'],
  // Premium-square dithers measured from the emulator: DL 25% blue, TL 75% blue.
  dl25: ['0100', '0001'],
  tl75: ['1110', '1011'],
  dots25: ['1000', '0000', '0010', '0000'],
  dotsSparse: ['10', '00'],
  stripesH: ['1', '0'],
  gray50: ['10', '01'],
  dotted: ['1', '0', '0', '0'],
};

export class Screen {
  constructor(canvas, width = 640, height = 480) {
    this.canvas = canvas; this.width = width; this.height = height;
    this.back = document.createElement('canvas'); this.back.width = width; this.back.height = height;
    this.ctx = this.back.getContext('2d', { alpha: false });
    this.ctx.imageSmoothingEnabled = false;
    this.scale = 1;
    this.fit();
  }
  fit() {
    const dpr = window.devicePixelRatio || 1;
    const availW = window.innerWidth, availH = window.innerHeight;
    // Integer scale only: a true 640x480 clone must never resample its pixels.
    let scale = Math.max(1, Math.floor(Math.min(availW / this.width, availH / this.height)));
    this.scale = scale;
    this.canvas.style.width = `${this.width * scale}px`;
    this.canvas.style.height = `${this.height * scale}px`;
    this.canvas.width = Math.round(this.width * scale * dpr);
    this.canvas.height = Math.round(this.height * scale * dpr);
    const g = this.canvas.getContext('2d');
    g.imageSmoothingEnabled = false;
    this.front = g; this.dpr = dpr;
  }
  flip() {
    const g = this.front;
    g.imageSmoothingEnabled = false;
    g.setTransform(this.scale * this.dpr, 0, 0, this.scale * this.dpr, 0, 0);
    g.drawImage(this.back, 0, 0);
  }
  toLogical(clientX, clientY) {
    const r = this.canvas.getBoundingClientRect();
    return { x: Math.floor((clientX - r.left) / this.scale), y: Math.floor((clientY - r.top) / this.scale) };
  }
}

/* ---------- drawing helpers ---------- */
export function fillRect(ctx, x, y, w, h, color) { ctx.fillStyle = color; ctx.fillRect(x, y, w, h); }
export function frameRect(ctx, x, y, w, h, color = C.black, thick = 1) {
  ctx.fillStyle = color;
  ctx.fillRect(x, y, w, thick); ctx.fillRect(x, y + h - thick, w, thick);
  ctx.fillRect(x, y, thick, h); ctx.fillRect(x + w - thick, y, thick, h);
}
export function hline(ctx, x0, x1, y, color = C.black) { ctx.fillStyle = color; ctx.fillRect(Math.min(x0, x1), y, Math.abs(x1 - x0) + 1, 1); }
export function vline(ctx, x, y0, y1, color = C.black) { ctx.fillStyle = color; ctx.fillRect(x, Math.min(y0, y1), 1, Math.abs(y1 - y0) + 1); }
export function fillPattern(ctx, x, y, w, h, pat) {
  ctx.save(); ctx.fillStyle = pat; ctx.translate(x, y); ctx.fillRect(0, 0, w, h); ctx.restore();
}
/** Rounded rect path with integer radius, pixel-friendly. */
function roundRectPath(ctx, x, y, w, h, r) {
  ctx.beginPath();
  ctx.moveTo(x + r, y); ctx.lineTo(x + w - r, y); ctx.quadraticCurveTo(x + w, y, x + w, y + r);
  ctx.lineTo(x + w, y + h - r); ctx.quadraticCurveTo(x + w, y + h, x + w - r, y + h);
  ctx.lineTo(x + r, y + h); ctx.quadraticCurveTo(x, y + h, x, y + h - r);
  ctx.lineTo(x, y + r); ctx.quadraticCurveTo(x, y, x + r, y); ctx.closePath();
}
/** Pixel-exact rounded rectangle outline (classic 1-bit look). */
export function frameRoundRect(ctx, x, y, w, h, r, color = C.black) {
  ctx.fillStyle = color;
  hline(ctx, x + r, x + w - 1 - r, y, color); hline(ctx, x + r, x + w - 1 - r, y + h - 1, color);
  vline(ctx, x, y + r, y + h - 1 - r, color); vline(ctx, x + w - 1, y + r, y + h - 1 - r, color);
  const corners = r === 3 ? [[1, 1], [2, 0], [0, 2]] : r === 4 ? [[1, 1], [2, 0], [3, 0], [0, 2], [0, 3]] : r === 5 ? [[1, 2], [2, 1], [3, 0], [4, 0], [0, 3], [0, 4], [1, 1]] : [[1, 1], [0, 2], [2, 0]];
  for (const [dx, dy] of corners) {
    ctx.fillRect(x + dx, y + dy, 1, 1); ctx.fillRect(x + w - 1 - dx, y + dy, 1, 1);
    ctx.fillRect(x + dx, y + h - 1 - dy, 1, 1); ctx.fillRect(x + w - 1 - dx, y + h - 1 - dy, 1, 1);
  }
}
export function fillRoundRect(ctx, x, y, w, h, r, color) {
  // 1-bit pixel fill with square-cut corners matching frameRoundRect. No curves.
  ctx.fillStyle = color;
  const inset = r >= 5 ? [2, 1, 1] : r === 4 ? [2, 1] : r >= 2 ? [1] : [];
  for (let i = 0; i < inset.length; i++) {
    ctx.fillRect(x + inset[i], y + i, w - 2 * inset[i], 1);
    ctx.fillRect(x + inset[i], y + h - 1 - i, w - 2 * inset[i], 1);
  }
  ctx.fillRect(x, y + inset.length, w, h - 2 * inset.length);
}

/* ---------- fonts ---------- */
export class Fonts {
  static fonts = new Map();
  static MacFont = null;
  static async load(base, names) {
    try {
      const mod = await import(base + 'macfont.js');
      Fonts.MacFont = mod.MacFont || mod.default;
      await Promise.all(names.map(async n => { try { Fonts.fonts.set(n, await Fonts.MacFont.load(`${base}fonts/${n}.json`)); } catch (e) { console.warn('font', n, e); } }));
    } catch (e) { console.warn('bitmap fonts unavailable', e); }
  }
  static get(name) { return Fonts.fonts.get(name) || null; }
  static fallback(name) {
    const size = +(name.match(/-(\d+)/) || [0, 12])[1];
    const family = name.startsWith('Chicago') || name.startsWith('Charcoal') ? '"Chicago", "Charcoal", "Geneva", sans-serif' : name.startsWith('Monaco') ? '"Monaco", monospace' : '"Geneva", "Helvetica", sans-serif';
    return `${name.startsWith('Chicago') || name.startsWith('Charcoal') ? 'bold ' : ''}${size}px ${family}`;
  }
  static measure(name, text, opts) {
    const f = Fonts.get(name);
    if (f) return f.measure(text, opts);
    const c = Fonts._mctx || (Fonts._mctx = document.createElement('canvas').getContext('2d'));
    c.font = Fonts.fallback(name);
    return Math.round(c.measureText(text).width);
  }
  static draw(ctx, name, text, x, y, color = C.black, opts) {
    const f = Fonts.get(name);
    if (f) { f.draw(ctx, text, x, y, color, opts); return; }
    ctx.save(); ctx.font = Fonts.fallback(name); ctx.fillStyle = color; ctx.textBaseline = 'alphabetic'; ctx.fillText(text, x, y); ctx.restore();
  }
  static metrics(name) {
    const f = Fonts.get(name);
    if (f) return { ascent: f.ascent, descent: f.descent, leading: f.leading, height: f.ascent + f.descent + f.leading };
    const size = +(name.match(/-(\d+)/) || [0, 12])[1];
    return { ascent: Math.round(size * 0.8), descent: Math.round(size * 0.2), leading: 2, height: size + 2 };
  }
}
export function drawTextCentered(ctx, font, text, cx, baseline, color, opts) {
  Fonts.draw(ctx, font, text, Math.round(cx - Fonts.measure(font, text, opts) / 2), baseline, color, opts);
}
export function drawTextRight(ctx, font, text, rightX, baseline, color, opts) {
  Fonts.draw(ctx, font, text, rightX - Fonts.measure(font, text, opts), baseline, color, opts);
}

/* ---------- platinum controls ---------- */
export function drawButton(ctx, r, label, { pressed = false, enabled = true, isDefault = false } = {}) {
  const { x, y, w, h } = r;
  if (isDefault) {
    frameRoundRect(ctx, x - 4, y - 4, w + 8, h + 8, 5, enabled ? C.black : C.dark);
    frameRoundRect(ctx, x - 3, y - 3, w + 6, h + 6, 5, enabled ? C.black : C.dark);
    frameRoundRect(ctx, x - 2, y - 2, w + 4, h + 4, 4, enabled ? C.black : C.dark);
  }
  fillRoundRect(ctx, x, y, w, h, 4, pressed ? C.dark : C.platinum);
  if (!pressed) {
    hline(ctx, x + 2, x + w - 3, y + 1, C.white); vline(ctx, x + 1, y + 2, y + h - 3, C.white);
    hline(ctx, x + 2, x + w - 3, y + h - 2, C.shade); vline(ctx, x + w - 2, y + 2, y + h - 3, C.shade);
  } else {
    hline(ctx, x + 2, x + w - 3, y + 1, C.shade2); vline(ctx, x + 1, y + 2, y + h - 3, C.shade2);
  }
  frameRoundRect(ctx, x, y, w, h, 4, enabled ? C.black : C.dark);
  const m = Fonts.metrics(SYS);
  drawTextCentered(ctx, SYS, label, x + w / 2, y + Math.round((h + m.ascent - m.descent) / 2), enabled ? (pressed ? C.white : C.black) : C.disabled);
}
export function drawCheckbox(ctx, x, y, checked, enabled = true, label = '', pressed = false) {
  fillRect(ctx, x, y, 12, 12, pressed ? C.mid : C.white);
  frameRect(ctx, x, y, 12, 12, enabled ? C.black : C.dark);
  hline(ctx, x + 1, x + 10, y + 1, C.light); vline(ctx, x + 1, y + 1, y + 10, C.light);
  hline(ctx, x + 1, x + 10, y + 10, C.shade); vline(ctx, x + 10, y + 1, y + 10, C.shade);
  if (checked) {
    ctx.fillStyle = enabled ? C.black : C.dark;
    for (let i = 0; i < 8; i++) { ctx.fillRect(x + 2 + i, y + 2 + i, 1, 1); ctx.fillRect(x + 3 + i, y + 2 + i, 1, 1); ctx.fillRect(x + 9 - i, y + 2 + i, 1, 1); ctx.fillRect(x + 8 - i, y + 2 + i, 1, 1); }
  }
  if (label) Fonts.draw(ctx, SYS, label, x + 18, y + 10, enabled ? C.black : C.disabled);
}
export function drawRadio(ctx, x, y, on, enabled = true, label = '') {
  ctx.save(); ctx.beginPath(); ctx.arc(x + 6, y + 6, 5.5, 0, Math.PI * 2); ctx.fillStyle = C.white; ctx.fill();
  ctx.strokeStyle = enabled ? C.black : C.dark; ctx.lineWidth = 1; ctx.stroke();
  if (on) { ctx.beginPath(); ctx.arc(x + 6, y + 6, 2.5, 0, Math.PI * 2); ctx.fillStyle = C.black; ctx.fill(); }
  ctx.restore();
  if (label) Fonts.draw(ctx, SYS, label, x + 18, y + 10, enabled ? C.black : C.disabled);
}
export function drawEditBox(ctx, r, text, { focused = false, caret = 0, selectAll = false, font = 'Geneva-12' } = {}) {
  fillRect(ctx, r.x, r.y, r.w, r.h, C.white);
  frameRect(ctx, r.x - 1, r.y - 1, r.w + 2, r.h + 2, C.black);
  hline(ctx, r.x - 2, r.x + r.w, r.y - 2, C.dark); vline(ctx, r.x - 2, r.y - 2, r.y + r.h, C.dark);
  hline(ctx, r.x - 2, r.x + r.w + 1, r.y + r.h + 1, C.light); vline(ctx, r.x + r.w + 1, r.y - 2, r.y + r.h + 1, C.light);
  if (focused) frameRect(ctx, r.x - 3, r.y - 3, r.w + 6, r.h + 6, C.hilite, 2);
  const m = Fonts.metrics(font);
  const baseline = r.y + Math.round((r.h + m.ascent - m.descent) / 2);
  ctx.save(); ctx.beginPath(); ctx.rect(r.x, r.y, r.w, r.h); ctx.clip();
  if (selectAll && text) { fillRect(ctx, r.x + 2, r.y + 1, Fonts.measure(font, text) + 1, r.h - 2, C.hilite); Fonts.draw(ctx, font, text, r.x + 3, baseline, C.white); }
  else Fonts.draw(ctx, font, text, r.x + 3, baseline, C.black);
  if (focused && !selectAll) { const cx = r.x + 3 + Fonts.measure(font, text.slice(0, caret)); vline(ctx, cx, r.y + 2, r.y + r.h - 3, C.black); }
  ctx.restore();
}
export function drawScrollbar(ctx, r, { value = 0, max = 0, page = 1, enabled = true } = {}) {
  fillRect(ctx, r.x, r.y, r.w, r.h, enabled ? C.mid : C.white);
  frameRect(ctx, r.x, r.y, r.w, r.h, C.black);
  const arrow = (y, up) => {
    fillRect(ctx, r.x + 1, y, r.w - 2, 15, C.platinum);
    hline(ctx, r.x + 1, r.x + r.w - 2, up ? y + 15 : y - 1, C.black);
    ctx.fillStyle = enabled ? C.black : C.dark;
    for (let i = 0; i < 5; i++) { const yy = up ? y + 4 + i : y + 10 - i; ctx.fillRect(r.x + r.w / 2 - i - 1, yy, 2 * i + 2, 1); }
  };
  arrow(r.y + 1, true); arrow(r.y + r.h - 16, false);
  if (enabled && max > 0) {
    const trackY = r.y + 17, trackH = r.h - 34;
    const thumbH = Math.max(16, Math.round(trackH * page / (max + page)));
    const thumbY = trackY + Math.round((trackH - thumbH) * value / max);
    fillRoundRect(ctx, r.x + 1, thumbY, r.w - 2, thumbH, 2, C.platinum);
    frameRect(ctx, r.x + 1, thumbY, r.w - 2, thumbH, C.black);
    hline(ctx, r.x + 2, r.x + r.w - 3, thumbY + 1, C.white); vline(ctx, r.x + 2, thumbY + 1, thumbY + thumbH - 2, C.white);
  }
}

/* ---------- menu bar ---------- */
export class MenuBar {
  constructor(menus, sprites) {
    this.menus = menus; this.sprites = sprites; this.open = -1; this.hover = -1; this.height = 20;
    this.clock = () => new Date().toLocaleTimeString([], { hour: 'numeric', minute: '2-digit' });
  }
  titleRects() {
    const rects = []; let x = 8;
    for (const m of this.menus) {
      const w = m.apple ? 32 : Fonts.measure(SYS, m.title) + 16;
      rects.push({ x, y: 0, w, h: this.height }); x += w;
    }
    return rects;
  }
  draw(ctx, W) {
    fillRect(ctx, 0, 0, W, this.height, C.white);
    hline(ctx, 0, W - 1, this.height - 1, C.black);
    // rounded screen corners
    ctx.fillStyle = C.black; ctx.fillRect(0, 0, 4, 1); ctx.fillRect(0, 1, 2, 1); ctx.fillRect(0, 2, 1, 2); ctx.fillRect(W - 4, 0, 4, 1); ctx.fillRect(W - 2, 1, 2, 1); ctx.fillRect(W - 1, 2, 1, 2);
    const rects = this.titleRects();
    this.menus.forEach((m, i) => {
      const r = rects[i];
      const selected = i === this.open;
      if (selected) fillRect(ctx, r.x, 0, r.w, this.height - 1, C.hilite);
      if (m.apple) { if (this.sprites.apple) ctx.drawImage(this.sprites.apple, r.x + 2, 1); }
      else Fonts.draw(ctx, SYS, m.title, r.x + 8, 14, selected ? C.white : (m.enabled === false ? C.disabled : C.black));
    });
    const time = this.clock();
    if (this.sprites.appicon) ctx.drawImage(this.sprites.appicon, W - 36, 1);
    drawTextRight(ctx, SYS, time, W - 44, 14, C.black);
    if (this.open >= 0) this.drawMenu(ctx, this.open, rects[this.open]);
  }
  itemHeight() { return 16; }
  menuRect(i, titleRect) {
    const m = this.menus[i];
    let w = 0;
    for (const it of m.items) { const label = it.separator ? '' : it.label; w = Math.max(w, Fonts.measure(SYS, label) + (it.key ? 40 : 0)); }
    w += 36;
    const h = m.items.reduce((s, it) => s + (it.separator ? 8 : this.itemHeight()), 0) + 4;
    return { x: titleRect.x, y: this.height, w, h };
  }
  drawMenu(ctx, i, titleRect) {
    const m = this.menus[i]; const r = this.menuRect(i, titleRect);
    fillRect(ctx, r.x + 1, r.y + 1, r.w, r.h, C.dark); // shadow
    fillRect(ctx, r.x, r.y, r.w, r.h, C.platinum);
    frameRect(ctx, r.x, r.y, r.w, r.h, C.black);
    hline(ctx, r.x + 1, r.x + r.w - 2, r.y + 1, C.white); vline(ctx, r.x + 1, r.y + 1, r.y + r.h - 2, C.white);
    let y = r.y + 2;
    m.items.forEach((it, j) => {
      if (it.separator) { hline(ctx, r.x + 1, r.x + r.w - 2, y + 3, C.dark); hline(ctx, r.x + 1, r.x + r.w - 2, y + 4, C.white); y += 8; return; }
      const enabled = it.enabled !== false;
      const hot = j === this.hover && enabled;
      if (hot) fillRect(ctx, r.x + 2, y, r.w - 4, this.itemHeight(), C.hilite);
      const color = hot ? C.white : enabled ? C.black : C.disabled;
      if (it.checked) Fonts.draw(ctx, SYS, '√', r.x + 6, y + 12, color);
      Fonts.draw(ctx, SYS, it.label, r.x + 20, y + 12, color);
      if (it.key) drawTextRight(ctx, SYS, '⌘' + it.key, r.x + r.w - 8, y + 12, color);
      y += this.itemHeight();
    });
  }
  itemAt(x, y) {
    if (this.open < 0) return -1;
    const r = this.menuRect(this.open, this.titleRects()[this.open]);
    if (x < r.x || x >= r.x + r.w || y < r.y || y >= r.y + r.h) return -1;
    let yy = r.y + 2;
    const m = this.menus[this.open];
    for (let j = 0; j < m.items.length; j++) {
      const it = m.items[j]; const h = it.separator ? 8 : this.itemHeight();
      if (y >= yy && y < yy + h) return it.separator ? -1 : j;
      yy += h;
    }
    return -1;
  }
  titleAt(x, y) {
    if (y >= this.height) return -1;
    const rects = this.titleRects();
    return rects.findIndex(r => x >= r.x && x < r.x + r.w);
  }
}

/* ---------- windows ---------- */
export function drawWindowFrame(ctx, r, title, { active = true, shadow = true } = {}) {
  const th = 18; // title bar height
  // shadow
  if (shadow) { hline(ctx, r.x + 1, r.x + r.w, r.y + r.h, C.black); vline(ctx, r.x + r.w, r.y + 1, r.y + r.h, C.black); }
  // title bar
  fillRect(ctx, r.x, r.y, r.w, th, C.platinum);
  frameRect(ctx, r.x, r.y, r.w, th + 1, C.black);
  const tw = Fonts.measure(SYS, title) + 12;
  const tx = Math.round(r.x + (r.w - tw) / 2);
  if (active) {
    for (let y = r.y + 3; y < r.y + th - 2; y += 2) { hline(ctx, r.x + 3, tx - 1, y, C.dark); hline(ctx, tx + tw, r.x + r.w - 4, y, C.dark); }
    for (let y = r.y + 4; y < r.y + th - 1; y += 2) { hline(ctx, r.x + 3, tx - 1, y, C.white); hline(ctx, tx + tw, r.x + r.w - 4, y, C.white); }
  }
  Fonts.draw(ctx, SYS, title, tx + 6, r.y + 13, active ? C.black : C.disabled);
  // content frame
  fillRect(ctx, r.x, r.y + th, r.w, r.h - th, C.white);
  frameRect(ctx, r.x, r.y + th, r.w, r.h - th, C.black);
}

/* ---------- dialogs ---------- */
/** Dialog items: {id, type:'button'|'default'|'cancel'|'checkbox'|'radio'|'static'|'edit'|'user'|'list', rect:{x,y,w,h}, text, value, enabled, group, draw(ctx,item), onClick(item)} */
export class Dialog {
  constructor(items, { width, height, title = null, x = null, y = null, icon = null } = {}) {
    this.items = items; this.w = width; this.h = height; this.title = title; this.icon = icon;
    this.x = x ?? Math.round((640 - width) / 2); this.y = y ?? Math.max(24, Math.round((480 - height) / 3));
    this.focus = items.find(i => i.type === 'edit') || null;
    if (this.focus) { this.focus.caret = (this.focus.text || '').length; this.focus.selectAll = !!this.focus.text; }
    this.pressed = null; this.result = null; this.substitutions = [];
  }
  sub(text) { return text.replace(/\^(\d)/g, (m, d) => this.substitutions[+d] ?? ''); }
  draw(ctx) {
    const { x, y, w, h } = this;
    // platinum modal dialog frame
    fillRect(ctx, x + 2, y + 2, w, h, C.black);
    fillRect(ctx, x, y, w, h, C.platinum);
    frameRect(ctx, x, y, w, h, C.black);
    hline(ctx, x + 1, x + w - 2, y + 1, C.white); vline(ctx, x + 1, y + 1, y + h - 2, C.white);
    hline(ctx, x + 1, x + w - 2, y + h - 2, C.shade); vline(ctx, x + w - 2, y + 1, y + h - 2, C.shade);
    fillRect(ctx, x + 5, y + 5, w - 10, h - 10, C.platinum);
    if (this.title) {
      fillRect(ctx, x, y, w, 14, C.platinum);
      drawTextCentered(ctx, SYS, this.title, x + w / 2, y + 11, C.black);
    }
    if (this.icon) this.drawIcon(ctx, x + 20, y + 16, this.icon);
    for (const it of this.items) this.drawItem(ctx, it);
  }
  drawIcon(ctx, x, y, kind) {
    // simple classic alert icons: stop (octagon), caution (triangle), note (speech bubble)
    ctx.save();
    if (kind === 'stop') { ctx.fillStyle = C.red; ctx.beginPath(); ctx.moveTo(x + 9, y); ctx.lineTo(x + 23, y); ctx.lineTo(x + 32, y + 9); ctx.lineTo(x + 32, y + 23); ctx.lineTo(x + 23, y + 32); ctx.lineTo(x + 9, y + 32); ctx.lineTo(x, y + 23); ctx.lineTo(x, y + 9); ctx.closePath(); ctx.fill(); ctx.strokeStyle = C.black; ctx.stroke(); fillRect(ctx, x + 8, y + 12, 16, 3, C.white); fillRect(ctx, x + 8, y + 18, 16, 3, C.white); }
    else if (kind === 'caution') { ctx.fillStyle = '#ffcc00'; ctx.beginPath(); ctx.moveTo(x + 16, y); ctx.lineTo(x + 32, y + 30); ctx.lineTo(x, y + 30); ctx.closePath(); ctx.fill(); ctx.strokeStyle = C.black; ctx.stroke(); fillRect(ctx, x + 14, y + 9, 4, 12, C.black); fillRect(ctx, x + 14, y + 24, 4, 4, C.black); }
    else { ctx.fillStyle = C.white; ctx.beginPath(); ctx.arc(x + 16, y + 14, 14, 0, Math.PI * 2); ctx.fill(); ctx.strokeStyle = C.black; ctx.stroke(); ctx.beginPath(); ctx.moveTo(x + 6, y + 24); ctx.lineTo(x + 2, y + 32); ctx.lineTo(x + 14, y + 27); ctx.fillStyle = C.white; ctx.fill(); ctx.stroke(); fillRect(ctx, x + 14, y + 10, 4, 10, C.black); fillRect(ctx, x + 14, y + 5, 4, 3, C.black); }
    ctx.restore();
  }
  drawItem(ctx, it) {
    const r = { x: this.x + it.rect.x, y: this.y + it.rect.y, w: it.rect.w, h: it.rect.h };
    const enabled = it.enabled !== false;
    switch (it.type) {
      case 'button': case 'default': case 'cancel':
        drawButton(ctx, r, this.sub(it.text), { pressed: this.pressed === it, enabled, isDefault: it.type === 'default' }); break;
      case 'checkbox': drawCheckbox(ctx, r.x, r.y + Math.round((r.h - 12) / 2), !!it.value, enabled, this.sub(it.text), this.pressed === it); break;
      case 'radio': drawRadio(ctx, r.x, r.y + Math.round((r.h - 12) / 2), !!it.value, enabled, this.sub(it.text)); break;
      case 'static': this.drawStatic(ctx, r, this.sub(it.text), it.font || SYS, it.align); break;
      case 'edit': drawEditBox(ctx, r, it.text || '', { focused: this.focus === it, caret: it.caret || 0, selectAll: this.focus === it && it.selectAll, font: it.font || 'Geneva-12' }); break;
      case 'user': if (it.draw) it.draw(ctx, r, it); break;
      case 'list': drawList(ctx, r, it); break;
    }
  }
  drawStatic(ctx, r, text, font, align) {
    const m = Fonts.metrics(font); const lh = m.height;
    const lines = wrapText(font, text, r.w);
    let y = r.y + m.ascent;
    for (const line of lines) {
      if (align === 'right') drawTextRight(ctx, font, line, r.x + r.w, y, C.black);
      else if (align === 'center') drawTextCentered(ctx, font, line, r.x + r.w / 2, y, C.black);
      else Fonts.draw(ctx, font, line, r.x, y, C.black);
      y += lh;
    }
  }
  itemAt(x, y) {
    for (const it of this.items) {
      const r = it.rect;
      if (x >= this.x + r.x && x < this.x + r.x + r.w && y >= this.y + r.y && y < this.y + r.y + r.h) return it;
    }
    return null;
  }
  key(ev) {
    if (ev.key === 'Enter') { const d = this.items.find(i => i.type === 'default' && i.enabled !== false); if (d) return this.activate(d); return null; }
    if (ev.key === 'Escape') { const c = this.items.find(i => i.type === 'cancel'); if (c) return this.activate(c); return null; }
    if (ev.key === 'Tab') { const edits = this.items.filter(i => i.type === 'edit'); if (edits.length) { const k = edits.indexOf(this.focus); this.focus = edits[(k + 1) % edits.length]; this.focus.selectAll = true; this.focus.caret = (this.focus.text || '').length; } return null; }
    if (this.focus && this.focus.type === 'edit') {
      const f = this.focus; f.text = f.text || ''; f.caret = f.caret ?? f.text.length;
      if (ev.key === 'Backspace') { if (f.selectAll) { f.text = ''; f.caret = 0; f.selectAll = false; } else if (f.caret > 0) { f.text = f.text.slice(0, f.caret - 1) + f.text.slice(f.caret); f.caret--; } }
      else if (ev.key === 'ArrowLeft') { f.selectAll = false; f.caret = Math.max(0, f.caret - 1); }
      else if (ev.key === 'ArrowRight') { f.selectAll = false; f.caret = Math.min(f.text.length, f.caret + 1); }
      else if (ev.key.length === 1 && !ev.metaKey && !ev.ctrlKey) {
        if (f.selectAll) { f.text = ''; f.caret = 0; f.selectAll = false; }
        if (!f.maxLength || f.text.length < f.maxLength) { let ch = ev.key; if (f.filter && !f.filter(ch)) return null; if (f.upper) ch = ch.toUpperCase(); f.text = f.text.slice(0, f.caret) + ch + f.text.slice(f.caret); f.caret++; }
        if (f.onChange) f.onChange(f);
      }
      if (f.onChange && ev.key === 'Backspace') f.onChange(f);
    } else if (ev.key.length === 1 && this.onKey) return this.onKey(ev.key);
    return null;
  }
  activate(it) {
    if (it.enabled === false) return null;
    if (it.type === 'checkbox') { it.value = !it.value; if (it.onClick) it.onClick(it); return null; }
    if (it.type === 'radio') { for (const o of this.items) if (o.type === 'radio' && o.group === it.group) o.value = false; it.value = true; if (it.onClick) it.onClick(it); return null; }
    if (it.type === 'edit') { this.focus = it; it.selectAll = false; it.caret = (it.text || '').length; return null; }
    if (it.type === 'list') { return null; }
    if (it.onClick) { const r = it.onClick(it); if (r === false) return null; }
    return it.id ?? it.text;
  }
}
export function wrapText(font, text, width) {
  const out = [];
  for (const para of text.split(/\r|\n/)) {
    const words = para.split(' '); let line = '';
    for (const w of words) {
      const t = line ? line + ' ' + w : w;
      if (Fonts.measure(font, t) <= width || !line) line = t; else { out.push(line); line = w; }
    }
    out.push(line);
  }
  return out;
}

/* ---------- list ---------- */
/** List item: {rect, rows:[string|{text,color}], font, top, selected, header, onSelect, columns:[x positions for dotted dividers]} */
export function drawList(ctx, r, it) {
  const font = it.font || 'Monaco-9';
  const m = Fonts.metrics(font); const lh = it.lineHeight || m.height;
  fillRect(ctx, r.x, r.y, r.w, r.h, C.white);
  frameRect(ctx, r.x, r.y, r.w, r.h, C.black);
  const sbw = it.scrollbar === false ? 0 : 16;
  const inner = { x: r.x + 1, y: r.y + 1, w: r.w - 2 - sbw, h: r.h - 2 };
  ctx.save(); ctx.beginPath(); ctx.rect(inner.x, inner.y, inner.w, inner.h); ctx.clip();
  const rows = it.rows || []; const top = it.top || 0;
  let y = inner.y;
  for (let i = top; i < rows.length && y < inner.y + inner.h; i++) {
    const row = rows[i];
    const invert = it.selected === i || (row && row.invert);
    if (invert) fillRect(ctx, inner.x, y, inner.w, lh, C.black);
    const color = invert ? C.white : ((row && row.color) || C.black);
    const base = y + m.ascent + 1;
    if (row && row.seg) {
      // Columns placed at exact pixel offsets (measured from the emulator).
      for (const s of row.seg) {
        if (s.align === 'right') drawTextRight(ctx, font, s.text, inner.x + s.x, base, color);
        else Fonts.draw(ctx, font, s.text, inner.x + s.x, base, color);
      }
    } else {
      Fonts.draw(ctx, font, typeof row === 'string' ? row : row.text, inner.x + 3, base, color);
    }
    y += lh;
  }
  ctx.restore();
  if (sbw) {
    const visible = Math.floor(inner.h / lh);
    drawScrollbar(ctx, { x: r.x + r.w - 1 - sbw, y: r.y, w: sbw + 1, h: r.h }, { value: top, max: Math.max(0, rows.length - visible), page: visible, enabled: rows.length > visible });
  }
}
export function listRowAt(r, it, x, y) {
  const font = it.font || 'Monaco-9'; const lh = it.lineHeight || Fonts.metrics(font).height;
  const sbw = it.scrollbar === false ? 0 : 16;
  if (x < r.x + 1 || x >= r.x + r.w - 1 - sbw || y < r.y + 1 || y >= r.y + r.h - 1) return -1;
  const i = (it.top || 0) + Math.floor((y - r.y - 1) / lh);
  return i < (it.rows || []).length ? i : -1;
}
export function listScrollHit(r, it, x, y) {
  const sbw = 16; if (x < r.x + r.w - 1 - sbw) return null;
  if (y < r.y + 17) return 'up'; if (y >= r.y + r.h - 17) return 'down';
  const font = it.font || 'Monaco-9'; const lh = it.lineHeight || Fonts.metrics(font).height;
  const visible = Math.floor((r.h - 2) / lh); const max = Math.max(0, (it.rows || []).length - visible);
  if (max <= 0) return null;
  const trackY = r.y + 17, trackH = r.h - 34; const thumbH = Math.max(16, Math.round(trackH * visible / (max + visible)));
  const thumbY = trackY + Math.round((trackH - thumbH) * (it.top || 0) / max);
  return y < thumbY ? 'pageup' : y >= thumbY + thumbH ? 'pagedown' : 'thumb';
}
export function listScroll(it, r, action) {
  const font = it.font || 'Monaco-9'; const lh = it.lineHeight || Fonts.metrics(font).height;
  const visible = Math.floor((r.h - 2) / lh); const max = Math.max(0, (it.rows || []).length - visible);
  let top = it.top || 0;
  if (action === 'up') top--; else if (action === 'down') top++; else if (action === 'pageup') top -= visible; else if (action === 'pagedown') top += visible;
  it.top = Math.max(0, Math.min(max, top));
}
