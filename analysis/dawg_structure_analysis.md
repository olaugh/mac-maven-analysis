# Maven DAWG Structure Analysis

## Overview

Maven uses a dual-section DAWG (Directed Acyclic Word Graph) stored in its data fork.
Section 1 is a reversed cross-check DAWG used during move generation.
Section 2 is a forward dictionary DAWG matching OSW (Official Scrabble Words) with 99.4% accuracy.

### File Location
- `/share/maven2` - DAWG data fork (1,070,788 bytes)
- `maven2` and `maven2.1` are identical (MD5: 021075b71871d9d3ffbb9e695be0c302)
- File type: APPL/MAVN (Classic Mac application; DAWG is in data fork, CODE in resource fork)

## Runtime Entry Format (QEMU-Verified)

Each DAWG entry is a 32-bit big-endian value. From CODE 15 disassembly (confirmed via QEMU):

```
Bits 0-7:   Letter (ASCII lowercase, 'a'=0x61 to 'z'=0x7A)
Bit 8:      End-of-word flag     (ANDI.L #$100)
Bit 9:      Last-sibling flag    (BTST #9)
Bits 10-31: Child node index     (LSR.L #10, 22 bits)
```

**Previous analysis documents used incorrect byte-level interpretations.**
The runtime format treats each entry as a single 32-bit word, not as separate byte fields.

## File Layout

```
Offset      Size        Content
0           12          Header (3 × 32-bit values)
12          4           S1 entry 0: sentinel (0x00000300)
16          104         S1 entries 1-26: letter index (a-z)
120         920         S1 entries 27-256: zeros (padding)
1040        488,536     S1 entries 257-122,165: DAWG node data
488,676     104         S1 entries 122,166-122,191: letter index COPY
488,780     4           S2 entry 0: sentinel (0x00000300)
488,784     104         S2 entries 1-26: letter index (a-z)
488,888     581,796     S2 entries 27-145,475: DAWG node data
1,070,684   104         S2 entries 145,476-145,501: letter index COPY
```

Total: 1,070,788 bytes ✓

### Header (12 bytes)

| Offset | Value   | Description | Runtime Storage |
|--------|---------|-------------|-----------------|
| 0      | 56,630  | Section 1 data size | A5-15506 (CODE 5) |
| 4      | 122,166 | Total S1 entries (incl. header) | A5-8588 (CODE 2) |
| 8      | 145,476 | S2 total entries / field3 | A5-8592 (CODE 2) |

### Base Pointer Computation (from CODE 2 disassembly)

```asm
MOVE.L  4(A4),-8588(A5)   ; g_field2 = *(data+4) = 122,166
MOVE.L  8(A4),-8592(A5)   ; g_field3 = *(data+8) = 145,476
LEA     12(A4),A0          ; A0 = data + 12
MOVE.L  A0,-8596(A5)       ; g_s1_base = data + 12
; S2 base computation:
; g_s2_base = data + 116 + field2 * 4 = data + 488,780
```

### Letter Index Format

Entries 1-26 of each section base form a letter index (a-z). Each entry uses the same
32-bit runtime format. The `child` field (bits 10-31) points to the root sibling group
for that letter's subtree.

Example (S1 letter index):

| Letter | Entry | Child | Range |
|--------|-------|-------|-------|
| a | 1 | 10,834 | < 56,630 (S1 data) |
| h | 8 | 54,462 | < 56,630 (S1 data) |
| i | 9 | 59,070 | > 56,630 (extends into S2 range) |
| t | 20 | 112,697 | >> 56,630 |
| z | 26 | 122,158 | Near end of S1 entries |

**Key observation**: S1 letter index child pointers span the entire 0-122,165 range.
Letters a-h have subtrees starting in entries < 56,630; letters i-z extend beyond.
The header value 56,630 is NOT a traversal boundary.

### Sentinel and Index Copies

Each section has a sentinel entry (val=0x00000300 = null letter, last=1, child=0) at
position 0, followed by the 26-entry letter index. A COPY of the letter index appears
after the data entries. This copy enables the CODE 2 base pointer formula:

```
S2_base = file + 12 + 104 + field2 * 4
        = S1_base + (26 * 4) + (field2 * 4)
```

The 26-entry letter index copy at the end of S1 is effectively "skipped over" by adding
104 (26 × 4) to the S2 offset.

## Section 2: Forward Dictionary (OSW)

S2 is a standard forward DAWG. Words are looked up left-to-right starting from the
letter index.

### Validation Results

| Reference List | S2 Match Rate | Notes |
|----------------|---------------|-------|
| OSW (121,905 words) | 99.4% (121,168) | Primary dictionary |
| TWL (148,882 words) | 76.4% (113,731) | Partial (shared words only) |
| SOWPODS (220,184 words) | 84.0% (185,012) | OSW + shared |
| OSW 2-letter words | **100%** (105/105) | Perfect match |

S2 contains all OSW words plus a small number of extras (e.g., aw, bi, pe, ph, qi, xu).
TWL-only words (e.g., aah, aahed, ag, et, hm, uh) are NOT in S2.

### S2 Validation Algorithm

```python
def validate_s2(word):
    """Forward dictionary lookup in S2."""
    s2_entry = read_entry(s2_base, 1 + letter_index(word[0]))
    siblings = get_siblings(s2_base, s2_entry.child)
    return match_forward(siblings, word[1:])

def match_forward(siblings, remaining):
    for entry in siblings:
        if entry.letter == remaining[0]:
            if len(remaining) == 1:
                return entry.eow == 1
            return match_forward(get_siblings(s2_base, entry.child), remaining[1:])
    return False
```

## Section 1: Reversed Cross-Check DAWG

S1 stores reversed word fragments for cross-check computation during move generation.
The `eow` flag in S1 does NOT reliably indicate dictionary word membership.

### S1 Characteristics

- Words are stored reversed (e.g., "cat" → "tac")
- Letter index entry for 'X' leads to subtrees of words ending in 'X'
- The eow flag marks valid cross-check positions, not just complete words
- S1 produces ~96 "valid" 2-letter words vs SOWPODS's 120 (54 matches, 42 false positives)
- S1 validates only ~1% of random longer words

### Cross-Check Interpretation

For Scrabble move generation, when placing a tile at a board position, Maven must check
if adjacent letters form valid cross-words. S1 enables this by:
1. Looking up the last letter of the cross-word segment
2. Walking backward through the reversed DAWG
3. The eow flag indicates "this letter sequence can end a valid word here"

This explains the false positives: "ea", "fe", "ob" etc. are not SOWPODS words but ARE
valid letter sequences that can appear at the end of words during cross-checking.

## Lexicon Modes (from CODE 5)

| Mode | Name | Dictionary |
|------|------|------------|
| 1 | NA/TWL | Tournament Word List (North America) |
| 2 | UK/OSW | Official Scrabble Words (International) |
| 3 | Both/SOWPODS | Combined TWL + OSW |

**S2 corresponds to Mode 2 (OSW)**. The mechanism for Mode 1 (TWL-only words) is not
yet fully understood. TWL-only words like "aah", "ag", "hm" are not found in either
section using current traversal algorithms.

## Traversal Behavior

CODE 15 (`walk_to_child` at offset 0x00CE) traverses the DAWG with **no boundary check**:

```c
while (target_letter != '\0') {
    long entry = dawg_base[current_pos];
    char entry_letter = (char)(entry & 0xFF);
    if (entry_letter == target_letter) {
        long child_pos = entry >> 10;
        if (child_pos == 0) break;          // null child = dead end
        (*pattern_ptr)++;
        target_letter = **pattern_ptr;
        current_pos = child_pos;
    } else if (entry & 0x200) {             // bit 9 = last sibling
        return 0;                           // letter not found
    } else {
        current_pos++;                      // try next sibling
    }
}
```

The function uses a single base pointer (`g_dawg_base_ptr` at A5-11960) which can be
set to either S1 or S2 base before invocation.

## Open Questions

1. **TWL-only word validation**: How does Maven validate TWL-only words (ag, aah, hm, etc.)
   that are not in S2? Possibly through S1 with a different traversal, or a separate
   data structure not yet identified.

2. **S1 eow semantics**: The exact meaning of the eow flag in S1 entries. Is it purely
   cross-check validity, or does it encode lexicon membership for one dictionary?

3. **Entries 27-256 (zeros)**: Why 230 entries of padding between the letter index and
   node data? Reserved space for future use?

4. **The 56,630 boundary**: How this value is used at runtime. It's stored in A5-15506
   (CODE 5) but doesn't appear to be a traversal boundary.

## Statistics

| Metric | Value |
|--------|-------|
| File size | 1,070,788 bytes |
| S1 entries (incl. header) | 122,166 |
| S2 entries (incl. header) | 145,476 |
| S1 letter index child range | 288 - 122,158 |
| S2 letter index child range | 274 - 145,467 |
| S2 validated OSW words | 121,168 / 121,905 (99.4%) |
| S2 validated SOWPODS words | 185,012 / 220,184 (84.0%) |
