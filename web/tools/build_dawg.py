#!/usr/bin/env python3
"""
Build a Maven-format DAWG data fork from two word lists.

This is the web/ copy of the repository-root build_dawg.py, corrected so that
the produced file is accepted by the reconstructed engine's validator
(reconstruction/dictionary_validate.c) and, for the original word lists,
reproduces the shipped maven2.1 data fork byte for byte.

Usage:
  python3 build_dawg.py S1.txt S2.txt -o out.dawg [--max-length 15]
  python3 build_dawg.py --verify ORIGINAL_FILE   # rebuild from ORIGINAL and diff

File format (all values 32-bit big-endian):
  header:  boundary, s1_root, s2_root
  section 1: (s1_root + 26) entries
  section 2: (s2_root + 26) entries

Section layout (entry indices):
  0        0x00000300  sentinel (letter 0, end-of-word, last-sibling)
  1..26    copy of the root group (a..z)
  27..255  zero
  256      0x00000200  sentinel (letter 0, last-sibling)
  257..    sibling groups in post-order DFS: every child group is emitted
           before the group that references it, so all child pointers point
           backwards; letters ascend within a group
  root..root+25  the root group a..z (last-sibling on z); root == header count

Entry format:
  bits 0-7   letter (0x61..0x7A)
  bit 8      end-of-word: the word ending with this letter is valid
  bit 9      last-sibling
  bits 10-31 index of this node's child group (0 = no children)

Because end-of-word lives in the edge entry (in the parent's group), two
nodes with identical child groups share that group regardless of their own
end-of-word status.  The minimisation is therefore keyed on the tuple of
(letter, child_end_of_word, child_group) edges, not on the node.  This is
what the original compiler did: with the node-keyed signature the S1 section
would need 122,979 entries instead of the shipped 122,166.

The header's first word is s1_root - 65536 in the original (56,630 =
122,166 - 65,536).  The reconstructed engine never reads it; it is reproduced
here for fidelity and clamped at zero for small lexica.
"""

import argparse
import hashlib
import re
import struct
import sys

WORD_RE = re.compile(r'^[a-z]+$')
SENTINEL_FIRST = 0x300
SENTINEL_256 = 0x200
DATA_START = 257


class TrieNode:
    __slots__ = ['children', 'eow']

    def __init__(self):
        self.children = {}
        self.eow = False


class Group:
    """A sibling group: the edges leaving one (merged) node."""
    __slots__ = ['edges', 'start']

    def __init__(self, edges):
        self.edges = edges  # list of (letter, eow, child Group or None)
        self.start = 0


def build_trie(words):
    root = TrieNode()
    for word in words:
        node = root
        for ch in word:
            nxt = node.children.get(ch)
            if nxt is None:
                nxt = node.children[ch] = TrieNode()
            node = nxt
        node.eow = True
    return root


def minimize_groups(root):
    """Convert the trie into a minimal set of shared sibling groups.

    Returns (root_group, group_count).  The register key for a group is the
    tuple of its edges (letter, child_eow, id(child_group)); the identity of
    the node owning the group does not include its own end-of-word flag.
    """
    register = {}
    old_limit = sys.getrecursionlimit()
    sys.setrecursionlimit(max(old_limit, 10000))

    def group_of(node):
        if not node.children:
            return None
        edges = []
        for ch in sorted(node.children):
            child = node.children[ch]
            edges.append((ch, child.eow, group_of(child)))
        key = tuple((ch, eow, id(g)) for ch, eow, g in edges)
        g = register.get(key)
        if g is None:
            g = Group(edges)
            register[key] = g
        return g

    try:
        root_group = group_of(root)
    finally:
        sys.setrecursionlimit(old_limit)
    return root_group, len(register)


def serialize_section(root_group):
    """Serialize a minimised DAWG into a Maven section.

    Returns (entries, root_index).  The root group is emitted last, after
    every letter subtree, and copied into entries 1..26.
    """
    entries = [SENTINEL_FIRST] + [0] * 255 + [SENTINEL_256]
    assert len(entries) == DATA_START
    done = set()

    def emit(g):
        if id(g) in done:
            return
        done.add(id(g))
        for _, _, child in g.edges:
            if child is not None:
                emit(child)
        g.start = len(entries)
        n = len(g.edges)
        for j, (ch, eow, child) in enumerate(g.edges):
            entries.append(ord(ch)
                           | ((1 if eow else 0) << 8)
                           | ((1 if j == n - 1 else 0) << 9)
                           | ((child.start if child is not None else 0) << 10))

    # A lexicon lacking some initial letter still needs a full a..z root group.
    by_letter = {ch: (eow, child) for ch, eow, child in root_group.edges}
    full = Group([(chr(97 + i),) + by_letter.get(chr(97 + i), (False, None))
                  for i in range(26)])
    for _, _, child in full.edges:
        if child is not None:
            emit(child)
    root_index = len(entries)
    emit(full)
    entries[1:27] = entries[root_index:root_index + 26]
    if root_index + 26 > 0x3FFFFF:
        raise ValueError("section too large for 22-bit child pointers")
    return entries, root_index


def build_section(words, label=""):
    """Word iterable -> (entries, root_index)."""
    sorted_words = sorted(set(words))
    root = build_trie(sorted_words)
    root_group, group_count = minimize_groups(root)
    if root_group is None:
        root_group = Group([])
    entries, root_index = serialize_section(root_group)
    if label:
        print(f"  {label}: {len(sorted_words):,} words, {group_count:,} sibling groups, "
              f"root index {root_index:,}, {len(entries):,} entries")
    return entries, root_index


def header_boundary(s1_root):
    return max(0, s1_root - 65536)


def pack_file(s1_entries, s1_root, s2_entries, s2_root, boundary=None):
    if boundary is None:
        boundary = header_boundary(s1_root)
    assert len(s1_entries) == s1_root + 26 and len(s2_entries) == s2_root + 26
    return (struct.pack('>III', boundary, s1_root, s2_root)
            + struct.pack(f'>{len(s1_entries)}I', *s1_entries)
            + struct.pack(f'>{len(s2_entries)}I', *s2_entries))


def compile_dawg(s1_words, s2_words, verbose=False):
    """Two word iterables -> data fork bytes."""
    s1, r1 = build_section(s1_words, "S1" if verbose else "")
    s2, r2 = build_section(s2_words, "S2" if verbose else "")
    return pack_file(s1, r1, s2, r2)


# --- reading -----------------------------------------------------------------

def unpack_file(data):
    """Data fork bytes -> [(entries, root_index), (entries, root_index)]."""
    boundary, r1, r2 = struct.unpack('>III', data[:12])
    n1, n2 = r1 + 26, r2 + 26
    if len(data) != 12 + 4 * (n1 + n2):
        raise ValueError(f"size {len(data)} does not match header roots {r1}, {r2}")
    s1 = list(struct.unpack(f'>{n1}I', data[12:12 + 4 * n1]))
    s2 = list(struct.unpack(f'>{n2}I', data[12 + 4 * n1:]))
    return boundary, [(s1, r1), (s2, r2)]


def enumerate_entries(entries, root_index=None):
    """Enumerate every word of a section (letters are taken verbatim, so the
    three trailing-space words of the shipped lexicon are returned as-is)."""
    if root_index is None:
        root_index = 1  # entries 1..26 duplicate the root group
    words = set()
    stack = [(root_index, '')]
    while stack:
        idx, path = stack.pop()
        while True:
            e = entries[idx]
            letter = chr(e & 0xFF)
            if e & 0x100:
                words.add(path + letter)
            if e >> 10:
                stack.append((e >> 10, path + letter))
            if e & 0x200:
                break
            idx += 1
    return words


def load_words(path, min_length=2, max_length=None):
    """One word per line, any case; keeps only ASCII a-z words in range."""
    words = set()
    with open(path, encoding='utf-8', errors='replace') as f:
        for line in f:
            w = line.strip().lower()
            if not WORD_RE.match(w):
                continue
            if len(w) < min_length or (max_length and len(w) > max_length):
                continue
            words.add(w)
    return words


# --- commands -----------------------------------------------------------------

def verify(original_path):
    """Rebuild from the words in ORIGINAL and require a byte-identical file."""
    data = open(original_path, 'rb').read()
    boundary, sections = unpack_file(data)
    print(f"Original: {len(data):,} bytes, boundary={boundary}, "
          f"roots={sections[0][1]},{sections[1][1]}")
    word_sets = [enumerate_entries(e, r) for e, r in sections]
    for i, ws in enumerate(word_sets):
        odd = sorted(w for w in ws if not WORD_RE.match(w))
        print(f"  S{i+1}: {len(ws):,} words" + (f", non a-z: {odd}" if odd else ""))
    rebuilt = compile_dawg(word_sets[0], word_sets[1], verbose=True)
    same = rebuilt == data
    print(f"Rebuilt: {len(rebuilt):,} bytes, byte-identical: {same}")
    if not same:
        for i, (x, y) in enumerate(zip(rebuilt, data)):
            if x != y:
                print(f"  first difference at byte {i} (entry {(i-12)//4})")
                break
    return same


def main():
    p = argparse.ArgumentParser(description=__doc__,
                                formatter_class=argparse.RawDescriptionHelpFormatter)
    p.add_argument('s1_file', nargs='?', help='S1 (North American) word list')
    p.add_argument('s2_file', nargs='?', help='S2 (British/Collins) word list')
    p.add_argument('-o', '--output', default='maven2_new')
    p.add_argument('--min-length', type=int, default=2)
    p.add_argument('--max-length', type=int, default=0,
                   help='drop words longer than this (0 = keep all)')
    p.add_argument('--verify', metavar='ORIGINAL',
                   help='rebuild from the words in ORIGINAL and diff')
    a = p.parse_args()

    if a.verify:
        sys.exit(0 if verify(a.verify) else 1)
    if not a.s1_file or not a.s2_file:
        p.error("S1 and S2 word list files required (or --verify ORIGINAL)")

    s1_words = load_words(a.s1_file, a.min_length, a.max_length or None)
    s2_words = load_words(a.s2_file, a.min_length, a.max_length or None)
    print(f"Loaded S1: {len(s1_words):,} words from {a.s1_file}")
    print(f"Loaded S2: {len(s2_words):,} words from {a.s2_file}")
    data = compile_dawg(s1_words, s2_words, verbose=True)

    _, sections = unpack_file(data)
    ok = [enumerate_entries(e, r) == ws for (e, r), ws in zip(sections, (s1_words, s2_words))]
    print(f"Round trip: S1 {'PASS' if ok[0] else 'FAIL'}, S2 {'PASS' if ok[1] else 'FAIL'}")
    if not all(ok):
        sys.exit("ERROR: round-trip verification failed, not writing output")
    with open(a.output, 'wb') as f:
        f.write(data)
    print(f"Wrote {len(data):,} bytes to {a.output} "
          f"(sha256 {hashlib.sha256(data).hexdigest()[:16]}...)")


if __name__ == "__main__":
    main()
