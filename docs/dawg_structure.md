# Maven DAWG Structure -- Definitive Technical Reference

## 1. Overview

Maven (APPL/MAVN, Classic Mac) stores its Scrabble dictionaries as a DAWG (Directed Acyclic Word Graph) in the application's data fork. A DAWG is a trie that has been minimized by merging identical subtrees, producing a compact read-only data structure for set membership testing. Given a word, the DAWG answers "is this word in the dictionary?" in time proportional to the word's length, using far less memory than a flat word list.

Maven's data fork contains two independent DAWG sections:

| Section | Dictionary | Words | Description |
|---------|-----------|-------|-------------|
| S1 | TWL98 (Tournament Word List) | 172,233 | North American tournament dictionary |
| S2 | OSW (Official Scrabble Words) | 210,643 | International/Chambers-based dictionary |

Both sections store words **forward** (left-to-right). An earlier hypothesis that S1 was a reversed cross-check DAWG was incorrect and was disproved during the project. S1 and S2 are structurally identical forward DAWGs over different word sets.

### File Location

- Path: data fork of the Maven application (`/share/maven2`)
- Size: 1,070,788 bytes
- Files `maven2` and `maven2.1` are byte-identical (MD5: `021075b71871d9d3ffbb9e695be0c302`)
- The resource fork (CODE segments, MUL, ESTR, etc.) is separate and unaffected by dictionary changes

---

## 2. Entry Format

Each DAWG entry is a **32-bit big-endian** value. The bit layout, verified from four independent CODE resource disassemblies, is:

```
 31                              10 9  8  7                 0
+----------------------------------+--+--+------------------+
|        child pointer (22 bits)   | L| W|  letter (8 bits) |
+----------------------------------+--+--+------------------+

Bits 0-7:    Letter -- ASCII lowercase (0x61 'a' through 0x7A 'z')
Bit 8:       End-of-word (EOW) flag -- 1 if a valid word ends at this node
Bit 9:       Last-sibling flag -- 1 if this is the last entry in its sibling group
Bits 10-31:  Child pointer -- 22-bit index of the first entry in this node's child sibling group (0 = no children / leaf)
```

### Disassembly Evidence

The bit layout is confirmed by four independent CODE resources:

- **CODE 15** (`walk_to_child`, offset 0x00CE): `entry & 0xFF` for letter, `BTST #9` for last-sibling, `entry >> 10` for child pointer
- **CODE 37** (`traverse_and_gen`, offset 0x024A): `ASL.L #2,D0` for 4-byte indexing, `BTST #9,D7` for last-sibling, `MOVEQ #10,D1; ASR.L D1,D0` for child extraction
- **CODE 12** (recursive DAWG search, offset 0x03AA): `entry & 0xFF` for letter, `ANDI.L #$100` for EOW, `BTST #9` for last-sibling, `LSR.L #10` for child pointer
- **CODE 37** (`generate_cross_check_sets`, offset 0x010E): `ASL.L #2,D0` confirming 4-byte entry size

### Encoding Example

The S1 entry for root letter 'a' (entry index 1) has value `0x00A94861`:

```
0x00A94861 = 0000 0000 1010 1001 0100 1000 0110 0001
                                                ^^^^^^^^  letter = 0x61 = 'a'
                                              ^           EOW = 0
                                             ^            last = 0
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^                            child = 0x2A52 = 10834
```

This means: letter 'a', not end-of-word, not last sibling, children start at entry 10,834.

---

## 3. File Layout

The data fork is organized as follows:

```
Offset       Size (bytes)   Content
-----------  -------------  ------------------------------------------
0            12             Header: 3 x uint32 big-endian
12           488,664        S1 entries: 122,166 x 4 bytes
488,676      104            S1 letter index copy: 26 x 4 bytes
488,780      581,904        S2 entries: 145,476 x 4 bytes
1,070,684    104            S2 letter index copy: 26 x 4 bytes
-----------  -------------  ------------------------------------------
Total:       1,070,788 bytes
```

**Total size formula**: `12 + s1_count*4 + 104 + s2_count*4 + 104`

With the original values: `12 + 122166*4 + 104 + 145476*4 + 104 = 1,070,788`. Verified.

### 3.1 Header (12 bytes)

| Offset | Field | Value | Runtime Storage | Description |
|--------|-------|-------|-----------------|-------------|
| 0 | boundary | 56,630 | A5-15506 (CODE 5) | DFS ordering artifact (see Section 8) |
| 4 | s1_count | 122,166 | A5-8588 (CODE 2) | Total S1 entries (sentinel + index + data) |
| 8 | s2_count | 145,476 | A5-8592 (CODE 2) | Total S2 entries (sentinel + index + data) |

### 3.2 Section Structure

Each section (S1 and S2) has identical internal structure:

| Entry Index | Content |
|-------------|---------|
| 0 | Sentinel entry: `0x00000300` |
| 1-26 | Letter index: one entry per letter (a=1, b=2, ..., z=26) |
| 27-255 | Zero padding (229 entries of `0x00000000`) |
| 256 | Additional sentinel: `0x00000200` (last-sibling flag set, null letter) |
| 257+ | DAWG node data: sibling groups in DFS order |

The sentinel at entry 0 has value `0x00000300`, which decodes as: null letter byte (0x00), EOW=1, last-sibling=1, child=0. This ensures that any traversal reaching entry 0 terminates cleanly.

Entry 256 (`0x00000200`) serves as a last-sibling terminator with no letter, no EOW, and no children. The 229 zero entries between the letter index and entry 256 appear to be reserved padding.

### 3.3 Letter Index Copies

After each section's entry data, a **copy** of that section's letter index (entries 1-26) appears as 26 x 4 bytes = 104 bytes. These copies are byte-identical to entries 1-26. They exist to make the S2 base pointer formula work (see Section 4).

---

## 4. Base Pointer Computation

At runtime, Maven computes base pointers for both sections from the header fields. From CODE 2 disassembly:

```asm
MOVE.L  4(A4),-8588(A5)    ; g_field2 = *(data+4) = 122,166  (s1_count)
MOVE.L  8(A4),-8592(A5)    ; g_field3 = *(data+8) = 145,476  (s2_count)
LEA     12(A4),A0           ; A0 = data + 12
MOVE.L  A0,-8596(A5)        ; g_s1_base = data + 12
```

The S2 base pointer is computed as:

```
g_s2_base = data + 116 + field2 * 4
          = data + 12 + 104 + field2 * 4
          = data + 12 + (26 * 4) + (field2 * 4)
          = s1_base + 104 + s1_count * 4
```

The constant 116 = 12 (header) + 104 (S1 letter index copy). The letter index copy at the end of S1 is what bridges the gap: it is "skipped over" by adding 104 to the base offset. This design means the S2 base pointer is always exactly 104 bytes past the end of S1's entry data, regardless of how many entries S1 contains.

**Concrete values:**

| Pointer | Formula | Byte Offset |
|---------|---------|-------------|
| S1 base | data + 12 | 12 |
| S2 base | data + 116 + 122,166 * 4 | 488,780 |

Stored in globals: S1 base at A5-8596, S2 base computed and used via the letter-set table at A5-11960.

---

## 5. Traversal Algorithm

### 5.1 walk_to_child (CODE 15)

The primary traversal function, verified from CODE 15 disassembly at offset 0x00CE:

```c
short walk_to_child(char **pattern_ptr) {
    char target_letter = **pattern_ptr;

    while (target_letter != '\0') {
        long entry = dawg_base[current_pos];
        char entry_letter = (char)(entry & 0xFF);

        if (entry_letter == target_letter) {
            long child_pos = entry >> 10;
            if (child_pos == 0)
                break;                   // leaf node, no children
            (*pattern_ptr)++;
            target_letter = **pattern_ptr;
            current_pos = child_pos;     // descend to child
        } else if (entry & 0x200) {      // bit 9 = last sibling
            return 0;                    // letter not found in group
        } else {
            current_pos++;               // try next sibling
        }
    }
    return (entry >> 8) & 1;            // return EOW flag
}
```

Key characteristics:
- **No bounds checking**: the function never compares `current_pos` against the section's entry count
- **No checksums**: no integrity validation of any kind
- **Single base pointer**: `g_dawg_base_ptr` (A5-11968) is set to either S1 or S2 base before each call
- **Linear sibling scan**: within a sibling group, entries are checked sequentially until a match is found or the last-sibling flag terminates the scan
- **4-byte indexing**: confirmed by `ASL.L #2,D0` (multiply index by 4) at multiple code sites

### 5.2 Recursive DAWG Search (CODE 12)

CODE 12 at offset 0x03AA implements a recursive search that enumerates valid words from available letters (rack + board tiles):

```c
void recursive_dawg_search(long node_index) {
    if (found_count >= 1000) return;       // hard limit

    while (1) {
        long entry = dawg_base[node_index++];
        char letter = entry & 0xFF;
        short *avail = &letter_available[letter];

        if (*avail > 0) {
            (*avail)--;                     // consume letter
            if (entry & 0x100)              // EOW: word found
                add_word();
            if (entry >> 10)                // has children
                recursive_dawg_search(entry >> 10);
            (*avail)++;                     // restore letter
        }

        // Also try blank tile as wildcard for this letter
        if (blank_count > 0) {
            blank_count--;
            if (entry >> 10)
                recursive_dawg_search(entry >> 10);
            blank_count++;
        }

        if (entry & 0x200) break;          // last sibling
    }
}
```

This is a standard depth-first DAWG traversal with backtracking, using rack letter counts as constraints and blanks as wildcards. The 1,000-word limit is enforced at entry.

---

## 6. Dictionary Contents

### 6.1 Word Counts

| Metric | Count |
|--------|-------|
| S1 (TWL98) | 172,233 |
| S2 (OSW) | 210,643 |
| Common (S1 intersection S2) | 129,832 |
| S1-only (TWL but not OSW) | 42,401 |
| S2-only (OSW but not TWL) | 80,811 |
| Union (S1 union S2) | 253,076 |

### 6.2 Reference Comparisons

**S1 vs TWL98 reference** (172,236 words):
- S1 contains 172,233 of 172,236 TWL98 words (99.998%)
- 3 TWL98 words missing from S1: `antichoicers`, `antipruritics`, `nonintoxicants`
- 0 words in S1 that are not in TWL98

**S2 vs SOWPODS 2003 reference**:
- S2 matches SOWPODS/OSWI to within 2 words in each direction
- 2 apparent typos in S2 not found in any reference list: `interweove`, `interweoven`

**Union (S1 union S2) = SOWPODS equivalent**: The combined word set of both sections matches SOWPODS 2003 to within the small discrepancies noted above.

### 6.3 Length Distribution

| Length | S1 (TWL) | S2 (OSW) | Common | S1-only | S2-only |
|--------|----------|----------|--------|---------|---------|
| 2 | 96 | 113 | 89 | 7 | 24 |
| 3 | 972 | 1,147 | 871 | 101 | 276 |
| 4 | 3,903 | 4,590 | 3,443 | 460 | 1,147 |
| 5 | 8,636 | 10,230 | 7,367 | 1,269 | 2,863 |
| 6 | 15,232 | 18,404 | 12,601 | 2,631 | 5,803 |
| 7 | 23,109 | 28,278 | 18,508 | 4,601 | 9,770 |
| 8 | 28,419 | 34,737 | 21,790 | 6,629 | 12,947 |
| 9 | 24,875 | 30,209 | 18,271 | 6,604 | 11,938 |
| 10 | 20,297 | 24,980 | 14,444 | 5,853 | 10,536 |
| 11 | 15,464 | 19,299 | 10,698 | 4,766 | 8,601 |
| 12 | 11,373 | 14,270 | 7,830 | 3,543 | 6,440 |
| 13 | 8,112 | 10,142 | 5,500 | 2,612 | 4,642 |
| 14 | 5,583 | 6,898 | 3,720 | 1,863 | 3,178 |
| 15 | 3,684 | 4,564 | 2,500 | 1,184 | 2,064 |

---

## 7. Lexicon Modes

Maven supports three dictionary modes, controlled by a lexicon state machine in CODE 11 and a 14-entry validation table at A5-24244:

| Mode | Name | Validation Rule |
|------|------|----------------|
| 1 | TWL (North American) | Word must be in S1 |
| 2 | OSW (International) | Word must be in S2 |
| 3 | Both / SOWPODS | Word must be in S1 or S2 |

### 7.1 Validation Table (CODE 11, offset 0x111C)

The validation table is a 14-entry lookup (56 bytes at A5-24244). Each entry is 4 bytes:

```c
typedef struct {
    signed char condition;      // must match g_validation_state, or 0xFF = wildcard
    signed char required_mode;  // must match g_lexicon_mode
    signed char result;         // return value if both conditions match
    char        padding;
} ValidationEntry;
```

The runtime reads the table linearly, returning the result from the first entry where both the condition and mode match. This table-driven design allows Maven to determine word validity for any lexicon mode without separate traversal logic per mode.

### 7.2 Lexicon State Machine (CODE 11, offset 0x0DA4)

Dictionary loading uses a 6-state machine (states 3-8) in CODE 11's `init_lexicon_and_menus` function:

| State | Action |
|-------|--------|
| 3 | Reset/Initialize: clear DAWG data, determine current mode |
| 4 | Load second dictionary section |
| 5 | Initialize DAWG info structure (34-byte descriptor) |
| 6 | Finalize: complete setup, clear display |
| 7 | Load first dictionary section (S2 forward DAWG) |
| 8 | Initialize DAWG memory pointers |

The state machine loops until all sections are loaded and the validation table can resolve any word query. A single base pointer (`g_dawg_base_ptr` at A5-11968) is swapped between S1 and S2 base addresses before each DAWG traversal.

---

## 8. The Boundary Field

The first header field (value 56,630) is stored at A5-15506 by CODE 5. Its precise runtime purpose is unclear, but it is demonstrably **not** a traversal boundary:

- S1's letter index child pointers span the full range from 10,834 (letter 'a') to 122,158 (letter 'z')
- Letters a-h have subtree roots below 56,630; letters i-z have subtree roots above 56,630
- CODE 15's `walk_to_child` contains no reference to this value

The value 56,630 corresponds to the boundary between the a-h and i-z subtrees in the DFS serialization order. In `build_dawg.py`, this is computed as the entry count at the point where processing of letter 'h' subtree completes:

```python
for i in range(26):
    letter = chr(ord('a') + i)
    if letter in root.children:
        alloc_and_recurse(root.children[letter])
    if letter == 'h':
        boundary = len(entries)  # a-h subtrees end here
```

Since the value is stored but does not demonstrably affect DAWG traversal, it appears to be either a legacy artifact or used by a code path not yet identified in the disassembly.

---

## 9. DAWG Compression

The DAWG achieves significant compression over the equivalent trie through suffix sharing. Two nodes are merged if they have identical subtrees (same EOW flag and same set of child letter/node pairs, recursively).

| Metric | S1 (TWL) | S2 (OSW) |
|--------|----------|----------|
| Words | 172,233 | 210,643 |
| DAWG entries | 122,166 | 145,476 |
| Estimated trie nodes | ~550,000 | ~670,000 |
| Compression ratio | ~22% | ~22% |
| Data size | 488,664 bytes | 581,904 bytes |

The 22-bit child pointer field supports indices up to 4,194,304, providing approximately 30x headroom over the current entry counts. Even with substantially larger word lists, the pointer field will not overflow.

### Minimization Algorithm

The `build_dawg.py` compiler implements bottom-up signature matching:

1. Build a trie from the sorted word list
2. Post-order traverse the trie, computing a signature for each node: `(eow_flag, sorted_set_of_(letter, child_id)_pairs)`
3. Maintain a register mapping signatures to canonical nodes
4. If a node's signature matches an existing entry, replace it with the canonical node (sharing the subtree)
5. Serialize the minimized DAWG in DFS order

---

## 10. Sentinel and Letter Index

### 10.1 Entry 0: Sentinel

Both sections begin with a sentinel entry at index 0:

```
Entry 0: 0x00000300
  letter = 0x00 (not a valid letter)
  EOW    = 1
  last   = 1
  child  = 0
```

The null letter byte ensures the sentinel never matches any letter comparison. The last-sibling and EOW flags ensure any traversal that reaches entry 0 terminates cleanly. The zero child pointer means no further descent is possible.

### 10.2 Entries 1-26: Letter Index

Entries 1 through 26 form the root letter index, providing direct access to each letter's subtree:

| Entry | Letter | S1 Child | S2 Child |
|-------|--------|----------|----------|
| 1 | a | 10,834 | 11,763 |
| 2 | b | 18,061 | 19,723 |
| 3 | c | 30,166 | 34,112 |
| 4 | d | 36,766 | 42,457 |
| 5 | e | 41,697 | 48,692 |
| 6 | f | 46,111 | 53,792 |
| 7 | g | 49,874 | 58,406 |
| 8 | h | 54,462 | 63,701 |
| 9 | i | 59,070 | 69,100 |
| 10 | j | 59,968 | 70,199 |
| 11 | k | 61,190 | 71,778 |
| 12 | l | 64,436 | 75,651 |
| 13 | m | 71,225 | 83,401 |
| 14 | n | 75,520 | 86,125 |
| 15 | o | 79,191 | 89,925 |
| 16 | p | 89,396 | 102,314 |
| 17 | q | 89,924 | 103,102 |
| 18 | r | 95,292 | 109,077 |
| 19 | s | 107,120 | 124,685 |
| 20 | t | 112,697 | 132,138 |
| 21 | u | 117,416 | 139,022 |
| 22 | v | 119,116 | 141,348 |
| 23 | w | 121,322 | 144,113 |
| 24 | x | 121,439 | 144,334 |
| 25 | y | 121,744 | 144,775 |
| 26 | z | 122,158 | 145,467 |

Entry 26 (letter 'z') has its last-sibling flag set, marking the end of the root sibling group. All other root entries (1-25) have last-sibling=0. None of the root entries have EOW set (no single-letter words exist in either dictionary).

To look up a word, start at entry `1 + (first_letter - 'a')`, read the child pointer, and descend into that subtree for the remaining letters.

### 10.3 Entries 27-255: Zero Padding

Both sections contain 229 zero entries (`0x00000000`) between the letter index and the first data entries. Entry 256 contains `0x00000200` (a last-sibling sentinel with no letter). Actual DAWG node data begins at entry 257.

The purpose of this padding is uncertain. The child pointers in the letter index point to entries in the range 10,834-122,158 (S1) and 11,763-145,467 (S2), so entries 257-10,833 (S1) contain shared leaf and interior nodes placed early in the DFS serialization. The zero padding itself is never referenced by any child pointer.

### 10.4 Letter Index Copies

After each section's entry data, a 104-byte copy of entries 1-26 appears. These copies are byte-identical to the originals and serve a structural purpose: they allow the S2 base pointer to be computed as `data + 116 + s1_count * 4`, where the 116 accounts for the 12-byte header plus the 104-byte S1 index copy.

---

## 11. Cross-Check Generation (CODE 37)

During move generation, Maven computes which letters can legally be placed at each board position based on perpendicular word constraints. This is implemented in CODE 37's `generate_cross_check_sets` function (offset 0x010E, 316 bytes).

### 11.1 Algorithm

For each position on the 15x15 board:

1. **Occupied square**: the cross-check mask is the single-bit mask for the tile already there
2. **Empty, no perpendicular neighbors**: all 26 letters are valid (mask = `0xFFFFFFFF`)
3. **Empty, has perpendicular neighbor(s)**: walk the DAWG to find which letters form valid cross-words

For case 3, the function:
- Scans backward from the position to find the start of any existing perpendicular word fragment
- For each letter a-z, tests whether inserting that letter at the position creates a valid word in the DAWG
- Builds a 32-bit bitmask where bit N corresponds to the letter at position N (a=0, b=1, ..., z=25)

### 11.2 Cross-Check Bit Testing

The cross-check bitmask is tested during move generation with:

```asm
SUBI.B  #$61,D0     ; convert ASCII letter to 0-based index (a=0, b=1, ..., z=25)
BTST    D0,D6       ; test bit in cross-check mask
```

This maps letter 'a' (0x61) to bit 0, letter 'z' (0x7A) to bit 25, using the low 26 bits of the 32-bit mask.

### 11.3 DAWG Access Pattern

CODE 37 accesses DAWG entries with:

```asm
ASL.L   #2,D0           ; index * 4 = byte offset
ADD.L   -11968(A5),D0   ; + g_dawg_base
MOVEA.L D0,A0
MOVE.L  (A0),D7         ; read 32-bit entry
```

The `ASL.L #2` (arithmetic shift left by 2 = multiply by 4) confirms the 4-byte entry size. Child pointers are extracted with `MOVEQ #10,D1; ASR.L D1,D0` (shift right by 10). Last-sibling is tested with `BTST #9,D7`.

---

## 12. Tools

### dump_dawg_sections.py

Extracts both word lists from the Maven data fork, computes set intersections and differences, and cross-references against TWL98 and SOWPODS reference lists.

```bash
python3 dump_dawg_sections.py
# Outputs: lexica/s1_words.txt (172,233 words), lexica/s2_words.txt (210,643 words)
```

### build_dawg.py

Compiles two word lists into a Maven-format DAWG data fork. Implements trie construction, DAWG minimization, serialization, and round-trip verification.

```bash
# Build from word lists
python3 build_dawg.py lexica/s1_words.txt lexica/s2_words.txt -o maven2_new

# Round-trip verification against existing data fork
python3 build_dawg.py --verify
```

The compiler produces DAWGs that are semantically identical to the originals (accept exactly the same word sets) but may differ in node ordering due to different DFS traversal order during minimization.

### Exploration Scripts

The repository contains numerous trace and enumeration scripts used during the reverse engineering process:

- `trace_aardvark.py`, `trace_cat_validation.py`, etc. -- trace specific words through the DAWG
- `enumerate_dawg.py`, `enumerate_section1.py`, etc. -- enumerate words from DAWG sections
- `validate_dawg.py`, `validate_correct_bits.py`, etc. -- validate DAWG structure and bit fields

---

## Appendix A: Relationship Between S1, S2, and Standard Dictionaries

```
                +-----------------------------------------+
                |           SOWPODS / OSWI                 |
                |         (~253,076 words)                 |
                |                                          |
                |   +-------------+   +----------------+   |
                |   |  S1-only    |   |   S2-only      |   |
                |   |  (TWL, not  |   |   (OSW, not    |   |
                |   |   OSW)      |   |    TWL)         |   |
                |   |  42,401     |   |   80,811        |   |
                |   +------+------+   +-------+--------+   |
                |          |                  |             |
                |          |  +-----------+   |             |
                |          +--+  Common   +---+             |
                |             | S1 AND S2 |                 |
                |             | 129,832   |                 |
                |             +-----------+                 |
                +-----------------------------------------+

S1 = TWL98:  42,401 + 129,832 = 172,233 words
S2 = OSW:    80,811 + 129,832 = 210,643 words
S1 U S2:     42,401 + 129,832 + 80,811 = 253,044 words (+ small discrepancies)
```

---

## Appendix B: Complete File Layout Map (Original Data Fork)

```
Byte Offset      Entry Index    Content
-----------      -----------    -------
0                --             Header field 0: boundary = 56,630
4                --             Header field 1: s1_count = 122,166
8                --             Header field 2: s2_count = 145,476
12               S1[0]          S1 sentinel: 0x00000300
16               S1[1]          S1 letter 'a': child=10834
20               S1[2]          S1 letter 'b': child=18061
...              ...            ...
116              S1[26]         S1 letter 'z': child=122158, last=1
120              S1[27]         Zero padding begins
...              ...            (229 zero entries)
1,036            S1[256]        Sentinel: 0x00000200
1,040            S1[257]        First DAWG data node
...              ...            (DAWG nodes in DFS order)
488,672          S1[122,165]    Last S1 data entry
488,676          --             S1 letter index copy: 'a' entry
488,680          --             S1 letter index copy: 'b' entry
...              ...            ...
488,776          --             S1 letter index copy: 'z' entry
488,780          S2[0]          S2 sentinel: 0x00000300
488,784          S2[1]          S2 letter 'a': child=11763
...              ...            ...
488,884          S2[26]         S2 letter 'z': child=145467, last=1
488,888          S2[27]         Zero padding begins
...              ...            (229 zero entries)
489,804          S2[256]        Sentinel: 0x00000200
489,808          S2[257]        First S2 DAWG data node
...              ...            (DAWG nodes in DFS order)
1,070,680        S2[145,475]    Last S2 data entry
1,070,684        --             S2 letter index copy: 'a' entry
...              ...            ...
1,070,784        --             S2 letter index copy: 'z' entry
1,070,788        --             End of file
```

---

## Appendix C: Verification Provenance

The information in this document was established through:

1. **Binary analysis** of the data fork at `/share/maven2` (1,070,788 bytes, MD5: `021075b71871d9d3ffbb9e695be0c302`)
2. **Disassembly** of CODE 2 (DAWG loader), CODE 5 (initialization), CODE 11 (lexicon controller), CODE 12 (word validation), CODE 15 (DAWG traversal), and CODE 37 (cross-check generation) -- all hex-verified against raw 68000 machine code
3. **QEMU runtime observation** confirming memory layout, base pointer values, and traversal behavior
4. **Round-trip verification** via `build_dawg.py --verify`, which extracts all words from both sections, rebuilds DAWGs from those word lists, and confirms the rebuilt DAWGs enumerate the same word sets
5. **Cross-referencing** extracted word lists against TWL98 and SOWPODS 2003 reference dictionaries
