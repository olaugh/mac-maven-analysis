#ifndef MAVEN_LOCAL_REPLIES_H
#define MAVEN_LOCAL_REPLIES_H
#include "apply_move.h"
#include "board_moves.h"
/* CODE37[0x4da,0x764): anchors affected by the proposed placement, before
 * applying it. The second rack length is capped at seven. Masks include
 * original sentinel bits; the generator visits only playable anchors. */
void maven_local_reply_anchor_masks(uint16_t masks[31], const uint8_t board[544],
                                    const uint8_t move[34], const uint8_t *reply_rack,
                                    const uint32_t bits[32]);
typedef struct {
    MavenApplyState *application;
    const MavenDictionarySection *sections;
    const uint32_t *bit_masks;
    const uint16_t *leave_values;
    uint32_t bingo_bonus;
    const uint8_t *row_flags;
    uint16_t row_masks[31];
    uint8_t sorted_rack[8]; /* original full rack used for prepared mask positions */
    void (*ready)(void *);  /* after apply/count, before reply enumeration */
    void (*candidate)(void *, const uint8_t move[34]);
    void *user;
    MavenScoreScan *last_score; /* Optional mirror, updated before candidate. */
} MavenLocalReplies;
/* CODE37+548: apply own move, generate replies within its influence area,
 * then undo the placement and restore the own rack. The original leaves
 * count/scorer/sorted-rack/undo workspaces describing the reply traversal.
 * Nested calls require separate application workspaces or explicit saves. */
void maven_generate_local_replies(MavenLocalReplies *state, const uint8_t move[34],
                                  uint8_t *own_rack, const uint8_t *reply_rack);
/* Larger-pool form of the same original routine. Prepared rack/masks retain
 * full pool positions; own rack still has at most7 tiles. Other may have16. */
void maven_generate_local_pool_replies(MavenLocalReplies *, const uint8_t move[34], uint8_t *own,
                                       const uint8_t *other, const uint8_t *prepared_rack,
                                       const uint16_t occurrences[128][8]);
void maven_generate_local_replies_shared(MavenLocalReplies *,const uint8_t move[34],uint8_t *own,
    const uint8_t *other,const uint8_t *prepared_rack,const uint16_t occurrences[128][8],
    int pool,uint8_t workspace[64]);
#endif
