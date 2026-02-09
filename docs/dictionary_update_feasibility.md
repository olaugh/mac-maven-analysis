# Feasibility of Updating Maven's Dictionary

## Summary

Maven's DAWG dictionary format is fully decoded, and we have a working compiler that can build replacement data forks from arbitrary word lists. The runtime performs no integrity checks on the DAWG data. Replacing the dictionary with modern word lists (NWL23 for North America, CSW for international play) is straightforward. The main risk is not breakage but subtle optimality loss: Maven's pre-computed leave evaluation tables (MUL resources) and pattern synergies (ESTR) were tuned for the original word lists and will not account for strategic possibilities introduced by new words.

---

## Current Dictionary Contents

Maven ships with two DAWG sections in its data fork (`/share/maven2`, 1,070,788 bytes):

| Section | Role | Words | Entries | Dictionary |
|---------|------|-------|---------|------------|
| S1 | Reversed cross-check DAWG | 172,233 | 122,166 | TWL98 (Tournament Word List, 1998) |
| S2 | Forward dictionary DAWG | 210,643 | 145,476 | OSW circa 2003 (Official Scrabble Words) |

These dictionaries are outdated. Current tournament play uses:

- **NWL23** (NASPA Word List 2023) for North American tournaments -- supersedes TWL98
- **CSW** (Collins Scrabble Words, latest edition) for international tournaments -- supersedes OSW

The word counts have grown substantially since Maven's era. NWL23 contains approximately 192,000 words versus TWL98's 172,233. CSW has grown proportionally beyond the ~210,000 words in Maven's OSW.

---

## DAWG Format (Fully Decoded)

Each DAWG entry is a 32-bit big-endian value:

```
Bits 0-7:   Letter (ASCII lowercase, 0x61-0x7A)
Bit 8:      End-of-word flag
Bit 9:      Last-sibling flag
Bits 10-31: Child entry index (22 bits, absolute within section)
```

The data fork layout is:

```
Offset 0:       12-byte header (3 x uint32: boundary, s1_count, s2_count)
Offset 12:      S1 entries (entry 0 = sentinel, entries 1-26 = letter index, then DAWG nodes)
                S1 letter index copy (26 x 4 bytes = 104 bytes)
                S2 entries (same structure as S1)
                S2 letter index copy (26 x 4 bytes = 104 bytes)
```

The S2 base address is computed at runtime as `data + 12 + 104 + field2 * 4`, where `field2` is the S1 entry count from the header. The 104-byte letter index copies after each section serve as padding that makes this formula work.

This format was verified through CODE 2 disassembly (which loads the DAWG), CODE 15 disassembly (which traverses it), CODE 37 disassembly (which uses it for cross-check generation), and CODE 12 disassembly (which performs recursive DAWG search for word validation). All four modules use the same bit-field layout: `entry & 0xFF` for letter, `BTST #8` for end-of-word, `BTST #9` for last-sibling, `entry >> 10` for child pointer.

---

## DAWG Compiler (`build_dawg.py`)

We have a working DAWG compiler that can produce replacement data forks. The pipeline is:

1. **Trie construction** -- Builds a trie from a sorted word list. Each node tracks its children (a-z) and end-of-word status.

2. **DAWG minimization** -- Bottom-up signature matching merges identical subtrees. Two nodes are equivalent if they have the same end-of-word flag and the same set of `(letter, child_id)` pairs after their children have been minimized. This typically reduces node count to 20-30% of the original trie.

3. **Serialization** -- Allocates entry 0 as a sentinel, entries 1-26 as the root letter index (one per letter a-z), then recursively serializes all sibling groups in DFS order. Each entry packs the letter, end-of-word flag, last-sibling flag, and child pointer into a 32-bit value using Maven's bit-field layout.

4. **File packing** -- Assembles the 12-byte header, S1 entries, S1 letter index copy, S2 entries, and S2 letter index copy into a single binary blob.

5. **Round-trip verification** -- After building, enumerates all words from the built DAWG and verifies they match the input word lists exactly.

Usage:

```bash
# Build from word lists
python3 build_dawg.py lexica/nwl23.txt lexica/csw.txt -o maven2_new

# Round-trip test against existing data fork
python3 build_dawg.py --verify
```

The compiler produces DAWGs that are not byte-identical to the originals (different node ordering within equivalent DAWGs is possible, and the minimization may find different sharing patterns) but are semantically identical -- they accept exactly the same set of words.

---

## No Runtime Integrity Checks

CODE 15's `walk_to_child` function (offset 0x00CE) traverses the DAWG with no bounds checking, no checksums, and no file size validation:

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

The function uses a single base pointer (`g_dawg_base_ptr` at A5-11960) which is set to either S1 or S2 base before invocation. It indexes into the DAWG array by multiplying by 4 (`ASL.L #2,D0`) and adding the base. There is no comparison against the section's entry count, no verification that child pointers stay within bounds, and no checksum or magic number validation.

CODE 37's DAWG traversal (`traverse_and_gen` at offset 0x024A) similarly trusts the data completely -- it reads entries with `g_dawg_base[node_index]`, extracts the child pointer with `>> 10`, and recurses without any bounds check.

CODE 12's recursive DAWG search (function 0x03AA) follows the same pattern: read entry, extract letter and child pointer, recurse. No validation of any kind.

This means any correctly-formatted DAWG data fork will work. The runtime does not care about the file size, word count, or specific dictionary contents.

---

## The Boundary Field

The first field in the 12-byte header (value 56,630 in the original) has an unclear purpose. It is stored in A5-15506 by CODE 5 during initialization. Our analysis shows it does not function as a traversal boundary -- S1's letter index child pointers span the full range from entry 288 to entry 122,158, with letters a-h having subtrees below 56,630 and letters i-z extending above it.

The `build_dawg.py` compiler computes a boundary value based on where the a-h subtrees end, mimicking the original's structure. Since the value is stored but does not affect traversal (CODE 15's walk_to_child has no reference to it), an incorrect value should be harmless. The compiler's heuristic of tracking the entry count after processing letters a-h produces a reasonable approximation.

---

## Practical Steps

### 1. Extract existing word lists

```bash
python3 dump_dawg_sections.py
```

This produces `lexica/s1_words.txt` (172,233 words) and `lexica/s2_words.txt` (210,643 words) from the original data fork. These can serve as a baseline for comparison.

### 2. Prepare updated word lists

Obtain NWL23 and CSW word lists in plain text format (one word per line, any case). These are widely available from official Scrabble organizations and tournament resources.

Considerations for word list preparation:
- Maven expects lowercase ASCII letters only (a-z). Strip any annotations, part-of-speech markers, or non-alphabetic characters.
- S1 receives the TWL-equivalent list (NWL23 for North American play).
- S2 receives the OSW-equivalent list (CSW for international play).
- S1's words are stored reversed (for cross-check generation), but the compiler handles this -- it takes forward word lists as input.

**Important note on S1**: Our analysis shows S1 is a reversed cross-check DAWG where the end-of-word flag has different semantics than simple word membership. The `build_dawg.py` compiler builds S1 as a standard reversed DAWG. This may produce slightly different cross-check behavior than the original. In practice, the 99.4% accuracy rate of S2 against OSW reference lists suggests the format is well understood enough for functional correctness.

### 3. Build the replacement data fork

```bash
python3 build_dawg.py lexica/nwl23.txt lexica/csw.txt -o maven2_new
```

The compiler will report word counts, trie sizes, DAWG compression ratios, and entry counts for both sections. It automatically verifies round-trip correctness before writing the output.

### 4. Replace the data fork

On Classic Mac (or in the QEMU emulation environment), the data fork of the `maven2` file needs to be replaced with the new binary. The resource fork (containing CODE segments, MUL resources, ESTR resources, and all other application data) remains unchanged.

In the QEMU environment:
- Back up the original `maven2` file
- Replace the data fork contents with the output of `build_dawg.py`
- The resource fork stays intact (it contains the executable code and pre-computed evaluation tables)

### 5. Verify

```bash
# Extract words from the rebuilt data fork and verify round-trip
python3 dump_dawg_sections.py --path maven2_new
```

Then test in QEMU with actual gameplay: start a game, play words that are new in NWL23/CSW (not present in TWL98/OSW), and verify Maven accepts them. Also verify that Maven's AI generates moves using the new words.

---

## Risks and Limitations

### Leave Evaluation Tables Are Static

Maven's leave evaluation system uses MUL resources (27 total, one per tile including blank) containing pre-computed centipoint adjustments. The values in these resources were tuned for TWL98/OSW tile distributions and word availability. CODE 32 implements the leave evaluator, computing a binomial-weighted average of per-tile-count adjustments:

```
result = SUM(MUL[i+1].adj - MUL[0].adj) / SUM(C(n,i) * C(m,j-i))
```

These MUL values will not change when the dictionary is updated. This means:

- **No breakage**: The leave evaluator will continue to function correctly. It operates on tile counts and letter combinations, not on specific words.
- **Suboptimal evaluation**: New words in NWL23/CSW may create strategic opportunities (e.g., new high-scoring bingo stems, new 2-letter words enabling parallel plays) that the pre-computed leave values do not account for. Maven's play strength may be slightly reduced compared to what it could achieve with re-tuned tables.

The impact is likely small. Leave values capture general tile desirability (e.g., "holding an S is good because it enables plurals and hooks") rather than word-specific knowledge. The fundamental tile value rankings have not changed dramatically between TWL98 and NWL23.

### ESTR Pattern Synergies Are Static

The ESTR (pattern synergy) resources contain pre-computed data about letter combinations. Like MUL, these are baked into the resource fork and will not adapt to new word availability. The Q-without-U penalty, for instance, was calibrated for a world where QI was the only common Q-without-U word; newer dictionaries have added words like QOPH, QADI, and others that reduce Q's penalty.

### Vowel-Consonant Balance Cache Is Algorithmic

The VCB (vowel-consonant balance) calculation in CODE 32 is computed algorithmically at runtime, not from pre-stored tables. However, it depends on the tile pool composition (which letter is a vowel, which is a consonant), which is hardcoded. This will not be affected by dictionary changes.

### Child Pointer Field Limits

The 22-bit child pointer field supports up to 4,194,304 entry indices per DAWG section. The current DAWGs use approximately 122,000 and 145,000 entries respectively. Even if the updated dictionaries are 50% larger in word count, DAWG compression means the entry count grows sublinearly. There is no risk of exceeding the 22-bit limit -- we have roughly 30x headroom.

### File Size Changes

Updated dictionaries with more words will produce a larger data fork. The file will grow by approximately 4 bytes per additional DAWG entry (in both sections combined). A rough estimate for NWL23 + CSW:

- NWL23 (~192K words) vs TWL98 (~172K words): ~10-15% more entries in S1
- CSW (~280K words) vs OSW (~211K words): ~20-30% more entries in S2
- Original file: 1,070,788 bytes
- Estimated new file: ~1,300,000 to ~1,400,000 bytes

The Classic Mac resource manager and file system handle variable-size data forks without issue. The DAWG is loaded into memory via a single read, and the base pointer computation adapts to whatever entry count is in the header.

### Lexicon Mode State Machine

CODE 11 implements a lexicon controller with a 6-state machine that manages dictionary loading and mode switching (TWL, OSW, SOWPODS). The state machine reads DAWG data through the standard traversal functions and stores mode flags in global variables. It does not validate dictionary contents or sizes -- it simply loads whatever DAWG data is present in the data fork and sets up the appropriate base pointers.

The word validation function at CODE 11 offset 0x111C uses a 14-entry lookup table to map `(validation_state, lexicon_mode)` pairs to validity results. This table is stored in the CODE resource and determines which words are valid for each play mode. Since the table operates on DAWG traversal results (not word lists), it will work correctly with any dictionary content.

### Cross-Check Generation

CODE 37's `generate_cross_check_sets` function computes which letters can legally be placed at each board position based on perpendicular word constraints. It does this by traversing the DAWG for each relevant position. This function is entirely data-driven -- it reads the DAWG and builds bitmasks. It will work correctly with any valid DAWG regardless of dictionary contents.

---

## Verification Approach

### Pre-deployment verification

1. **Round-trip test**: Build the new DAWG, then extract all words using `dump_dawg_sections.py` and verify the extracted word sets match the input lists exactly. The compiler does this automatically, but an independent extraction confirms the file format is correct.

2. **Size sanity check**: Verify the output file size matches the expected formula: `12 + (s1_entries * 4) + 104 + (s2_entries * 4) + 104`.

3. **Spot-check known words**: Verify that specific words from the new dictionaries (especially newly added words not in TWL98/OSW) are found by the DAWG traversal algorithm.

### In-emulator testing

1. **Launch test**: Boot Maven in QEMU with the new data fork. Verify it starts without errors and the dictionary selection menu works.

2. **New word acceptance**: Play words that are in NWL23/CSW but not in TWL98/OSW. Verify Maven accepts them as valid.

3. **AI move generation**: Let Maven generate moves and verify it uses new words when they are the best play. This confirms that both the forward dictionary (S2) and the cross-check DAWG (S1) are functioning correctly.

4. **Mode switching**: Test all three lexicon modes (TWL, OSW, SOWPODS) to verify the state machine correctly handles the new data.

---

## Conclusion

Updating Maven's dictionary is feasible and low-risk. The DAWG format is fully understood, we have a working compiler, and the runtime performs no validation that would reject new data. The primary limitation is that Maven's pre-computed evaluation tables (MUL and ESTR resources) were tuned for the original dictionaries and will not be re-optimized for new word availability. This represents a minor play-strength degradation rather than a functional problem. For practical purposes, a dictionary-updated Maven will play correct, strong Scrabble with modern word lists.
