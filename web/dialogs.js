/* Dialogs built from Maven's original DITL item lists (web/ditl.json). */
import { Dialog, SYS } from './toolbox.js';

let DITL = null;
export async function loadDITL(url = 'ditl.json') { DITL = await (await fetch(url)).json(); return DITL; }

const ICONS = { '0': 'stop', '1': 'note', '2': 'caution' };

/** Build a Dialog from DITL id. options: {sub:[...], defaultId, cancelId, edits:{index:text}, checks:{index:bool}, hide:[indexes], width,height} */
export function ditlDialog(id, options = {}) {
  const items = (DITL && DITL[String(id)]) || [];
  const built = []; let icon = null; let maxR = 0, maxB = 0;
  items.forEach((it, index) => {
    const [l, t, r, b] = it.rect;
    if (options.hide && options.hide.includes(index)) return;
    maxR = Math.max(maxR, r); maxB = Math.max(maxB, b);
    const rect = { x: l, y: t, w: r - l, h: b - t };
    const base = { id: index, rect, text: it.text, enabled: !it.disabled };
    switch (it.kind) {
      case 'button': built.push({ ...base, type: index === (options.defaultId ?? 0) ? 'default' : index === options.cancelId ? 'cancel' : 'button' }); break;
      case 'checkbox': built.push({ ...base, type: 'checkbox', value: !!(options.checks && options.checks[index]) }); break;
      case 'radio': built.push({ ...base, type: 'radio', value: !!(options.checks && options.checks[index]), group: 'r' }); break;
      case 'static': built.push({ ...base, type: 'static', font: SYS }); break;
      case 'edit': built.push({ ...base, type: 'edit', text: options.edits && options.edits[index] != null ? String(options.edits[index]) : it.text, font: 'Geneva-12' }); break;
      case 'icon': icon = ICONS[it.text] || 'note'; break;
      case 'user': built.push({ ...base, type: 'user', draw: options.userDraw && options.userDraw[index] }); break;
      case 'control': break;
      default: break;
    }
  });
  const width = options.width || maxR + 16, height = options.height || maxB + 16;
  const d = new Dialog(built, { width, height, icon });
  d.substitutions = options.sub || [];
  d.items.forEach(it => { if (options.onClick && options.onClick[it.id]) it.onClick = options.onClick[it.id]; });
  return d;
}

/** Generic alert with text and buttons: buttons [{text, id, default, cancel}] */
export function alertDialog(text, buttons, { icon = 'caution', width = 300 } = {}) {
  const items = [{ type: 'static', rect: { x: 64, y: 14, w: width - 84, h: 60 }, text, font: SYS }];
  let x = width - 20;
  for (const b of [...buttons].reverse()) {
    const w = Math.max(60, b.text.length * 7 + 20); x -= w;
    items.push({ id: b.id ?? b.text, type: b.default ? 'default' : b.cancel ? 'cancel' : 'button', rect: { x, y: 84, w, h: 20 }, text: b.text });
    x -= 12;
  }
  return new Dialog(items, { width, height: 118, icon });
}

export function promptDialog(label, initial = '', { width = 300, upper = false, maxLength = 200, okText = 'OK' } = {}) {
  const items = [
    { type: 'static', rect: { x: 16, y: 12, w: width - 32, h: 36 }, text: label, font: SYS },
    { id: 'edit', type: 'edit', rect: { x: 16, y: 52, w: width - 32, h: 16 }, text: initial, upper, maxLength },
    { id: 'ok', type: 'default', rect: { x: width - 80, y: 84, w: 64, h: 20 }, text: okText },
    { id: 'cancel', type: 'cancel', rect: { x: width - 160, y: 84, w: 64, h: 20 }, text: 'Cancel' },
  ];
  return new Dialog(items, { width, height: 118 });
}
