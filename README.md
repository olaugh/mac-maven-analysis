# Maven Reverse Engineering Project

## Current reconstruction work

The POOFIER discrepancy was a mismatched search lifetime in the test harness;
continued original/native sequences agree. The separate VID stale-byte bug is fixed.
See [the corrected diagnosis](analysis/toolchain/POOFIER-DISAGREEMENT.md) and
[the instruction-to-C audit](analysis/instruction-audit/README.md).

The current evidence and limitations are in
[DECOMPILATION-STATUS.md](analysis/DECOMPILATION-STATUS.md). Readable C lives in
[reconstruction/](reconstruction/); the native and WebAssembly replay tools
compare it with debugger captures from the original classic Mac executable.
The [owned native/wasm API](analysis/PORTABLE-API.md) supports move generation,
heuristic/late/endgame search, simulation, play/refill, history and original
save/load, with original-runtime acceptance on the documented fixtures. This is not yet
a complete playable application or a proof of every engine branch. The five
behavioral steps pass the [230-command acceptance suite](analysis/toolchain/portable-verification-scratch-lifecycle.json), including79 host tests.

```sh
make check
python3 scripts/verify_portable_replays.py
```

The full replay command uses the fingerprinted dictionary in the disposable
session share; see [PORTING-NOTES.md](analysis/PORTING-NOTES.md) for data and
runtime dependencies, compatibility behavior, and modern/wasm boundaries.
Compiler evidence is in [THINK-C-EVIDENCE.md](analysis/toolchain/THINK-C-EVIDENCE.md).
The current acceptance and process ledger is [BEHAVIORAL-COMPLETION.md](analysis/BEHAVIORAL-COMPLETION.md); older timed-run logs are historical.

## Historical project notes

The original notes below and older analysis files contain superseded hypotheses.
In particular, the34-byte records used by CODE3 are moves, and A5-15514/
A5-15522 hold player rack strings. Earlier descriptions of them as DAWG headers
or dictionary-section buffers are incorrect. Use the corrected disassembly,
readable source and runtime captures for current claims.


## Status: Work in Progress

This project aims to reverse engineer Maven 2.1, Brian Sheppard's classic Macintosh Scrabble engine. This copy has been updated to use the OSWI (SOWPODS) word list.

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

- Maven was created by Brian Sheppard
- This copy uses OSWI (SOWPODS) dictionary
- Classic Macintosh 68000 application
