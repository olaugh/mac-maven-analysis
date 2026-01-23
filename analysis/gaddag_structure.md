# Maven GADDAG Dictionary Structure

## Overview

Maven uses a GADDAG (Gordon's DAWG for Games) structure optimized for Scrabble move
generation. Unlike a standard DAWG, a GADDAG allows efficient lookup starting from
any position in a word, essential for finding all valid crossword plays.

## File Information

- **Location**: `/Volumes/T7/retrogames/oldmac/share/maven2` (data fork)
- **Size**: 1,070,788 bytes (1.02 MB)
- **Word list**: SOWPODS 2003 (267,437 entries, 121 two-letter words)
- **Reference**: `lexica/sowpods2003.txt`

## File Layout

| Offset | Size | Description |
|--------|------|-------------|
| 0x0000-0x000F | 16 bytes | Header |
| 0x0010-0x0077 | 104 bytes | Letter index (26 × 4 bytes) |
| 0x0078-0x040F | ~920 bytes | Padding (zeros) |
| 0x0410+ | ~1 MB | GADDAG node entries |

## Header (0x0000-0x000F)

```
0x0000: 00 00 dd 36  -> 56,630   (end of first DAWG section)
0x0004: 00 01 dd 36  -> 122,166  (end of second DAWG section)
0x0008: 00 02 38 44  -> 145,476  (unknown)
0x000C: 00 00 03 00  -> 768      (unknown)
```

**Two-Section Structure**:
- First section: entries 0 to 56,629 (56,630 entries)
- Second section: entries 56,630 to 122,165 (65,536 entries)
- Note: 65,536 = 2^16, suggesting packed 16-bit addressing in second section

## Letter Index (0x0010-0x0077)

Each 4-byte entry maps a letter to its GADDAG subtree:

```
Bytes 0-1: Entry index (big-endian 16-bit)
Byte 2:    Flags
Byte 3:    Letter (ASCII lowercase 0x61-0x7A)
```

| Letter | Entry Index | Flags | Entry Range |
|--------|-------------|-------|-------------|
| a | 0x00a9 (169) | 0x48 | 169-281 (113 entries) |
| b | 0x011a (282) | 0x34 | 282-470 (189 entries) |
| c | 0x01d7 (471) | 0x58 | 471-573 (103 entries) |
| d | 0x023e (574) | 0x78 | 574-650 (77 entries) |
| e | 0x028b (651) | 0x84 | 651-719 (69 entries) |
| f | 0x02d0 (720) | 0x7c | 720-778 (59 entries) |
| g | 0x030b (779) | 0x48 | 779-849 (71 entries) |
| h | 0x0352 (850) | 0xf8 | 850-921 (72 entries) |
| i | 0x039a (922) | 0xf8 | 922-936 (15 entries) |
| j | 0x03a9 (937) | 0x00 | 937-955 (19 entries) |
| k | 0x03bc (956) | 0x18 | 956-1005 (50 entries) |
| l | 0x03ee (1006) | 0xd0 | 1006-1111 (106 entries) |
| m | 0x0458 (1112) | 0xe4 | 1112-1179 (68 entries) |
| n | 0x049c (1180) | 0x00 | 1180-1236 (57 entries) |
| o | 0x04d5 (1237) | 0x5c | 1237-1395 (159 entries) |
| p | 0x0574 (1396) | 0xd0 | 1396-1404 (9 entries) |
| q | 0x057d (1405) | 0x10 | 1405-1487 (83 entries) |
| r | 0x05d0 (1488) | 0xf0 | 1488-1672 (185 entries) |
| s | 0x0689 (1673) | 0xc0 | 1673-1759 (87 entries) |
| t | 0x06e0 (1760) | 0xe4 | 1760-1833 (74 entries) |
| u | 0x072a (1834) | 0xa0 | 1834-1860 (27 entries) |
| v | 0x0745 (1861) | 0x30 | 1861-1894 (34 entries) |
| w | 0x0767 (1895) | 0xa8 | 1895-1896 (2 entries) |
| x | 0x0769 (1897) | 0x7c | 1897-1901 (5 entries) |
| y | 0x076e (1902) | 0x40 | 1902-1907 (6 entries) |
| z | 0x0774 (1908) | 0xba | 1908+ |

## GADDAG Structure

### Two Regions

**Suffix Region (Entries 0-168)**
- Contains forward suffix letters (what comes AFTER the anchor point)
- Shared across all letter subtrees
- Letters found: a,b,c,d,e,f,g,h,i,k,l,m,n,o,p,r,s,t,u,v,w,x,y (23 unique)

**Prefix Regions (Entries 169+)**
- Letter-specific entries for reversed prefix paths
- Example: 'a' range (169-281) contains: a,c,d,e,g,i,l,m,n,o,r,s,t,u,y (15 unique)
- Missing letters (b,f,h,j,k,p,q,v,w,x,z) accessed via suffix region

### Node Entry Format (4 bytes)

```
Offset 0-1: ptr (16-bit big-endian)
Offset 2:   flags
            - Bit 7 (0x80): Word marker - path forms a valid word
            - Bit 0 (0x01): Last sibling in group
            - Bits 1-6: Used with ptr for child lookup
Offset 3:   letter (ASCII lowercase)
```

### Child Calculation Formula

```
child_entry = ptr + (flags & 0x7e)
```

Where `flags & 0x7e` extracts bits 1-6 (masking out bit 0 which is LAST flag
and bit 7 which is WORD marker). This gives an offset of 0-126 in steps of 2.

**Verified Example**: Entry 192 'a' (ptr=4, flags=0x90)
- Child = 4 + (0x90 & 0x7e) = 4 + 0x10 = 4 + 16 = 20
- Entry 20 is 'h' (terminal) → gives AAH

## Traversal Examples

### Word "AAH"

1. Letter index 'a' → start at entry 169
2. Scan for 'a' entry → entry 192 ('a', ptr=4, flags=0x90, word marker set)
3. Calculate child: 4 + (0x90 & 0x7e) = 4 + 16 = entry 20
4. Entry 20: 'h' (ptr=0, flags=0x03) → terminal leaf
5. Result: AAH is a valid word

**Multiple AA Paths**: The word AA appears at multiple entries (171, 174, 179, 192, etc.)
with different children, supporting the GADDAG hypothesis where the same prefix
appears in multiple contexts for different anchor positions.

### Word "AAS"

1. Entry 192-193 form sibling group
2. Entry 192: 'a' with word marker (AA is a word, has children)
3. Entry 193: 's' (ptr=0, flags=0x03) → terminal
4. Result: AAS is a valid word

### Word "AH" (2-letter)

1. Entry 20 in suffix region: 'h' terminal (ptr=0)
2. Reached for words with no reversed prefix
3. Result: AH is a valid word

## 2-Letter Words in 'A' Range

### Terminal Entries (ptr=0)

| Entry | Letter | Word |
|-------|--------|------|
| 170 | m | AM |
| 177 | n | AN |
| 178 | s | AS |
| 187 | y | AY |
| 189 | s | AS (duplicate context) |
| 193 | s | AAS (after AA) |
| 207 | s | AS |
| 210 | t | AT |
| 215 | d | AD |
| 230 | d | AD |
| 236 | s | AS |
| 242 | d | AD |
| 244 | s | AS |

### Words with Extensions (ptr≠0, 0x80 set)

| Entry | Letter | Word | Example Extensions |
|-------|--------|------|-------------------|
| 171 | a | AA | AAH, AAL, AAS, AARGH |
| 172 | i | AI | AID, AIM, AIR |
| 173 | r | AR | ARE, ARK, ARM |
| 175 | d | AD | ADD, ADO, ADS |
| 176 | e | AE | AES |
| 191 | t | AT | ATE, ATS |
| 192 | a | AA | (another context) |
| 216 | l | AL | ALA, ALB, ALE |
| 274 | g | AG | AGE, AGO, AGS |
| 275 | l | AL | (another context) |

### Suffix Region 2-Letter Words

Words like AH, AW, AX have their second letter only in suffix region:

| Entry | Letter | Word | Has Children |
|-------|--------|------|--------------|
| 20 | h | AH | No (terminal) |
| 19 | w | AW | Yes (AWE, AWL, AWN) |
| 115 | x | AX | Yes (AXE, AXLE) |

## Sibling Groups

Entries organized into groups, marked by `flags & 0x01`:

```
Entries 169-170: ['u', 'm']           AM terminal
Entries 171-177: ['a','i','r','a','d','e','n']  AA,AI,AR,AD,AE,AN
Entries 178-178: ['s']                AS terminal
Entries 179-179: ['a']                AA context
Entries 180-182: ['s','o','e']
Entries 183-185: ['i','m','e']        AI, AM contexts
Entries 186-187: ['i','y']            AY terminal
Entries 188-189: ['l','s']            AS terminal
Entries 190-191: ['c','t']            AT with children
Entries 192-193: ['a','s']            AA->AAH etc, AAS terminal
```

## Key Findings

1. **GADDAG, not DAWG**: Structure optimized for crossword play finding
2. **Two regions**: Suffix (0-168) and prefix (169+) entries
3. **Word marker**: 0x80 flag indicates valid word at this path
4. **Last sibling**: 0x01 flag marks end of sibling group
5. **Child formula**: `ptr + (flags & 0x7f)` gives child entry
6. **Terminal nodes**: ptr=0 means no further extensions

## Ptr Value Distribution

The ptr field uses a small set of values, indicating a shared structure:

| ptr | Count | Usage |
|-----|-------|-------|
| 0 | 4,927 | Terminal nodes (no children) |
| 4 | 6,675 | Most common, points to shared suffix pool |
| 5 | 2,292 | Second most common |
| 6 | 424 | |
| 7 | 796 | |
| 8+ | varies | |

886 unique ptr values total in first section (0-56,629).

## Shared Suffix Pool (Entries 0-50)

Low-numbered entries form a shared pool of common word endings:

| Entry | Letter | Notes |
|-------|--------|-------|
| 0 | d | terminal |
| 1 | g | terminal |
| 5-6 | s | terminal (plural/verb endings) |
| 9 | s | terminal |
| 14 | f | terminal |
| 20 | h | terminal (used for AAH, AH) |
| 35 | l | terminal |
| 36-39 | a,i,r,e | WORD markers set |
| 42-43 | i,k | terminal |
| 44-45 | t,u | WORD markers set |
| 46 | t | terminal |

These shared endings allow multiple word paths to converge on common suffixes.

## Second DAWG Section (Entries 56,630+)

The second section has different ptr semantics:
- Higher ptr values (e.g., 888, 889) that still point into first section
- Child formula appears same: `ptr + (flags & 0x7e)`
- May represent reversed word forms or alternate traversal paths

Example: Entry 56630 'o' with ptr=888 → child at 888 + (0xd0 & 0x7e) = 968

## Confirmed: Two Overlapping DAWGs (Not GADDAG)

The file contains **two heavily overlapping DAWGs** (1.02MB total), not a GADDAG (which would be ~7x larger):

### Structure

| Region | Entries | Description |
|--------|---------|-------------|
| Shared suffix pool | 0-999 | Common word endings, 986 of 1000 referenced by BOTH sections |
| Section 1 (Reversed) | 0-56,629 | Complete reversed-word DAWG for hook-BEFORE checks |
| Section 2 (Forward) | 56,630-122,165 | Forward-word entry points, heavily reuses Section 1 |

### Section 2 Child Pointer Analysis

Section 2 is NOT a self-contained DAWG. Its children point:
- **57.1%** → Shared suffix pool (entries 0-999)
- **42.9%** → Section 1 body (entries 1000-56,629)
- **0%** → Within Section 2 itself

This means Section 2 acts as an "alternate entry layer" - forward word traversals start in Section 2 but immediately descend into Section 1's structure for all suffix matching.

### Purpose

1. **Section 1 (entries 0-56,629)**: Reversed words for **hook-BEFORE** checking
   - EHT (THE reversed) found with 10+ paths
   - Used for cross-check computation: what letters can legally precede an anchor

2. **Section 2 (entries 56,630-122,165)**: Forward words for **hook-AFTER** checking
   - CAT found with 56 paths, RET found with 102 paths
   - Used for cross-check computation: what letters can legally follow an anchor
   - Exactly 65,536 entries (2^16) - maxed out 16-bit index
   - Only stores unique forward-word prefixes; all suffixes shared with Section 1

**Why two entry points?** Without a reversed DAWG, computing cross-checks would require brute-force testing all 26 letters A-Z. This design enables O(1) lookup per letter while minimizing memory through suffix sharing.

**Speculation:** The reversed/forward DAWGs may also be used for main word generation during move search (extending left from anchor using reversed DAWG, extending right using forward DAWG), not just for cross-set computation. The code hasn't been analyzed deeply enough to confirm this.

## Verified Word Paths

| Word | Forward (2nd DAWG) | Reversed (1st DAWG) |
|------|-------------------|---------------------|
| THE  | 0 paths           | 10 paths (EHT)      |
| CAT  | 56 paths          | 161 paths (TAC)     |
| RET  | 102 paths         | 41 paths (TER)      |
| TIN  | 35 paths          | 36 paths (NIT)      |

## Code Analysis (m68k Disassembly)

Analysis of Maven's CODE resources reveals how the DAWG is accessed:

### Key Globals (A5-relative)

| Offset | Value | Usage |
|--------|-------|-------|
| A5-23074 (-0x5A22) | DAWG pointer | Base address of loaded DAWG data |
| A5-15506 (-0x3C92) | Size 1 | First DAWG size (56,630) |
| A5-15502 (-0x3C8E) | Size 2 | Second DAWG size or offset |
| A5-11972 (-0x2EC4) | Unknown | Another DAWG-related pointer |

### Entry Access Pattern

The CODE resources use **x4 indexed addressing** confirming 4-byte entries:

```m68k
MOVE.L (A0,D3.L*4),D2    ; Load full 4-byte entry
MOVE.W (A0,D3.L*4),D0    ; Load ptr field (first 2 bytes)
MOVE.B 2(A0,D3.L*4),D1   ; Load flags byte
MOVE.B 3(A0,D3.L*4),D2   ; Load letter byte
```

### Bounds Checking Function (0x1A2)

```m68k
; Function computes total size for bounds check:
; D0 = header[0x10] + header[0x14] + header[0x18]
; D1 = global[-23074] + global[-23070] + global[-23066]
; Compare D0 to D1
```

This confirms the header fields at 0x10, 0x14, 0x18 are cumulative size values.

### Flag Extraction Patterns

Found `LSR.W #7,D2` and `LSR.W #8,D0` patterns in CODE 3 and CODE 7,
suggesting high bits of words are extracted separately from the ptr/flags fields.

### Ptr Value Statistics

From analysis of first 1000 entries:
- **Range**: 0 to 19 (very small!)
- **996 backward pointers** (ptr < current_index)
- **Only 2 forward pointers** (ptr > current_index)
- **Most common**: ptr=4 (222 times), ptr=0 (109), ptr=5 (109)

This suggests ptr is NOT a direct entry index but indexes into a shared structure.

## Structural Analysis

### Mystery Region (0x78-0x40F)

The 920 bytes between letter index and node data are **all zeros** - pure padding.
No translation table exists here.

### Shared Suffix Groups (Entries 0-168)

Entries before the first letter index form 67 sibling groups containing
common letter patterns. Entries in letter ranges point to these groups via ptr.

| Group | Entries | Letters |
|-------|---------|---------|
| 0 | 0-0 | [d] |
| 1 | 1-1 | [g] |
| 2 | 2-5 | [n,e,i,s] |
| 3 | 6-6 | [s] |
| 4 | 7-7 | [i] |
| 5 | 8-9 | [i,s] |
| 6 | 10-10 | [k] |
| 7 | 11-14 | [r,a,e,f] |
| 8 | 15-20 | [v,l,o,v,w,h] |

### Multiple Entries Per Letter

Within A's range (169-281), letters appear multiple times:
- 'a': 13 entries (different contexts/children)
- 'i': 14 entries
- 'e': 12 entries
- 's': 11 entries

This suggests the structure encodes multiple paths through the same letter
for different word contexts (GADDAG-like behavior).

### First Sibling Group for 'A'

Letter index A → entry 169, first sibling group is entries 169-170:
- Entry 169: 'u' with WORD flag, ptr=6
- Entry 170: 'm' with LAST flag, ptr=0

This suggests the DAWG stores **reversed** words:
- 'u' with WORD → AU reversed = ? (not standard)
- Following ptr=6 → group 6 (entry 10 'k') → AUK (which IS a valid word!)

### WORD Flags in Shared Entries

Entries 36-45 in shared region have WORD flags:
- Entry 36: 'a' WORD
- Entry 37: 'i' WORD
- Entry 38: 'r' WORD
- Entry 39: 'e' WORD
- Entry 44: 't' WORD
- Entry 45: 'u' WORD
- Entry 49: 'n' WORD

These appear to mark valid word endings in a reversed traversal.

## Open Questions

1. **Child formula unclear**: `ptr + (flags & 0x7e)` produces some correct results but enumeration produces garbage
2. **Ptr interpretation**: Very small values (0-19) suggest group indexing, not entry indexing
3. **Multiple letter entries**: Why 13 different 'a' entries in A's range?
4. **Purpose of second section**: ptr values (888, 889) pointing into first DAWG
5. **Letter index meaning**: Points mid-group rather than group start - why?
6. **WORD flag semantics**: Different meaning in shared vs. letter-specific regions?
7. **Missing words**: AB, AH, AW, AX, AY not found in A's range despite being valid SOWPODS words

## Scripts Reference

Analysis scripts in `/Volumes/T7/retrogames/oldmac/maven_re/scripts/`:

| Script | Purpose |
|--------|---------|
| `extract_code.py` | Extract CODE resources from resource fork |
| `analyze_code.py` | Search for DAWG patterns in CODE |
| `disasm_full.py` | m68k disassembler for CODE 3 |
| `decode_instructions.py` | Decode specific m68k sequences |
| `trace_entry_access.py` | Find indexed access patterns |
| `analyze_dawg_access.py` | Trace DAWG access in code |
| `examine_header_region.py` | Analyze header/padding region |
| `test_group_ptr.py` | Test ptr as group index |
| `reverse_engineer.py` | Work backwards from WORD markers |
| `analyze_duplicates.py` | Understand duplicate letter entries |

## Next Steps

1. Debug in emulator to watch actual DAWG access
2. Trace specific word lookups through structure
3. Compare word counts with alternate dictionaries (our version uses OSWI 2000)
4. Analyze second DAWG section separately
5. Look for endgame/leave value data structures
