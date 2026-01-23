# Maven Reverse Engineering Project

## Status: Work in Progress

This project aims to reverse engineer Maven, Brian Sheppard's classic Macintosh Scrabble engine.

## Project Goals

1. ✅ **Extract resources** - All resources extracted and categorized
2. 🔄 **Decode DAWG dictionary** - Structure identified, word extraction in progress
3. 🔄 **Extract word list** - Pending complete DAWG decoding
4. ✅ **Identify leave heuristics** - Pattern strings and values located
5. ⏳ **Understand endgame algorithm** - Pending code analysis
6. ⏳ **Produce readable C code** - Pending full disassembly

## Quick Start

```bash
cd /Volumes/T7/retrogames/oldmac/maven_re

# Extract resources from rdump file
python3 extract_resources.py

# Analyze DAWG structure
python3 analyze_dawg.py

# Manual trace for debugging
python3 manual_trace.py
```

## File Overview

### Source Files
- `maven2` - Main application data fork (DAWG dictionary, ~1MB)
- `maven2.1.rdump` - Resource fork in DeRez format

### Analysis Scripts
- `extract_resources.py` - Extracts binary resources from rdump
- `parse_dawg.py` - Initial DAWG analysis
- `analyze_dawg.py` - Detailed DAWG structure analysis
- `dawg_decode.py` - Multiple DAWG interpretation tests
- `manual_trace.py` - Manual tracing for word validation

### Output
- `resources/` - Extracted binary resources by type
- `ANALYSIS.md` - Detailed technical analysis

## Key Findings

### DAWG Structure
- 4-byte nodes: `[ptr_hi][ptr_lo][flags][letter]`
- Letter index at offsets 0x10-0x77
- Data begins at offset 0x400
- ~267,000 nodes total
- Common suffixes stored at low addresses (shared across words)

### Leave Heuristics
Located in three resource types:
- **ESTR** - Pattern strings (e.g., "aeiou", "ing", "tion")
- **MULa-MULz** - 80-bit floating point leave values per letter
- **EXPR** - Main experience/leave value table

### Code Structure
- 53 CODE resources totaling ~96KB
- 68000 machine code
- Uses Mac Toolbox traps (A-line instructions)

## Next Steps

1. Complete DAWG traversal algorithm
2. Extract full word list (~100K-178K words expected)
3. Disassemble key CODE segments
4. Document leave value calculation
5. Analyze endgame search algorithm

## Requirements

- Python 3.x
- m68k-elf-binutils (for disassembly)
- Optional: Classic Mac emulator for dynamic analysis

## Resources

- Maven was created by Brian Sheppard (late 1980s)
- Uses OSPD/TWL dictionary format
- Classic Macintosh 68000 application
