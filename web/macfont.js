/*
 * macfont.js -- render classic Mac OS bitmap fonts (extracted by
 * web/tools/extract_fonts.py into web/fonts/*.json) onto an HTML canvas.
 *
 * Usable as an ES module:
 *     import { MacFont } from './macfont.js';
 *     const chicago = await MacFont.load('fonts/Chicago-12.json');
 *     chicago.draw(ctx, 'File', 10, 14);           // (x, y) = baseline origin
 * or as a classic <script>, which defines window.MacFont.
 *
 * Text is encoded as Mac Roman.  Glyph images are cached as offscreen
 * canvases (one per glyph per colour) and blitted with drawImage at integer
 * pixel positions, so rendering is pixel-exact.
 */

const MAC_ROMAN_HIGH =
  'ÄÅÇÉÑÖÜáàâäãåçéè' +
  'êëíìîïñóòôöõúùûü' +
  '†°¢£§•¶ß®©™´¨≠ÆØ' +
  '∞±≤≥¥µ∂∑∏π∫ªºΩæø' +
  '¿¡¬√ƒ≈∆«»… ÀÃÕŒœ' +
  '–—“”‘’÷◊ÿŸ⁄€‹›ﬁﬂ' +
  '‡·‚„‰ÂÊÁËÈÍÎÏÌÓÔ' +
  'ÒÚÛÙıˆ˜¯˘˙˚¸˝˛ˇ';

const UNICODE_TO_MAC = new Map();
for (let i = 0; i < 128; i++) UNICODE_TO_MAC.set(MAC_ROMAN_HIGH.charCodeAt(i), 128 + i);

/** Encode a JS string as an array of Mac Roman byte values. */
export function encodeMacRoman(text) {
  const out = [];
  for (const ch of text) {
    const cp = ch.codePointAt(0);
    if (cp < 128) out.push(cp);
    else if (UNICODE_TO_MAC.has(cp)) out.push(UNICODE_TO_MAC.get(cp));
    else out.push(-1); // missing glyph
  }
  return out;
}

function makeCanvas(w, h) {
  if (typeof OffscreenCanvas !== 'undefined') return new OffscreenCanvas(w, h);
  const c = document.createElement('canvas');
  c.width = w; c.height = h;
  return c;
}

export class MacFont {
  constructor(data) {
    this.family = data.family;
    this.size = data.size;
    this.style = data.style || 0;
    this.ascent = data.ascent;
    this.descent = data.descent;
    this.leading = data.leading;
    this.widMax = data.widMax;
    this.height = data.height;
    this.firstChar = data.firstChar;
    this.lastChar = data.lastChar;
    this.glyphs = data.glyphs;
    this.missing = data.missing || { w: 0, o: 0, cols: [] };
    this._cache = new Map(); // key "code|color|scale" -> canvas or null
  }

  /** Fetch a font JSON and construct a MacFont. */
  static async load(url) {
    const res = await fetch(url);
    if (!res.ok) throw new Error('MacFont: failed to load ' + url + ' (' + res.status + ')');
    return new MacFont(await res.json());
  }

  /** Line height in pixels (ascent + descent + leading), as QuickDraw uses. */
  get lineHeight() { return this.ascent + this.descent + this.leading; }

  /** Glyph record for a Mac Roman code (or the missing glyph). */
  glyph(code) {
    const g = code >= 0 ? this.glyphs[code] : undefined;
    return g || this.missing;
  }

  /**
   * Advance width of a string in pixels.  opts.bold applies QuickDraw's
   * algorithmic bold (each glyph smeared 1 px to the right, advance + 1),
   * which is how Maven's Monaco 9 bold list text is produced.
   */
  measure(text, opts) {
    const extra = opts && opts.bold ? 1 : 0;
    let w = 0;
    for (const code of encodeMacRoman(text)) w += this.glyph(code).w + extra;
    return w;
  }

  /** Advance width of the first n characters (for hit-testing / truncation). */
  measurePrefix(text, n, opts) { return this.measure(text.slice(0, n), opts); }

  /** Build (or fetch) the cached offscreen image of one glyph. */
  _image(code, color, scale, bold) {
    const key = code + '|' + color + '|' + scale + (bold ? '|b' : '');
    let img = this._cache.get(key);
    if (img !== undefined) return img;
    const g = this.glyph(code);
    let cols = g.cols;
    if (bold && cols.length) {
      cols = cols.concat([0]);
      for (let i = cols.length - 1; i > 0; i--) cols[i] |= cols[i - 1];
    }
    if (cols.length === 0) { this._cache.set(key, null); return null; }
    const h = this.height;
    const c = makeCanvas(cols.length * scale, h * scale);
    const cx = c.getContext('2d');
    cx.imageSmoothingEnabled = false;
    cx.fillStyle = color;
    for (let x = 0; x < cols.length; x++) {
      const bits = cols[x];
      if (!bits) continue;
      // run-length fill vertical runs for fewer fillRect calls
      let y = 0;
      while (y < h) {
        if ((bits >> y) & 1) {
          let y2 = y;
          while (y2 < h && ((bits >> y2) & 1)) y2++;
          cx.fillRect(x * scale, y * scale, scale, (y2 - y) * scale);
          y = y2;
        } else y++;
      }
    }
    this._cache.set(key, c);
    return c;
  }

  /**
   * Draw text with its baseline origin at integer pixel (x, y).
   * Returns the x position after the last glyph.
   */
  draw(ctx, text, x, y, color = '#000', opts) {
    return this.drawScaled(ctx, text, x, y, 1, color, opts);
  }

  /**
   * Draw text magnified by an integer factor (pixel-doubled, no smoothing).
   * opts: { bold: boolean } for QuickDraw-style algorithmic bold.
   */
  drawScaled(ctx, text, x, y, scale = 1, color = '#000', opts) {
    const bold = !!(opts && opts.bold);
    scale = Math.max(1, Math.round(scale));
    x = Math.round(x); y = Math.round(y);
    const prevSmooth = ctx.imageSmoothingEnabled;
    ctx.imageSmoothingEnabled = false;
    const top = y - this.ascent * scale;
    for (const code of encodeMacRoman(text)) {
      const g = this.glyph(code);
      const img = this._image(code, color, scale, bold);
      if (img) ctx.drawImage(img, x + g.o * scale, top);
      x += (g.w + (bold ? 1 : 0)) * scale;
    }
    ctx.imageSmoothingEnabled = prevSmooth;
    return x;
  }

  /** Draw text right-aligned so that it ends at x. */
  drawRight(ctx, text, x, y, color = '#000', scale = 1, opts) {
    return this.drawScaled(ctx, text, x - this.measure(text, opts) * scale, y, scale, color, opts);
  }

  /** Draw text centred on x. */
  drawCentered(ctx, text, x, y, color = '#000', scale = 1, opts) {
    return this.drawScaled(ctx, text, x - Math.floor(this.measure(text, opts) * scale / 2), y, scale, color, opts);
  }

  /** Render a glyph as ASCII art (debugging aid). */
  ascii(ch) {
    const g = this.glyph(encodeMacRoman(ch)[0]);
    const rows = [];
    for (let y = 0; y < this.height; y++) {
      let s = '';
      for (const c of g.cols) s += ((c >> y) & 1) ? '#' : '.';
      rows.push(s);
    }
    return rows.join('\n');
  }
}

/** Load every font listed in fonts/index.json; returns Map "Family-size[-style]" -> MacFont. */
export async function loadFontIndex(baseUrl = 'fonts/') {
  const res = await fetch(baseUrl + 'index.json');
  const idx = await res.json();
  const fonts = new Map();
  await Promise.all(idx.fonts.map(async (e) => {
    const f = await MacFont.load(baseUrl + e.file);
    fonts.set(e.file.replace(/\.json$/, ''), f);
  }));
  return fonts;
}

if (typeof window !== 'undefined') {
  window.MacFont = MacFont;
  window.loadFontIndex = loadFontIndex;
  window.encodeMacRoman = encodeMacRoman;
}
