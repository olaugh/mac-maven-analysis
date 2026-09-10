#ifndef MAVEN_LEAVE_TABLE_H
#define MAVEN_LEAVE_TABLE_H
#include "adjusted_pattern_lookup.h"
#include "rack_balance.h"

typedef struct {
    const uint8_t *sorted_rack; /* <=7 tiles; canonical masks remain seven-bit. */
    const uint8_t *alphabet, *vowel_characters;
    const uint8_t *unseen_counts, *distribution;
    const uint16_t *letter_values;
    const uint32_t (*letter_scores)[8];
    const uint16_t *q_with_unseen_u, *q_without_held_u;
    const uint8_t *held_u_query;
    MavenPatternEntry *patterns;
    int16_t pattern_count;
    const uint8_t *score_records;
    MavenRackBalanceCache *balance;
    uint32_t generation, started_generation;
    uint32_t mask_generations[128];
    uint16_t values[128], tile_points[128];
    int16_t canonical_masks[128], mask_count;
    uint16_t occurrence_masks[128][8];
} MavenLeaveTable;

/* CODE32[0xefa,0x115c), its preparation[0x8bc,0x9dc) and recursive pattern
 * propagation[0x18e4,0x1944). Prepared pattern cache and evaluator tables are
 * inputs. Updates cache timestamps, occurrence masks, canonical masks, all
 * leave words and balance cache. tile_points is only written for canonical
 * masks when unseen_total<=7; all other cells retain prior bytes. Original
 * generation counters must not wrap into the signed comparison discontinuity.
 * Standard positive tile pool and supported underlying math domains required.
 * This recovers the CODE28 heuristic generator's preparation; the alternative
 * CODE32+0x9dc search preparation is separate. */
void maven_prepare_leave_table(MavenLeaveTable *state);
/* CODE32[0x9dc,0xc00): late-search preparation for unseen_total 8..16.
 * Unlike heuristic preparation, fills every canonical tile_points cell and
 * uses adjusted pattern values with Q/blank overrides. Queries are original constant
 * strings; Blank replacement deliberately stamps the replacement lookup entry. */
void maven_prepare_search_leave_table(MavenLeaveTable *state, const uint8_t *q_query,
                                      const uint8_t *blank_query);
#endif
