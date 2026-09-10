#ifndef MAVEN_LATE_SEARCH_H
#define MAVEN_LATE_SEARCH_H
#include "late_preparation.h"
#include "late_ranking.h"
#include "late_setup.h"
#include "leave_table.h"
#include "local_replies.h"
/* Working memory is caller-owned and relocatable. Serialized guest addresses
 * are optional numeric comparison tokens, never host pointers. */
typedef struct MavenLateSearch {
    MavenApplyState *application;
    MavenLeaveTable *leaves;
    MavenPatternMatchInput patterns;
    MavenLateReplyValue value;
    const MavenDictionarySection *sections;
    const uint32_t *bit_masks;
    const uint16_t (*choose)[8];
    const uint8_t *priority_order, *q_query, *blank_query, *row_flags;
    uint32_t bingo_bonus;
    uint8_t *own_rack;
    int force;
    int16_t leave_offset;
    const uint8_t *exchange_q_string;
    uint8_t pool_rack[17], own_sorted[8], unseen_counts[128];
    MavenLatePool baseline, local;
    MavenPoolWeights pool_weights;
    MavenLateConstraints constraints;
    MavenLateRankReply baseline_rank[90], local_rank[90];
    uint16_t baseline_indices[90][182], local_indices[90][182];
    uint32_t conflict_map[8][544];
    MavenReplyConflicts conflicts;
    MavenCandidateList ranking;
    MavenLateRanking ranker;
    uint16_t occurrence_masks[128][8], anchors[31], draw_multiplicity[8];
    uint8_t bitmap[65536], current_move[34];
    MavenScoreScan last_score;
    uint16_t held_u_value, local_index;
    uint32_t baseline_token, local_token;
    void (*checkpoint)(void *, const char *stage, const struct MavenLateSearch *);
    void *user;
} MavenLateSearch;
/* CODE36+1810 normal computational path for unseen8..16, including exchanges
 * and Q expectations. Full generation, constraints, leaves, ranking and local
 * refinement; CPU fallback is handled by search_dispatch, and UI is external. Returns0 for unsupported
 * pool sizes or invalid internal state. Source acceptance is tracked by live
 * replay; unusual blank/termination domains require additional fixtures. */
int maven_search_late_game(MavenLateSearch *);
int maven_search_late_game_shared(MavenLateSearch *,uint8_t workspace[64]);
#endif
