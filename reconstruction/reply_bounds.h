#ifndef MAVEN_REPLY_BOUNDS_H
#define MAVEN_REPLY_BOUNDS_H
#include "endgame_move_cache.h"
#include <stdint.h>
typedef struct {
    uint16_t valid;
    uint32_t bits;
} MavenReplyConflictGroup;
typedef struct {
    const uint8_t *board;                  /* paired544-byte board */
    const uint32_t (*cell_conflicts)[544]; /* eight groups of32 reply IDs */
    const uint32_t *bit_masks;             /*32 original bit values */
    MavenReplyConflictGroup groups[8];
} MavenReplyConflicts;
/* CODE43[0x314,0x5d2): mark occupied-line extensions and cross-word
 * interference, clear sentinels, and merge the two board orientations. */
void maven_build_reply_conflict_map(uint32_t matrix[8][544], const uint8_t board[544],
                                    const MavenEndgameMoveCache *cache,
                                    const uint32_t bit_masks[32]);
void maven_clear_reply_conflicts(MavenReplyConflicts *conflicts);
uint32_t maven_reply_conflicts_with_move(MavenReplyConflicts *conflicts,
                                         const MavenReplySummary *reply, const uint8_t move[34]);
typedef struct {
    MavenEndgameMoveCache *cache;
    MavenReplyConflicts *conflicts;
    const uint16_t *kept_tile_points; /*128 signed-word values */
    /* CODE39+68c and+51a: result and positive/negative correction words. */
    int16_t (*paired_masks)(void *, int16_t own, int16_t other, int16_t *positive,
                            int16_t *negative);
    int16_t (*own_mask)(void *, int16_t own, int16_t *positive, int16_t *negative);
    void *user;
} MavenReplyBounds;
/* CODE27[0x26,0x14c): upper/lower are initial pruning thresholds and resulting
 * bounds. Strictly inferior in BOTH bounds returns1 and moves its decisive
 * reply to the list head. empty_reply_seen and compatible_reply_seen are
 * original word outputs used as endgame node tags. */
int maven_bound_move_against_replies(MavenReplyBounds *state, const uint8_t move[34],
                                     uint32_t *upper, uint32_t *lower, int16_t *empty_reply_seen,
                                     int16_t *compatible_reply_seen);
#endif
