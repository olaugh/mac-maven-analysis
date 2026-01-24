# Maven Word Lister and DAWG Structure Analysis

## Summary

The DAWG (Directed Acyclic Word Graph) in Maven is **optimized for cross-check validation during move generation**, not for direct word enumeration.

## Dynamic Tracing Results (2026-01-24)

**QEMU + trace log analysis confirmed:**

- CODE 15 powers the Word Lister (loaded at runtime base 0x7c9a600)
- Multi-section DAWG architecture with parallel base/position arrays
- 8-byte section structures (indexed by section * 8)
- Section count at A5-10936 controls iteration

**Word Lister search for "cat" produced 4 words: act, at, cat, ta**

| Metric | Value |
|--------|-------|
| Section iterations | 4 (one per result word) |
| DAWG traversal loops | 5 (letter comparisons) |
| Key functions | 0x0088 (iterator), 0x00B8 (walk) |

### Key CODE Resources

| CODE | Purpose |
|------|---------|
| **CODE 15** | DAWG pattern matching - **confirmed via tracing** to power Word Lister |
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
Section 1 (entries 0-56,629): REVERSED words, indexed by last letter - PARTIAL dictionary
Section 2 (entries 56,630-122,165): Forward entry points - FULL dictionary
Section 3 (entries 122,166-145,475): Additional entry points (possibly second lexicon)
```

**Important Discovery**: Section 1 and Section 2 validate DIFFERENT word sets:
- Words like "AA", "CAT" validate via BOTH Section 1 and Section 2
- Words like "BA", "FA", "HA", "AB" validate ONLY via Section 2
- Section 1 appears to be optimized for cross-check validation (suffix patterns)
- Section 2 is the complete forward dictionary

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

### Enumeration Attempts (Static Analysis)

Multiple enumeration approaches were attempted:

1. **Section 1 enumeration** - Traversing letter ranges and collecting paths with is_word=True
   - Result: Produces many false positives (e.g., "bb", "ff" marked as words)
   - Reason: is_word marks valid suffixes, not complete words

2. **Section 2 enumeration** - Starting from forward entry points
   - Result: Produces gibberish (e.g., "aaliooooagcmiect")
   - Reason: The DAWG shares suffix nodes between different words
   - Example: A@56656 → A@98 → A@103 gives "AAA" which isn't a valid word
   - The path combines prefixes from one word with suffixes from another

3. **Why validation works but enumeration doesn't**:
   - Validation: Given "CAT", check if the SPECIFIC path C→A→T exists with is_word at end
   - Enumeration: Explore ALL paths, record when is_word=True
   - The suffix-sharing structure means many invalid paths exist that happen to end at is_word=True nodes

### Dynamic Debugging Would Help

To understand how Maven's Word Lister actually enumerates words, dynamic debugging would reveal:

1. **What constraints the Word Lister applies** beyond just is_word checks
2. **Whether it uses pattern matching** to limit traversal (e.g., requiring wildcards)
3. **How it handles the Section boundary** between forward and reversed structures
4. **What the callback receives** - forward words or reversed paths that get unreversed?

Suggested debugging approach:
- Run Maven in QEMU with GDB attached
- Set breakpoint at CODE 15's `recursive_pattern_match` (0x0272)
- Use Word Lister with a simple pattern like "CAT" or "???"
- Trace the traversal path and observe what gets passed to the callback

### Conclusions

1. **Word enumeration without a reference is not practical** - The DAWG is optimized for validation, not enumeration
2. **The WORD flag is for cross-checks** - It marks valid ending sequences, not complete words
3. **Section 2 is the complete dictionary** - Section 1 is partial (cross-check optimized)
4. **Use reference wordlists** - Validate SOWPODS/TWL words against the DAWG
5. **The maven_validated.txt file contains ~220K valid words** extracted using this approach
6. **Dynamic debugging recommended** - To understand the Word Lister's actual algorithm
