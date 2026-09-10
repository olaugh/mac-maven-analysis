#ifndef MAVEN_HEURISTIC_SEARCH_H
#define MAVEN_HEURISTIC_SEARCH_H
#include "candidate_ranking.h"
#include "dictionary_lookup.h"
#include "leave_table.h"
#include "move_evaluation.h"
#include "playing_level.h"

typedef struct {
    const MavenDictionarySection *sections;
    MavenMoveEvaluation *evaluation;
    MavenLeaveTable *leaves;
    MavenCandidateList *result;
    const uint8_t *opponent_rack;
    const uint8_t *row_flags; /* Shared A5-6d2 scoring controls; NULL means all zero. */
    int16_t leave_offset;
    int word_deduplication;
    /* Optional playing-level candidate filter (CODE13+0x82). NULL is full
     * strength (2100): every candidate is inserted. When set, exchange/pass and
     * placement candidates (phases 0 and 1) are admitted only if the level mask
     * accepts them; the phase-2 collector rescore is never gated. */
    MavenLevelFilter *level;
    /* Optional observation of each scored candidate before insertion. Phase0:
     * exchange/pass;1: placement;2: full collector reranking. */
    void (*candidate)(void *, int phase, const uint8_t move[34]);
    void *user;
} MavenHeuristicSearch;

/* CODE28[0x11a,0x29c): prepare leaves, generate exchanges/pass and placements,
 * retain ten, then rerank through full CODE35 evaluation when unseen>=17.
 * Opening finalists are rescored at every center-covering column. Uses CODE28
 * top-ten callbacks and optionally CODE44 word deduplication, as in Kibitz.
 * Valid original boards/racks/tables and prepared pattern caches required.
 * This is the static move-selection stage, not multi-ply simulation/endgame
 * search. The resulting list and restored board/rack are public outputs;
 * generator scratch arrays and incidental intermediate UI callbacks omitted. */
void maven_search_heuristic_moves(MavenHeuristicSearch *state);
/* Same search with the retained CODE37 crossing/row-flag workspace. */
void maven_search_heuristic_moves_shared(MavenHeuristicSearch *,uint8_t workspace[64]);
#endif
