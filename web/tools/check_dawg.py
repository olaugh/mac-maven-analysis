#!/usr/bin/env python3
"""Structural check of a Maven DAWG data fork.

Mirrors reconstruction/dictionary_validate.c (maven_validate_dictionary and
section_valid) step by step, but reports the first violation instead of just
returning 0.  Exit status 0 means the engine would accept the file.

Usage: python3 check_dawg.py FILE [FILE...]
"""
import struct
import sys


def be32(data, offset):
    return struct.unpack_from('>I', data, offset)[0]


def section_valid(p, base, root):
    """p: whole file, base: byte offset of the section, root: root index."""
    start, previous = 257, 0
    if be32(p, base) != 0x300:
        return f"entry 0 is {be32(p, base):#x}, expected 0x300"
    if be32(p, base + 256 * 4) != 0x200:
        return f"entry 256 is {be32(p, base + 1024):#x}, expected 0x200"
    for i in range(27, 256):
        if be32(p, base + 4 * i):
            return f"entry {i} is nonzero ({be32(p, base + 4 * i):#x})"
    if p[base + 4:base + 4 + 104] != p[base + 4 * root:base + 4 * root + 104]:
        return "entries 1..26 differ from the root group"
    for i in range(257, root + 26):
        node = be32(p, base + 4 * i)
        child, letter = node >> 10, node & 255
        if (letter != 0x20 and not (0x61 <= letter <= 0x7A)) or letter <= previous or (node & 0x80000000):
            return (f"entry {i} ({node:#x}): letter {letter:#x} not a-z, not ascending after "
                    f"{previous:#x}, or sign bit set")
        if child and (child < 257 or child >= start):
            return (f"entry {i} ({node:#x}): child {child} must be in [257, {start}) "
                    f"(children must point backward)")
        if i >= root and (letter != ord('a') + i - root or bool(node & 512) != (i == root + 25)):
            return f"entry {i} ({node:#x}): root group must be a..z with last-sibling only on z"
        if i == root and start != root:
            return f"root index {root} is not the start of a sibling group (group started at {start})"
        if node & 512:
            start, previous = i + 1, 0
        else:
            previous = letter
    if start != root + 26:
        return f"section does not end on a last-sibling entry (start={start}, expected {root + 26})"
    return None


def validate(data):
    """Returns (ok, message, [(offset, root), (offset, root)])."""
    size = len(data)
    if size < 12:
        return False, "file shorter than 12 bytes", None
    roots = [be32(data, 4), be32(data, 8)]
    lengths = []
    for i, r in enumerate(roots):
        if r < 257 or r > 0x1FFFFF - 26:
            return False, f"section {i+1} root {r} out of range", None
        lengths.append((r + 26) * 4)
    if lengths[0] > size - 12 or lengths[1] != size - 12 - lengths[0]:
        return False, (f"size mismatch: file {size}, header implies "
                       f"12 + {lengths[0]} + {lengths[1]} = {12 + sum(lengths)}"), None
    offset = 12
    sections = []
    for i, r in enumerate(roots):
        err = section_valid(data, offset, r)
        if err:
            return False, f"section {i+1}: {err}", None
        sections.append((offset, r))
        offset += lengths[i]
    return True, f"OK: boundary={be32(data, 0)}, roots={roots[0]},{roots[1]}, {size} bytes", sections


def main():
    if len(sys.argv) < 2:
        sys.exit(__doc__)
    bad = 0
    for path in sys.argv[1:]:
        ok, msg, _ = validate(open(path, 'rb').read())
        print(f"{path}: {msg}")
        bad += not ok
    sys.exit(1 if bad else 0)


if __name__ == "__main__":
    main()
