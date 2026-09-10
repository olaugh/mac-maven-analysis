// Maven DAWG compiler, browser/node ES module.
//
// Port of web/tools/build_dawg.py.  compileDawg(s1Words, s2Words) returns the
// two-section data fork as a Uint8Array, byte-identical to the Python
// compiler's output for the same word sets (and, for the original word lists,
// to the shipped maven2.1 file).
//
// Format (all 32-bit big-endian):
//   header   boundary (= max(0, s1Root - 65536)), s1Root, s2Root
//   section  (root + 26) entries:
//     0        0x300 sentinel          1..26   copy of the root group
//     27..255  zero                    256     0x200 sentinel
//     257..    sibling groups, post-order DFS (children before parents,
//              letters ascending within a group, all child pointers backward)
//     root..root+25  the a..z root group, last-sibling flag on z
//   entry    bits 0-7 letter, bit 8 end-of-word, bit 9 last-sibling,
//            bits 10-31 index of the child group (0 = none)
//
// End-of-word lives in the edge entry, so groups are shared between nodes
// with identical child edges regardless of their own end-of-word status.

const SENTINEL_FIRST = 0x300;
const SENTINEL_256 = 0x200;
const DATA_START = 257;
const WORD_RE = /^[a-z]+$/;

/** Normalise an iterable of words: lower-case, ASCII a-z only, length range. */
export function normalizeWords(words, { minLength = 2, maxLength = 0 } = {}) {
  const set = new Set();
  for (let w of words) {
    w = String(w).trim().toLowerCase();
    if (!WORD_RE.test(w)) continue;
    if (w.length < minLength || (maxLength && w.length > maxLength)) continue;
    set.add(w);
  }
  return set;
}

/** Split word-list text (one word per line) into normalised words. */
export function parseWordList(text, options) {
  return normalizeWords(text.split(/\r?\n/), options);
}

class TrieNode {
  constructor() { this.children = new Map(); this.eow = false; }
}

function buildTrie(words) {
  const root = new TrieNode();
  for (const word of words) {
    let node = root;
    for (const ch of word) {
      let next = node.children.get(ch);
      if (!next) { next = new TrieNode(); node.children.set(ch, next); }
      node = next;
    }
    node.eow = true;
  }
  return root;
}

// A Group is { edges: [[letter, eow, childGroup|null], ...], start, id }.
// Groups are registered by the key of their edges; child identity is the
// registered group's sequential id (the Python version uses id()).
function minimizeGroups(root) {
  const register = new Map();
  let nextId = 1;
  function groupOf(node) {
    if (node.children.size === 0) return null;
    const letters = [...node.children.keys()].sort();
    const edges = [];
    const keyParts = [];
    for (const ch of letters) {
      const child = node.children.get(ch);
      const g = groupOf(child);
      edges.push([ch, child.eow, g]);
      keyParts.push(ch + (child.eow ? '1' : '0') + (g ? g.id : 0));
    }
    const key = keyParts.join(',');
    let g = register.get(key);
    if (!g) { g = { edges, start: 0, id: nextId++ }; register.set(key, g); }
    return g;
  }
  return { rootGroup: groupOf(root), groupCount: register.size };
}

function serializeSection(rootGroup) {
  const entries = new Array(DATA_START).fill(0);
  entries[0] = SENTINEL_FIRST;
  entries[256] = SENTINEL_256;
  const done = new Set();
  function emit(g) {
    if (done.has(g)) return;
    done.add(g);
    for (const [, , child] of g.edges) if (child) emit(child);
    g.start = entries.length;
    const n = g.edges.length;
    for (let j = 0; j < n; j++) {
      const [ch, eow, child] = g.edges[j];
      entries.push(
        (ch.charCodeAt(0) | ((eow ? 1 : 0) << 8) | ((j === n - 1 ? 1 : 0) << 9) |
         ((child ? child.start : 0) << 10)) >>> 0);
    }
  }
  const byLetter = new Map();
  if (rootGroup) for (const [ch, eow, child] of rootGroup.edges) byLetter.set(ch, [eow, child]);
  const full = { edges: [], start: 0, id: 0 };
  for (let i = 0; i < 26; i++) {
    const ch = String.fromCharCode(97 + i);
    const [eow, child] = byLetter.get(ch) || [false, null];
    full.edges.push([ch, eow, child]);
  }
  for (const [, , child] of full.edges) if (child) emit(child);
  const rootIndex = entries.length;
  emit(full);
  for (let i = 0; i < 26; i++) entries[1 + i] = entries[rootIndex + i];
  if (rootIndex + 26 > 0x3fffff) throw new Error('section too large for 22-bit child pointers');
  return { entries, rootIndex };
}

/** Compile one word set into a section: { entries, rootIndex, groupCount, wordCount }. */
export function buildSection(words) {
  const sorted = [...new Set(words)].sort();
  const { rootGroup, groupCount } = minimizeGroups(buildTrie(sorted));
  const { entries, rootIndex } = serializeSection(rootGroup);
  return { entries, rootIndex, groupCount, wordCount: sorted.length };
}

export function headerBoundary(s1Root) { return Math.max(0, s1Root - 65536); }

/** Pack two compiled sections into the data-fork byte layout. */
export function packFile(s1, s2, boundary = headerBoundary(s1.rootIndex)) {
  const total = 3 + s1.entries.length + s2.entries.length;
  const out = new Uint8Array(total * 4);
  const view = new DataView(out.buffer);
  let o = 0;
  const put = (v) => { view.setUint32(o, v >>> 0, false); o += 4; };
  put(boundary); put(s1.rootIndex); put(s2.rootIndex);
  for (const e of s1.entries) put(e);
  for (const e of s2.entries) put(e);
  return out;
}

/**
 * Compile two word lists (iterables of strings; already normalised, or pass
 * options to normalise here) into a Maven data fork.
 */
export function compileDawg(s1Words, s2Words, options = null) {
  const w1 = options ? normalizeWords(s1Words, options) : s1Words;
  const w2 = options ? normalizeWords(s2Words, options) : s2Words;
  return packFile(buildSection(w1), buildSection(w2));
}

/** Read the words back out of one section (for verification). */
export function enumerateSection(entries, rootIndex) {
  const words = new Set();
  const stack = [[rootIndex, '']];
  while (stack.length) {
    let [idx, path] = stack.pop();
    for (;;) {
      const e = entries[idx];
      const letter = String.fromCharCode(e & 0xff);
      if (e & 0x100) words.add(path + letter);
      if (e >>> 10) stack.push([e >>> 10, path + letter]);
      if (e & 0x200) break;
      idx++;
    }
  }
  return words;
}

/** Parse a data fork into { boundary, sections: [{entries, rootIndex}, ...] }. */
export function unpackFile(bytes) {
  const view = new DataView(bytes.buffer, bytes.byteOffset, bytes.byteLength);
  const boundary = view.getUint32(0, false);
  const roots = [view.getUint32(4, false), view.getUint32(8, false)];
  if (bytes.byteLength !== 12 + 4 * (roots[0] + roots[1] + 52)) throw new Error('size does not match header');
  let o = 12;
  const sections = roots.map((rootIndex) => {
    const n = rootIndex + 26;
    const entries = new Array(n);
    for (let i = 0; i < n; i++, o += 4) entries[i] = view.getUint32(o, false);
    return { entries, rootIndex };
  });
  return { boundary, sections };
}
