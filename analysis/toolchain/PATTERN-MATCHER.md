# Rack and board pattern matcher

`pattern_match.c` reconstructs CODE35[0xa48,0xcd0). It visits source records
in ID order, ignoring record0 and records whose score-table index is0.
Row byte0 selects rack-multiset matching unless board_only is nonzero. It
decrements counts through the first missing letter, then restores every
consumed count, including the failed decrement. Successful rack records use
the full BE32 score at record-table+24 for totals, and low signed16 bits for
optional weight output.

Nonzero row selects an anchored board pattern. The anchor must contain a
letter from the record's string. A linked list of relative coordinate records
must all point to empty board cells. The original checks anchor row/column
1..16; relative positions and record links are trusted internal data.
If the anchor tile value is0, its score moves toward0 by twice the letter
value, clamping at0. The negative-score path doubles at word width before
sign-extension; the positive-score path doubles at long width. Otherwise,
a Q anchor with a multi-letter allowed string halves the signed score toward0.
The optional output arrays are terminated with0; zero weights before the
terminator remain valid, so use the ID list to determine output length.

Two natural opening-engine calls return -861 and restore all128 counts,
matching native C. A breakpoint at each emission site identifies rack record64
as the contributing record in the second call, also matching C. Those calls
have no requested original output arrays; observing emission sites avoids
altering the original pointer arguments. This is evidence for the observed
rack path, not blanket validation of board/blank/Q adjustments. Host tests
cover linked-square rejection, duplicates/multisets, restoring a failed
count decrement, blank-score clamping, Q halving, mode filtering, and the
full-long total versus truncated-word weight distinction.
