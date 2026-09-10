# Word List core reconstruction

`reconstruction/word_enumerator.c` covers the CODE 12 core at resource offsets
0x038e..0x0668. Its native state structure names the relevant globals without
pretending to overlay the 68k memory layout. This includes the prefix walk,
rack walk, suffix matching, candidate constraints and guarded emission.

The shared letter-consumption helper expresses duplicated original paths.
Both paths prefer a real letter and use a blank only when its count is exhausted;
they do not explore an alternate blank allocation when a real tile exists.
Recursive return restores counts, blanks-used and the word cursor. The original
clears the byte at the old word-end cursor before decrementing that cursor;
the reconstruction retains this detail rather than assuming the popped byte
is immediately cleared.

Children use logical right shift by ten here, unlike the membership primitive's
arithmetic shift. Prefix and suffix '?' match one character. The candidate
filter checks length, minimum blank use, and required letter multiplicities.
It increments the occurrence workspace then clears entries for letters seen
in the candidate. The prefix routine checks the 1,000-result limit on entry;
the rack routine considers its terminal candidate before checking child descent.
The emission adapter separately enforces the same limit and increments the
count after polling/appending returns. UI polling and list storage remain
external adapter responsibilities.

Earlier-section membership suppresses duplicates before emission. The live
caller and lookup observations supporting that relationship are recorded in
`DICTIONARY-LOOKUP.md`; they do not yet validate this entire recursive routine.

## Reproducible probe

Run `scripts/run_word_enumerator.py --data-file PATH --rack cat` from this repo.
The runner checks the preserved data-fork hash before using the section offsets
and roots already verified against original memory. `--prefix`, `--suffix`,
`--on-board`, `--bingos`, and rack '?' are available. Inputs must already be
lowercase ASCII; the driver allows up to 31 characters per field, which is
an investigation limit, not a verified reproduction of UI field limits.
The driver uses the ordinary length limits 2..15;
it is not a replacement application or a complete resource/file-format loader.

The CAT probe emits `act`, `at`, `cat`, `ta`, agreeing with the four words
observed earlier in Maven's UI. QUIZZIFY emits 13 words: the first section's
seven followed by six unique words from the second. QUIZZIFY's complete
emission order is not yet compared with original append calls; four other
natural queries now have complete comparisons below.

Host tests check recursion restoration, duplicate suppression, prefix/suffix
wildcards, required counts, real-letter preference with minimum blank use,
and the 1,000-result limit. Sixteen focused host tests pass. Original-runtime
enumeration captures with ordinary tiles, blanks and filters now pass.
Toolbox field extraction, character normalization, cancellation/error handling
and UI rendering are still outside this reconstructed core.

## Complete natural enumeration comparisons

`scripts/capture_word_enumeration.py` stops CODE 12 at +0x02d8 before the
section loop, after normal input preparation. It checks all loaded CODE 12
bytes and both complete dictionary tables, then records calls at the actual
append site +0x03a2 until normal loop completion at +0x0314. It compiles the
reconstruction with the captured initial state and compares emission order
and the final core workspace. No guest input/call/register/memory injection
is used; queries are submitted through the ordinary Word List dialog.

| UI query | Emissions | Ordered output and final state |
|---|---:|---|
| Rack CAT | 4 | Exact match |
| Rack CA? | 50 | Exact match |
| Rack CA?, prefix c?, suffix t | 10 | Exact match |
| Rack CA?, On Board t | 85 | Exact match |

All **149 emissions** match. Final-state comparisons include all three
128-entry count workspaces, blank use, length limits, result count, word cursor,
all 32 word-buffer bytes and pattern fields. Evidence is indexed by
`word-enumerator-live-summary.json`; full captures retain before/after
workspaces and both sequences. The disposable VM was stopped afterward.

### Global aliases and query setup

Remaining blanks are `available['?']`: A5-0x2264 equals the array base
A5-0x22e2 plus 63*2. Minimum blank use similarly aliases
`required_counts['?']` at A5-0x2364. The native state now preserves these aliases.

`reconstruction/query_prepare.c` now reconstructs counting, mode transformation,
count merging and core reset from normalized ASCII strings. Maven adds the
fixed suffix T to the available pool, so the filtered query emits ten words.
The setup loop at CODE 12+0x024a..0x029a forms each available count as the
maximum of rack-plus-required count, suffix count and prefix count. Pattern
wildcards do not contribute to the prefix/suffix count arrays.

For All Words, on-board counts become required counts. For Bingos, the mode
transform takes the larger rack/on-board count for each character, builds a
unique required-letter string excluding '?', and adds one available blank
before the common merge. This distinction is reconstructed from instructions;
Bingos still needs a natural runtime comparison. The literal All Words
on-board string is retained, including '?' if supplied; its UI behavior is
not independently established.

`tests/test_query_prepare.py` compares prepared fields and all count arrays
against the four captured initial states. Running the probe from those four
normalized text queries also reproduces all 149 original emissions in order,
recorded in `query-preparation-comparison.json`. This reuses the earlier
debugger captures; it is not a new VM observation. Toolbox field parsing,
MacRoman normalization and length-control extraction remain external.

Unverified paths include cancellation/nonlocal errors, a natural 1,000-result
limit run and malformed input/table behavior. These normal-case comparisons
do not establish complete Word List or application reconstruction.
