# ESTR Synergy Patterns - Complete Reference

## Overview

The ESTR resource contains **130 pattern strings** used by Maven's leave evaluation system. These patterns represent letter combinations that have special synergy (positive or negative) values.

**IMPORTANT:** ESTR only stores the pattern strings - the actual numeric values are **computed at runtime** by CODE 39 using six score tables at A5-12512 through A5-12532. The values are not stored in the resource file.

---

## All 130 Patterns (Sorted)

### Single Letters (28 patterns)
Base reference patterns for individual tiles:
```
?
a, b, c, d, e, f, g, h, i, j, l, m, n, o, p, r, s, v, w, x, y, z
```
Note: k, q, t, u not listed individually (may be implicit or handled separately)

### Duplicate Letter Patterns (43 patterns)

**Blanks:**
```
??
```

**Vowel Duplicates:**
| Letter | Patterns |
|--------|----------|
| A | aa, aaa, aaaa, aaaaa |
| E | ee, eee, eeee, eeeee, eeeeee |
| I | ii, iii, iiii, iiiii |
| O | oo, ooo, oooo, ooooo |
| U | uu, uuu, uuuu |

**Consonant Duplicates:**
| Letter | Patterns |
|--------|----------|
| B | bb |
| C | cc |
| D | dd, ddd, dddd |
| F | ff |
| G | gg, ggg |
| H | hh |
| L | ll, lll, llll |
| M | mm |
| N | nn, nnn, nnnn |
| P | pp |
| R | rr, rrr, rrrr |
| S | ss, sss, ssss |
| T | tt, ttt, tttt |
| V | vv |
| W | ww |
| Y | yy |

### Q-Related Patterns (6 patterns)
Patterns involving Q, including Q-without-U playability:
```
qu      - Traditional Q+U synergy
aq      - QAT hook potential
aiq     - QI playable, QAID potential
adq     - QADI potential
aqt     - QAT potential
adiq    - Multiple Q-without-U words
```

### Consonant Digraphs (4 patterns)
Common consonant combinations:
```
ch      - CH digraph
ck      - CK digraph
ht      - HT combination
hw      - HW combination
```

### Suffix/Prefix Patterns (21 patterns)
Common English affixes and word-forming combinations:
```
gin     - -ING potential
flu     - FLU- prefix
ily     - -ILY suffix
ino     - -INO suffix
inot    - -TION anagram
ity     - -ITY suffix
osu     - -OUS anagram
otu     - -OUT anagram
eiv     - -IVE anagram
eiz     - -IZE anagram
amn     - MAN anagram
emn     - MEN/NAME anagram
boy     - BOY word
bel     - BEL-/BELL
ery     - -ERY suffix
ary     - -ARY suffix
fiy     - FLY/FRY potential
elss    - -LESS anagram
enss    - -NESS anagram
imu     - -IUM anagram
aeg     - AGE anagram
```

### Vowel Combination Patterns (9 patterns)
Patterns involving multiple vowels:
```
aeio    - Four vowels
aeiou   - All five vowels (likely penalty)
aeit    - AEIT combination
dei     - DEI combination
de      - DE combination
eir     - EIR combination (THEIR, etc.)
er      - ER combination (very common)
iu      - IU vowel pair
uw      - UW vowel pair
```

### Position/Hook Patterns (8 patterns)
Patterns for board position analysis:
```
ory     - -ORY suffix
dio     - DIO combination
his     - HIS word
eist    - -IEST anagram
est     - -EST suffix
eikl    - LIKE anagram
```

### Consonant Cluster Patterns (11 patterns)
Groups of consonants that work well/poorly together:
```
dg          - DG cluster
bcmp        - Heavy consonants
bgjkf       - Difficult consonants
lnrtsu      - Common consonants
jx          - J+X (both high value)
fhkwvy      - Mixed value consonants
fhwyx       - Similar cluster
dgbmp       - Heavy cluster
fhkjwyx     - Large difficult cluster
mpfhxwy     - Mixed cluster
mpdglnrtsu  - Large mixed cluster
udlnrst     - Common letter cluster
mpxhwy      - Consonant cluster
```

### Full Alphabet Reference
```
abcdefghijklmnopqrstuvwxyz
```

---

## Runtime Value Computation

CODE 39 computes synergy values using:
1. **Six score tables** at A5-12512, A5-12516, A5-12520, A5-12524, A5-12528, A5-12532
2. **Cross-check analysis** for hook potential (hook-before and hook-after positions)
3. **Position-dependent scoring** based on board state

The computation involves:
- Looking up each pattern in the results array
- Combining scores from multiple tables
- Applying cross-check masks for valid letter placement
- Comparing and selecting optimal scores

### Frame Size
CODE 39 uses a **9632-byte stack frame** for exhaustive letter combination analysis, indicating extensive temporary storage for all possible combinations.

---

## Notable Observations

### Missing Patterns
Some common combinations are NOT in ESTR:
- **AE** - Not a synergy pattern (vowel pairs handled differently?)
- **AI, AO, EI, EO, IO, OU** - Most vowel pairs not explicit
- **K, Q, T, U** - Single letters not listed (may be implicit)

### Vowel Balance
The patterns suggest vowel balance is handled through:
1. **AEIOU pattern** - Likely a penalty for all-vowel racks
2. **IU and UW patterns** - Specific vowel pair handling
3. Individual vowel duplicate patterns (EE, II, etc.)

The vowel balance effect the user observed (preferring E over AE) may come from:
- Computed synergy values penalizing vowel-vowel combinations
- Or from the VCB system (which accesses FRST resource)

---

## Technical Reference

| Property | Value |
|----------|-------|
| Resource Type | ESTR |
| Resource File | `resources/ESTR/0_pattern_strings.bin` |
| Total Patterns | 130 |
| Value Storage | Runtime computed by CODE 39 |
| Score Tables | 6 tables at A5-12512 to A5-12532 |

---

## Related Documentation

- **CODE 39 Analysis**: Runtime synergy computation
- **LEAVE_VALUES.md**: Complete leave evaluation system
- **CODE 32 Analysis**: Leave scoring integration
