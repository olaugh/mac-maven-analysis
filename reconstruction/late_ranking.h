#ifndef MAVEN_LATE_RANKING_H
#define MAVEN_LATE_RANKING_H
#include "candidate_ranking.h"
#include "late_reply_value.h"
#include "reply_bounds.h"
#include <stdint.h>
typedef struct MavenLateRankReply {
    uint8_t record[66];
    const uint16_t *constraints; /* Zero-terminated; index0 is also consumed. */
    const struct MavenLateRankReply *next;
} MavenLateRankReply;
typedef struct {
    MavenLateReplyValue *value;
    MavenCandidateList *ranking;
    MavenReplyConflicts *conflicts;
    const MavenLateRankReply *baseline, *local, *fallback_reply;
    const uint16_t *weights;
    uint16_t weight_count, total_weight;
    uint32_t local_cutoff_bits, minimum_reply_score_bits;
    uint32_t fallback_cache[8][2];
    int word_deduplication;
    void (*valuation)(void *, const uint8_t move[34], const uint8_t reply[66], uint32_t result);
    void *user;
} MavenLateRanking;
/* CODE36+113a: merge baseline/local reply lists, allocate remaining multiset
 * weights subject to their constraints, value replies and insert the candidate
 * into CODE28's ranking. Includes both unseen-Q and
 * ordinary valuation paths. Returns0 before mutation for invalid weight count. */
int maven_rank_late_move(MavenLateRanking *, uint8_t move[34]);
#endif
