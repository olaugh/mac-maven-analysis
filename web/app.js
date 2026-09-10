/* Page bootstrap: canvas, pointer/keyboard routing, sprites. */
import { MavenApp } from './maven_ui.js';

async function loadSprites() {
  const data = await (await fetch('sprites.json')).json();
  const out = {};
  await Promise.all(Object.entries(data).map(([k, v]) => new Promise(res => { const img = new Image(); img.onload = () => { out[k] = img; res(); }; img.onerror = () => res(); img.src = v.png; })));
  return out;
}

async function main() {
  const canvas = document.getElementById('screen');
  const sprites = await loadSprites();
  const app = new MavenApp(canvas, sprites);
  window.maven = app;
  const keyboard = document.getElementById('keyboard');
  const toLogical = ev => app.screen.toLogical(ev.clientX, ev.clientY);
  canvas.addEventListener('pointerdown', ev => { ev.preventDefault(); canvas.setPointerCapture(ev.pointerId); const p = toLogical(ev); app.pointerType = ev.pointerType; app.mouseDown(p.x, p.y, ev); if (app.dialogs.length && app.dialogs[app.dialogs.length - 1].focus) keyboard.focus({ preventScroll: true }); });
  canvas.addEventListener('pointermove', ev => { const p = toLogical(ev); app.mouseMove(p.x, p.y); });
  canvas.addEventListener('pointerup', ev => { const p = toLogical(ev); app.mouseUp(p.x, p.y); });
  canvas.addEventListener('pointercancel', ev => { const p = toLogical(ev); app.mouseUp(-1, -1); });
  canvas.addEventListener('contextmenu', ev => ev.preventDefault());
  window.addEventListener('keydown', ev => { if (ev.target === keyboard && ev.key === 'Unidentified') return; if (app.keyDown(ev)) ev.preventDefault(); });
  // Virtual keyboards on phones may not send key events; mirror the hidden field's text.
  keyboard.addEventListener('input', () => { const v = keyboard.value; keyboard.value = ''; for (const ch of v) app.keyDown({ key: ch, preventDefault() { } }); });
  window.addEventListener('resize', () => { app.screen.fit(); app.redraw(); });
  window.addEventListener('beforeunload', () => { app.autosave(); });
  await app.start(new URL('worker.js', location.href).href);
}
main().catch(e => { console.error(e); document.body.insertAdjacentHTML('beforeend', `<pre style="color:#fff;background:#900;padding:8px">${String(e.stack || e)}</pre>`); });
