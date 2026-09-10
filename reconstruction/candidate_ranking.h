#ifndef MAVEN_CANDIDATE_RANKING_H
#define MAVEN_CANDIDATE_RANKING_H
#include <stddef.h>
#include <stdint.h>

/* Raw original move layout: 34 bytes, including three BE32 score terms at
 * +16, +20, +24. Arithmetic wraps at 32 bits before signed comparisons. */
uint32_t maven_move_rank_bits(const uint8_t move[34]);

/* CODE3[0x1a2,0x1de): replace incumbent only on a strictly larger signed
 * sum. Equal-ranked candidates retain the incumbent, including all metadata. */
int maven_keep_better_move(uint8_t incumbent[34], const uint8_t candidate[34]);

/* Computational part of CODE3[0x4,0x154), excluding UI formatting/display.
 * Each input entry is 46 bytes: move[34], accumulated result BE32 at +34,
 * an uninterpreted field at +38, and sample count BE32 at +42. The FIRST
 * entry's sample count is shared by every entry (zero is replaced with one).
 * Sets move+24 so its wrapped three-term sum equals the rounded signed
 * average, then sorts descending. Ties preserve original input order.
 * output must hold count*34 bytes and must not overlap entries. Returns zero
 * for count>64 (the original diagnostic is replaced with an API failure).
 * Static recovery; natural execution verification is recorded separately. */
int maven_rank_sampled_candidates(const uint8_t *entries, size_t count, uint8_t *output);

typedef struct {
    uint8_t moves[10][34];
    uint16_t count;
    uint32_t cutoff_bits;
} MavenCandidateList;

/* CODE28[0x4,0xea): top-ten insertion, stable by arrival order. The eligibility
 * callback corresponds to CODE44+0xee and remains a caller-supplied boundary.
 * It runs after the full-list cutoff check, before insertion; rank is captured
 * before it runs. It may remove a duplicate from list (CODE44+0x84 does so),
 * but must not invalidate candidate or violate count<=10/sorted-list invariants.
 * Updating cutoff reads slot9 even while count<10, preserving original state;
 * callers should initialize all slots as CODE28+0x11a does. Return is a port
 * convenience indicating insertion, not a claimed original return register. */
int maven_insert_ranked_candidate(MavenCandidateList *list, const uint8_t candidate[34],
                                  int (*eligible)(void *, const uint8_t *), void *user);

/* CODE44[0x84,0xee), removal helper [0x16e,0x1ac): word-only duplicate filter.
 * Reject if the first matching word has an equal or greater rank; otherwise
 * remove it and accept. Coordinates and other metadata do not affect matching.
 * Removal leaves the old last slot and cutoff untouched, as in the executable. */
int maven_accept_word_improvement(MavenCandidateList *list, const uint8_t candidate[34]);

/* CODE44[0xee,0x16e): with mode==1, reject second-orientation moves whose first
 * empty square has an occupied orthogonal neighbor. Then run the optional
 * extra filter. Valid original board/move contract: signed row/column indexing
 * stays inside the 544-byte sentinel board and finds an empty square. */
int maven_candidate_is_eligible(const uint8_t candidate[34], const uint8_t board[544], int16_t mode,
                                int (*extra_filter)(void *, const uint8_t *), void *user);
#endif
