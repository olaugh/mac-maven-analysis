# Candidate ranking recovered from corrected executable bytes

Resource offsets include the four-byte CODE header. Old CODE3 notes that call
34-byte copies “DAWG headers” are superseded for these paths. Move fields +16,
+20,+24 are summed with32-bit wrap then compared as signed long. Their complete
producer semantics remain under recovery; they are not the22-long statistics
vector.

- CODE28[4,ea) retains ten candidates, descending by signed wrapped sum.
  Equal scores preserve arrival order. A full list rejects scores <=cutoff
  BEFORE running CODE44+ee eligibility. Eligibility can remove an existing
  duplicate; insertion uses the resulting current count. Rank is computed
  before eligibility. The cutoff updates from slot9 even when fewer than ten
  entries exist, so trailing storage state matters for exact traces.
- CODE44[84,ee) compares only C-string word text. The first equal word rejects
  a candidate with an equal/lower sum. A higher sum removes that entry, then
  permits insertion. CODE44[16e,1ac) shifts survivors but leaves trailing bytes
  and cutoff untouched.
- CODE44[ee,16e) mode1 examines second-orientation rows>15: scan occupied cells
  to the first empty square, then reject if either in-bounds neighboring row
  has a tile there. Otherwise delegate to the optional filter. Mode1's board
  branch is statically recovered, not covered by the accepted opening trace.
- CODE3[1a2,1de) changes the incumbent only on strict improvement.
- CODE3[4,154) computational portion: read shared sample count from the FIRST
  46-byte entry+42 (zero→one). For each entry, signed divide the wrapped sum
  `accumulated_result + samples/2` by samples. Set move+24 to average minus
  terms+16/+20. Process entries backward, insert before equal scores: final
  order preserves original entry order on ties. UI display/formatting excluded.
  This asymmetric rounding is preserved for negative values. Sample counter
  and score interpretation beyond observed code should not be guessed.

`reconstruction/candidate_ranking.[ch]` uses explicit fixed-width arithmetic,
raw original move byte layout, native callback/context state. No classic Mac
OS dependency. A future modern/wasm engine can use the same module. Changing
ranking weights, deduplication policy, capacity or tie behavior is localized,
but each is a deliberate behavior change and must retain original-mode tests.

## Evidence

`candidate-top10-filter-live.json`:64 original calls;37 insertions,27 prefilter
cutoff skips, all340 list bytes/count/cutoff match portable C. Eligibility is
supplied from the recorded callback return for this earlier capture.

`candidate-top10-eligibility-live.json`:128 natural calls;31 insertions,37
cutoff skips,60 eligibility rejections. Portable CODE28+CODE44 matches the
eligibility return, intermediate removal side effects and final list state.
Modes2–6; extra filter A5+ad2 (word deduplication). Full CODE28 code identity at
actual entry and full CODE44 identity while paused immediately after capture
(`candidate-eligibility-code-identity.json`). No injected board or move memory.
These are opening-game candidate calls, not a complete generator comparison.

`tests/test_candidate_ranking.py`:300 independent randomized numeric/order
oracle cases for CODE3, plus strict incumbent/tie/overflow checks. CODE3 is not
claimed naturally executed by these tests. `scripts/replay_candidate_ranking.py`
replays original captures and fails on mismatches, including callback ordering.
