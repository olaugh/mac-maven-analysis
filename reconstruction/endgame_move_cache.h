#ifndef MAVEN_ENDGAME_MOVE_CACHE_H
#define MAVEN_ENDGAME_MOVE_CACHE_H
#include "candidate_ranking.h"
#include <stdint.h>
/* CODE27's14-byte opponent-reply descriptor, represented without guest
 * pointers. -1 is no link; next indices0..255 address the two-per-mask table,
 * indices256..265 the extra top-ten summaries. */
typedef struct {
    int16_t next;
    uint32_t score_bits;
    uint8_t emptied_rack, kept_mask, row, column, length, identifier;
} MavenReplySummary;
typedef struct {
    uint32_t best[128], second[128];
    MavenReplySummary replies[266];
    int16_t first;
    uint16_t summary_count;
} MavenEndgameMoveCache;
void maven_summarize_reply(MavenReplySummary *summary, const uint8_t move[34]);
int maven_reply_same_placement(const MavenReplySummary *a, const MavenReplySummary *b);
/* CODE27[0x1d4,0x29a): preserve exact ID assignment and linked traversal.
 * Only original table entries with row!=0 join the initial list. */
void maven_link_reply_summaries(MavenEndgameMoveCache *cache, const MavenCandidateList *ranking);
/* CODE40[4,9c) after placement eligibility: update top two scores per kept
 * mask. The reply form also maintains summaries, sets all-tiles leave bonus20,
 * and uses mask/coordinates deduplication before top-ten insertion. */
void maven_cache_own_endgame_move(MavenEndgameMoveCache *cache, MavenCandidateList *ranking,
                                  const uint8_t move[34]);
void maven_cache_opponent_endgame_move(MavenEndgameMoveCache *cache, MavenCandidateList *ranking,
                                       uint8_t move[34]);
int maven_accept_endgame_placement_improvement(MavenCandidateList *ranking, const uint8_t move[34]);
#endif
