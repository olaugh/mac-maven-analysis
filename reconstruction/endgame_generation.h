#ifndef MAVEN_ENDGAME_GENERATION_H
#define MAVEN_ENDGAME_GENERATION_H
#include "apply_move.h"
#include "board_moves.h"
#include "endgame_move_cache.h"
#include "endgame_rack_bounds.h"
#include "reply_bounds.h"
typedef struct {
    MavenApplyState *application;
    const MavenDictionarySection *sections;
    uint32_t bingo_bonus;
    const uint32_t *bit_masks;
    const uint8_t *row_flags;
    uint8_t sorted_rack[8];
    uint16_t canonical_masks[128], tile_points[128], occurrence_masks[128][8];
    unsigned mask_count;
    uint16_t tables[2][3][128][9]; /* side0 own,side1 opponent; A,B,error */
    MavenEndgameMoveCache cache;
    MavenCandidateList ranking;
    uint32_t conflicts[8][544];
    /* Every generated raw record before CODE40 filtering/mutation. */
    void (*candidate)(void *, int side, const uint8_t move[34]);
    void *user;
} MavenEndgameGeneration;
/* CODE40[0x9c,0x114), with CODE45+42a setup, CODE39/43 table and conflict
 * construction. Input board and values already use endgame point units.
 * Outputs own top-ten and count; final global ranking/masks describe opponent.
 * Legal nonempty board/racks required. No exchanges and no pass candidate here.
 * All record scoring, per-mask runner-up handling and placement deduplication
 * are recovered; caller owns tree expansion and optional pruning callbacks. */
/* CODE45+42a shared preparation, retaining depth tables and reply cache. */
void maven_prepare_endgame_rack(MavenEndgameGeneration *state, const uint8_t *rack);
unsigned maven_prepare_endgame_candidates(MavenEndgameGeneration *state, const uint8_t *own,
                                          const uint8_t *other, uint8_t own_moves[10][34]);
unsigned maven_prepare_endgame_candidates_shared(MavenEndgameGeneration *,const uint8_t *own,
    const uint8_t *other,uint8_t output[10][34],uint8_t workspace[64]);
#endif
