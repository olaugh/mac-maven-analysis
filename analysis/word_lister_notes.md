# Maven Word Lister and DAWG Structure Analysis

## Summary

The DAWG (Directed Acyclic Word Graph) in Maven is **optimized for cross-check validation during move generation**, not for direct word enumeration.

### Key CODE Resources

| CODE | Purpose |
|------|---------|
| **CODE 15** | DAWG pattern matching with callbacks - likely powers Word Lister |
| **CODE 12** | Word validation during move generation |
| **CODE 30** | Core DAWG traversal engine |
| **CODE 5** | Dictionary initialization, lexicon loading |
| **CODE 7** | Lexicon mode switching (North American, UK, Both) |

### DAWG Entry Format (4 bytes)

```
bytes 0-1: ptr (16-bit big-endian pointer base)
byte 2:    flags
           - bit 7 (0x80): Valid affix marker (for cross-checks)
           - bit 0 (0x01): Last sibling in group
byte 3:    letter (ASCII lowercase, a-z)

Child calculation: child_entry = ptr + (flags & 0x7e)
```

### Critical Insight: WORD Flag Meaning

The 0x80 flag does NOT mean "this is a complete valid word". Instead, it means:

> "A valid word can END with this letter sequence"

This is used for **cross-check validation** during move generation:
- When placing tiles perpendicular to existing letters, Maven needs to verify the resulting cross-word is valid
- The WORD flag allows quick determination of valid ending patterns

**Example**: 'bb' has WORD=True because words like 'ebb', 'drabber' end in 'bb', even though 'bb' itself isn't a word.

### Structure

```
Section 1 (entries 0-56,629): REVERSED words, indexed by last letter
Section 2 (entries 56,630-122,165): Forward entry points that reuse Section 1's suffix structure
```

Words are validated by:
1. Section 1: Reverse the word, start in the range for the last letter, follow children
2. Section 2: Start with forward word, follow children through the structure
3. A word is valid if EITHER section validates it

### Validation Algorithm

To validate a word like "aardvark":

1. Reverse: "kravdraa"
2. Start at k-range (entries 956-1006)
3. Search all sibling groups for 'r' with WORD=True or follow children for remaining letters
4. If found in any group, word is valid

The search must check ALL sibling groups in a range, not just the first match.

### Why Direct Enumeration Fails

1. The WORD flag marks affixes, not complete words
2. The structure is graph-like (suffix sharing), not tree-like
3. Same nodes can be reached via multiple paths
4. Enumerating all paths produces gibberish or incomplete results

### Key Structural Finding: Section 2 → Section 1 Child Pointers

Analysis of Section 2 child pointers reveals:
- **100% of Section 2 children point back to Section 1** (the shared suffix pool)
- Section 2 is purely an "entry layer" - it provides forward word START points
- But all subsequent traversal goes through Section 1's REVERSED structure

This means:
- Section 2 entry 'C' with child at Section 1 entry 293
- Entry 293 might be 'E' (part of reversed word structure)
- The path C→E is actually building reversed suffixes

**Implication for Word Lister**: To enumerate forward words, CODE 15 likely:
1. Uses Section 2 for initial letter(s)
2. Follows children into Section 1
3. **Reverses the collected suffix** to produce forward words
4. Or uses pattern matching where the pattern constrains the traversal

### Correct Approach for Word Extraction

Use a reference wordlist (SOWPODS, TWL, etc.) and validate each word against the DAWG.

The `extract_dictionary.py` script does this:
- Loads reference words from SOWPODS
- Validates each against both Section 1 and Section 2
- Outputs valid words to `maven_validated.txt`

### CODE 15 Analysis (Word Lister)

Key functions:
- `search_dawg_with_pattern` (0x0000): Search DAWG for pattern match
- `walk_to_next_child` (0x00CE): Navigate sibling chains
- `generate_words_from_pattern` (0x0124): Build matching words
- `recursive_pattern_match` (0x0272): Deep traversal with callback

The Word Lister likely uses CODE 15 to:
1. Accept a pattern (e.g., "?AT" or "ABC*")
2. Recursively traverse DAWG matching the pattern
3. Collect matches via callback
4. Display results to user

### Files Created During Analysis

- `enumerate_words_correct.py` - Failed enumeration attempts
- `enumerate_validated.py` - Brute-force enumeration with validation
- `enumerate_full.py` - Full validation with both sections

### What Would Be Needed for Direct Enumeration

To enumerate words directly (like Maven's Word Lister does), one would need to:

1. **Understand the terminal condition** - What marks a complete word vs. just a prefix?
   - May be `ptr == 0` (no children = terminal)
   - Or a specific flag combination
   - Needs verification from CODE 15 disassembly

2. **Handle the Section 2 → Section 1 transition** - Build forward words by:
   - Taking first letter(s) from Section 2
   - Following children into Section 1
   - Reversing the Section 1 suffix portion

3. **Implement pattern matching** - For wildcards and length filters:
   - '?' matches any single letter
   - '*' matches any sequence
   - Length constraints limit traversal depth

4. **Trace CODE 15's `recursive_pattern_match` (0x0272)** more carefully to understand:
   - How it handles the Section 1/2 boundary
   - What the callback receives (forward or reversed paths?)
   - How terminal nodes are identified

### Next Steps for Complete Understanding

1. Create a test pattern (e.g., "CAT") and trace CODE 15's exact path through the DAWG
2. Identify where/how the reversal happens (if at all)
3. Find the terminal node detection logic
4. Verify with known words: does the path match expectations?

### Conclusions

1. **Word enumeration without a reference is not practical** - The DAWG is optimized for validation, not enumeration
2. **The WORD flag is for cross-checks** - It marks valid ending sequences, not complete words
3. **Section 2 is just an entry layer** - All children point to Section 1's reversed structure
4. **Use reference wordlists** - Validate SOWPODS/TWL words against the DAWG
5. **The maven_validated.txt file contains ~220K valid words** extracted using this approach
