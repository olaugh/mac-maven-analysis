# Maven Reverse Engineering Analysis

## Project Overview
Maven is a classic Macintosh Scrabble engine created by Brian Sheppard. This document tracks the reverse engineering progress.

## File Structure

### Main Application
- **maven2** (1,070,788 bytes) - Data fork containing the DAWG dictionary
- **maven2.1.rdump** (1,045,969 bytes) - Resource fork dump (DeRez format) containing:
  - 53 CODE resources (96,054 bytes total) - 68000 machine code
  - UI resources (MENU, DITL, STR, etc.)
  - Data resources (CFIG, EXPR, MUL*, VCB*, ESTR, etc.)

### Resource Types Identified

#### Executable Code
- **CODE 0-54**: 68000 machine code segments
- Total: ~96KB of executable code

#### Configuration & Data
- **CFIG**: Board configuration (1,088 bytes) - appears to contain board multiplier positions
- **EXPR**: "experience" resource (96 bytes) - contains floating-point rack leave values
- **MULa-MULz, MUL?**: Letter multiplier tables (224 bytes each) - leave value contributions per letter
- **VCBa-VCBh**: Vocabulary-related tables (224 bytes each) - currently all zeros, may be runtime buffers
- **ESTR**: Pattern strings (536 bytes) - rack leave pattern definitions

#### Leave Heuristics
The ESTR resource contains pattern strings for rack evaluation:
- Single/double/triple letter patterns: "a", "aa", "aaa", "ee", "eee", etc.
- Common suffixes: "gin", "flu", "ily", "ino", "inot", "ity", etc.
- Letter groups: "aeiou" (vowels), "mpfhxwy", "mpdglnrtsu", etc.

The MUL* resources contain 80-bit extended precision floating point values
representing the leave value contributions for each letter pattern combination.

## DAWG Dictionary Structure

### Header (0x00-0x0F)
```
Offset 0x00: 0x0000dd36 (56,630) - possibly number of terminal nodes
Offset 0x04: 0x0001dd36 (122,166) - possibly total nodes
Offset 0x08: 0x00023844 (145,476) - unknown
Offset 0x0C: 0x00000300 (768) - possibly data offset
```

### Letter Index (0x10-0x77)
26 entries, one for each letter a-z:
```
Format: [ptr_hi][ptr_lo][flags][letter]
Example for 'a': 00 a9 48 61 -> ptr=0x00a9, flags=0x48, letter='a'
```

### DAWG Nodes (0x400+)
Each node is 4 bytes:
```
Byte 0-1: Child pointer (16-bit, big-endian)
Byte 2:   Flags
Byte 3:   Letter (ASCII: 'a'=0x61, 'z'=0x7a, '?'=0x3f)
```

### Flag Interpretation (partially decoded)
- Bit 0: End-of-word marker
- Bit 1: Last sibling marker
- Bits 2-7: Unknown (possibly part of extended pointer)

### Statistics
- File size: 1,070,788 bytes
- DAWG nodes: ~267,000 (estimated)
- Letter frequency at byte position 3 (confirming structure):
  - 'e': 29,834 nodes
  - 'i': 30,202 nodes
  - 's': 24,608 nodes
  - 'a': 21,814 nodes

## Endgame Algorithm
Not yet analyzed. Likely in CODE resources 36-37 based on complexity and size.

## Move Generation
The DAWG structure appears to be designed for efficient move generation:
- Letter index provides quick access to words starting with each letter
- Shared suffix nodes reduce memory usage
- Flag bits allow marking valid words and sibling relationships

## Tools Created

### extract_resources.py
Extracts all resources from the .rdump file into individual binary files.

### parse_dawg.py / analyze_dawg.py
Analyzes the DAWG header and node structure.

### dawg_traverse.py / dawg_reversed.py
Attempts to extract words from the DAWG (work in progress).

## Next Steps

1. **Complete DAWG decoding**:
   - Reverse engineer the exact pointer/flag bit packing
   - Successfully extract the full word list

2. **Disassemble key CODE segments**:
   - Identify word validation function
   - Identify move generation function
   - Identify endgame evaluation function

3. **Document leave heuristics**:
   - Decode the EXPR floating-point values
   - Map patterns in ESTR to values in MUL*

4. **Create C decompilation**:
   - Convert 68k assembly to readable C code
   - Document all data structures

## References
- Maven was created by Brian Sheppard in the late 1980s
- Uses OSPD/TWL dictionary format (estimated ~100,000-178,000 words)
- Classic Macintosh 68000 application architecture
