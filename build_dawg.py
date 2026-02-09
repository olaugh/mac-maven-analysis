#!/usr/bin/env python3
"""
Build Maven-format DAWG data fork from word lists.

Takes two word lists (S1=TWL, S2=OSW) and produces a binary file
in Maven's DAWG format that can replace the maven2 data fork.

Usage:
  python3 build_dawg.py lexica/s1_words.txt lexica/s2_words.txt -o maven2_new
  python3 build_dawg.py --verify     # round-trip test with existing maven2

File format:
  [12-byte header: boundary, s1_count, s2_count]
  [S1 entries × 4 bytes]
  [S1 letter index duplicate: 26 × 4 bytes]
  [S2 entries × 4 bytes]
  [S2 letter index duplicate: 26 × 4 bytes]

Entry format (32-bit big-endian):
  bits 0-7:   letter (0x61-0x7A)
  bit 8:      end-of-word
  bit 9:      last-sibling
  bits 10-31: child entry index
"""

import argparse
import struct
import sys
import os

DAWG_PATH = "/Volumes/T7/retrogames/oldmac/share/maven2"


class TrieNode:
    """Node in a trie/DAWG."""
    __slots__ = ['children', 'eow']

    def __init__(self):
        self.children = {}  # char -> TrieNode
        self.eow = False


def build_trie(words):
    """Build a trie from a sorted word list."""
    root = TrieNode()
    for word in words:
        node = root
        for ch in word:
            if ch not in node.children:
                node.children[ch] = TrieNode()
            node = node.children[ch]
        node.eow = True
    return root


def minimize_trie(root):
    """Minimize trie into a DAWG by merging identical subtrees.

    Uses bottom-up signature matching: two nodes are equivalent if they
    have the same eow flag and the same set of (letter, child_id) pairs
    after their children have been minimized.
    """
    register = {}  # signature -> canonical node

    def minimize(node):
        # Minimize children first (bottom-up)
        for ch in node.children:
            node.children[ch] = minimize(node.children[ch])

        # Build signature from minimized children
        sig = (node.eow, tuple(sorted(
            (ch, id(node.children[ch])) for ch in node.children
        )))

        if sig in register:
            return register[sig]
        register[sig] = node
        return node

    # Increase recursion limit for deep tries (longest words ~45 letters)
    old_limit = sys.getrecursionlimit()
    sys.setrecursionlimit(max(old_limit, 1000))
    result = minimize(root)
    sys.setrecursionlimit(old_limit)
    return result


def count_nodes(root):
    """Count unique nodes in a DAWG."""
    seen = set()

    def visit(node):
        if id(node) in seen:
            return
        seen.add(id(node))
        for child in node.children.values():
            visit(child)

    visit(root)
    return len(seen)


def serialize_dawg(root):
    """Serialize a DAWG into Maven-format entry list.

    Returns a list of 32-bit entry values.

    Layout:
      Entry 0: sentinel (0x00000000)
      Entries 1-26: root letter index (a=1, ..., z=26)
      Entries 27+: all other sibling groups (DFS order)
    """
    entries = [0] * 27  # sentinel + 26 root entries (placeholders)

    # Map: id(node) -> entry index of this node's children sibling group
    node_group_start = {}

    def alloc_and_recurse(node):
        """Allocate sibling group for node's children, then recurse DFS."""
        if id(node) in node_group_start:
            return  # shared DAWG node, already processed
        if not node.children:
            return  # leaf node, no children to serialize

        sorted_children = sorted(node.children.items())
        start = len(entries)
        node_group_start[id(node)] = start

        # Reserve entries for this sibling group
        entries.extend([0] * len(sorted_children))

        # DFS into children
        for ch, child_node in sorted_children:
            alloc_and_recurse(child_node)

        # Fill in entries (children's groups are now allocated)
        for j, (ch, child_node) in enumerate(sorted_children):
            letter_byte = ord(ch)
            eow = 1 if child_node.eow else 0
            last = 1 if j == len(sorted_children) - 1 else 0
            child_ptr = node_group_start.get(id(child_node), 0)
            entries[start + j] = (letter_byte
                                  | (eow << 8)
                                  | (last << 9)
                                  | (child_ptr << 10))

    # Process root's children in alphabetical order
    boundary = 0
    for i in range(26):
        letter = chr(ord('a') + i)
        if letter in root.children:
            alloc_and_recurse(root.children[letter])
        if letter == 'h':
            boundary = len(entries)  # a-h subtrees end here

    # Fill in root entries (1-26)
    for i in range(26):
        letter = chr(ord('a') + i)
        letter_byte = ord(letter)
        if letter in root.children:
            child_node = root.children[letter]
            eow = 1 if child_node.eow else 0
            child_ptr = node_group_start.get(id(child_node), 0)
        else:
            eow = 0
            child_ptr = 0
        last = 1 if i == 25 else 0
        entries[1 + i] = (letter_byte
                          | (eow << 8)
                          | (last << 9)
                          | (child_ptr << 10))

    return entries, boundary


def pack_file(s1_entries, s2_entries, boundary=0):
    """Pack two DAWG entry lists into Maven data fork format.

    Returns bytes ready to write as the data fork.
    """
    s1_count = len(s1_entries)
    s2_count = len(s2_entries)

    # Header: 3 × uint32 big-endian
    header = struct.pack('>III', boundary, s1_count, s2_count)

    # S1 entries
    s1_data = struct.pack(f'>{s1_count}I', *s1_entries)

    # S1 letter index duplicate (entries 1-26)
    s1_index = struct.pack(f'>26I', *s1_entries[1:27])

    # S2 entries
    s2_data = struct.pack(f'>{s2_count}I', *s2_entries)

    # S2 letter index duplicate (entries 1-26)
    s2_index = struct.pack(f'>26I', *s2_entries[1:27])

    return header + s1_data + s1_index + s2_data + s2_index


def enumerate_entries(entries):
    """Enumerate all words from a list of Maven DAWG entries.

    This is the inverse of serialize_dawg — used for verification.
    """
    words = set()

    for li in range(26):
        val = entries[1 + li]
        letter_byte = val & 0xFF
        if not (0x61 <= letter_byte <= 0x7A):
            continue
        child = val >> 10
        if child == 0:
            continue

        root_letter = chr(ord('a') + li)
        stack = [(child, root_letter)]

        while stack:
            idx, path = stack.pop()
            while True:
                if idx >= len(entries):
                    break
                e = entries[idx]
                ch_byte = e & 0xFF
                if not (0x61 <= ch_byte <= 0x7A):
                    break

                letter = chr(ch_byte)
                eow = (e >> 8) & 1
                last = (e >> 9) & 1
                child = e >> 10
                new_path = path + letter

                if eow:
                    words.add(new_path)
                if child > 0:
                    stack.append((child, new_path))
                if last:
                    break
                idx += 1

    return words


def load_words(path):
    """Load word list from file (one word per line, any case)."""
    words = set()
    with open(path) as f:
        for line in f:
            w = line.strip().lower()
            if w and w.isalpha():
                words.add(w)
    return words


def load_original_section(data, base, count):
    """Parse entries from original Maven data fork."""
    entries = []
    for i in range(count):
        offset = base + i * 4
        val = struct.unpack('>I', data[offset:offset + 4])[0]
        entries.append(val)
    return entries


def build_section(words, label=""):
    """Build a complete DAWG section from a word list.

    Returns list of entry values.
    """
    sorted_words = sorted(words)
    if label:
        print(f"  {label}: {len(sorted_words):,} words")

    # Build trie
    root = build_trie(sorted_words)
    if label:
        trie_nodes = count_nodes(root)
        print(f"  {label}: trie has {trie_nodes:,} nodes")

    # Minimize to DAWG
    root = minimize_trie(root)
    if label:
        dawg_nodes = count_nodes(root)
        print(f"  {label}: DAWG has {dawg_nodes:,} nodes ({100*dawg_nodes/trie_nodes:.0f}% of trie)")

    # Serialize
    entries, boundary = serialize_dawg(root)
    if label:
        print(f"  {label}: {len(entries):,} entries (boundary={boundary})")

    return entries, boundary


def verify():
    """Round-trip test: extract words from maven2, rebuild, verify match."""
    print("Loading original maven2...")
    with open(DAWG_PATH, 'rb') as f:
        data = f.read()

    field1 = struct.unpack('>I', data[0:4])[0]
    field2 = struct.unpack('>I', data[4:8])[0]
    field3 = struct.unpack('>I', data[8:12])[0]

    s1_base = 12
    s2_base = 116 + field2 * 4

    print(f"  Header: boundary={field1}, s1_count={field2}, s2_count={field3}")

    # Extract original entries
    s1_orig = load_original_section(data, s1_base, field2)
    s2_orig = load_original_section(data, s2_base, field3)

    # Enumerate words from original
    print("\nExtracting words from original DAWG...")
    s1_words = enumerate_entries(s1_orig)
    s2_words = enumerate_entries(s2_orig)
    print(f"  S1: {len(s1_words):,} words")
    print(f"  S2: {len(s2_words):,} words")

    # Rebuild
    print("\nRebuilding S1 DAWG...")
    s1_rebuilt, s1_boundary = build_section(s1_words, "S1")
    print("\nRebuilding S2 DAWG...")
    s2_rebuilt, _ = build_section(s2_words, "S2")

    # Verify round-trip
    print("\nVerifying round-trip...")
    s1_check = enumerate_entries(s1_rebuilt)
    s2_check = enumerate_entries(s2_rebuilt)

    s1_ok = s1_check == s1_words
    s2_ok = s2_check == s2_words
    print(f"  S1: {len(s1_check):,} words — {'PASS' if s1_ok else 'FAIL'}")
    print(f"  S2: {len(s2_check):,} words — {'PASS' if s2_ok else 'FAIL'}")

    if not s1_ok:
        missing = s1_words - s1_check
        extra = s1_check - s1_words
        if missing:
            print(f"  S1 missing: {sorted(missing)[:10]}")
        if extra:
            print(f"  S1 extra: {sorted(extra)[:10]}")

    if not s2_ok:
        missing = s2_words - s2_check
        extra = s2_check - s2_words
        if missing:
            print(f"  S2 missing: {sorted(missing)[:10]}")
        if extra:
            print(f"  S2 extra: {sorted(extra)[:10]}")

    # Compare entry counts and boundary
    print(f"\nEntry counts:")
    print(f"  S1: original={field2:,}, rebuilt={len(s1_rebuilt):,}")
    print(f"  S2: original={field3:,}, rebuilt={len(s2_rebuilt):,}")
    print(f"  Boundary: original={field1}, rebuilt={s1_boundary}")

    # Pack and compare file sizes
    rebuilt_data = pack_file(s1_rebuilt, s2_rebuilt, boundary=s1_boundary)
    print(f"\nFile sizes:")
    print(f"  Original: {len(data):,} bytes")
    print(f"  Rebuilt:  {len(rebuilt_data):,} bytes")

    if s1_ok and s2_ok:
        print("\nRound-trip verification PASSED")
    else:
        print("\nRound-trip verification FAILED")
        return False

    return True


def main():
    parser = argparse.ArgumentParser(
        description="Build Maven-format DAWG data fork from word lists")
    parser.add_argument('s1_file', nargs='?',
                        help='S1 (TWL) word list file')
    parser.add_argument('s2_file', nargs='?',
                        help='S2 (OSW) word list file')
    parser.add_argument('-o', '--output', default='maven2_new',
                        help='Output file path (default: maven2_new)')
    parser.add_argument('--verify', action='store_true',
                        help='Round-trip test with existing maven2')
    parser.add_argument('--boundary', type=int, default=0,
                        help='Header boundary field value (default: 0)')
    args = parser.parse_args()

    if args.verify:
        ok = verify()
        sys.exit(0 if ok else 1)

    if not args.s1_file or not args.s2_file:
        parser.error("S1 and S2 word list files required (or use --verify)")

    print(f"Loading word lists...")
    s1_words = load_words(args.s1_file)
    s2_words = load_words(args.s2_file)
    print(f"  S1: {len(s1_words):,} words from {args.s1_file}")
    print(f"  S2: {len(s2_words):,} words from {args.s2_file}")

    print(f"\nBuilding S1 DAWG...")
    s1_entries, s1_boundary = build_section(s1_words, "S1")

    print(f"\nBuilding S2 DAWG...")
    s2_entries, _ = build_section(s2_words, "S2")

    # Verify before writing
    print(f"\nVerifying built DAWGs...")
    s1_check = enumerate_entries(s1_entries)
    s2_check = enumerate_entries(s2_entries)
    s1_ok = s1_check == s1_words
    s2_ok = s2_check == s2_words
    print(f"  S1: {'PASS' if s1_ok else 'FAIL'} ({len(s1_check):,} words)")
    print(f"  S2: {'PASS' if s2_ok else 'FAIL'} ({len(s2_check):,} words)")

    if not (s1_ok and s2_ok):
        print("ERROR: Verification failed, not writing output")
        sys.exit(1)

    # Pack and write
    boundary = args.boundary if args.boundary else s1_boundary
    output_data = pack_file(s1_entries, s2_entries, boundary=boundary)
    with open(args.output, 'wb') as f:
        f.write(output_data)
    print(f"\nWrote {len(output_data):,} bytes to {args.output}")
    print(f"  S1: {len(s1_entries):,} entries")
    print(f"  S2: {len(s2_entries):,} entries")


if __name__ == "__main__":
    main()
