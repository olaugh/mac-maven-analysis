#ifndef MAVEN_PLAYING_LEVEL_H
#define MAVEN_PLAYING_LEVEL_H
#include <stdint.h>
/* Playing levels ("nerfed" strength), reconstructed from CODE13 and the live
 * A5 tables. The original Level menu offers 18 strengths, 2100 down to 1420 in
 * steps of 40. CODE13+0x00b2 is the single computer-move entry:
 *
 *   - Level 0 (2100): full CODE44 dispatch (heuristic / pre-endgame / endgame
 *     by unseen count). Full strength.
 *   - Levels 1..17 (2060..1420): CODE28 heuristic ONLY (no pre-endgame or
 *     endgame), and most generated candidates are dropped by a fixed
 *     acceptance filter (CODE13+0x0082) before they can enter the top-ten
 *     ranking, so Maven plays the best of a starved shortlist.
 *
 * The filter keeps a 256-slot acceptance mask with accept[level] slots set at
 * stride 17 (mod 256), and a persistent counter advanced once per generated
 * exchange/pass/placement candidate. Candidate p is admitted iff mask[p] is
 * set, i.e. iff ((17^-1 * p) mod 256) < accept[level] with 17^-1 == 241. The
 * CODE28 phase-2 collector rescore of the survivors bypasses the filter.
 *
 * Both tables were read from the running Maven (RAM dump CurrentA5 0x07cf5500):
 * ratings from A5-0x5e74, accept counts from A5-0x1d44. The per-move leave bias
 * A5-0x5ab4 is round(rating_cap - player_rating), added to every leave value.
 *
 * Verified against the recovered code and the live tables, and against the
 * recorded 2100 rankings at level 0 (no drop). Byte-equivalence to the original
 * at a reduced level is not yet checked (needs a fresh reduced-level capture).
 * Pure C99 integers, so this compiles for the host, wasm and a 68k target. */
#define MAVEN_LEVEL_COUNT 18
extern const int16_t maven_level_ratings[MAVEN_LEVEL_COUNT];
extern const uint16_t maven_level_accept[MAVEN_LEVEL_COUNT];
typedef struct {
  int active;       /* 0 admits every candidate (level 0); 1 applies the mask. */
  uint16_t accept;  /* accept[level]: admitted slots out of 256. */
  uint16_t counter; /* Persistent global candidate counter, mod 256. */
} MavenLevelFilter;
/* Prepare a filter for a level (0-based menu index) with a starting counter. */
void maven_level_filter_init(MavenLevelFilter *, int level_index, uint16_t counter);
/* Admit the candidate at the current counter position and advance it. Matches
 * the original mask built at stride 17: slot s is set iff (241*s mod 256)<N. */
int maven_level_admit(MavenLevelFilter *);
/* Pure predicate over a linear candidate index, for tests and offline replay. */
int maven_level_accepts(unsigned index, uint16_t accept);
/* round(rating_cap - player_rating), the per-search leave bias A5-0x5ab4. */
int16_t maven_level_leave_offset(int level_index, int16_t player_rating);
#endif
