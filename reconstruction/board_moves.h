#ifndef MAVEN_BOARD_MOVES_H
#define MAVEN_BOARD_MOVES_H
#include "board_placements.h"
#include "score_move.h"

typedef struct {
    MavenBoardEnumeration enumeration;
    MavenScoreInput scoring;
    const uint8_t *sorted_rack;
    const uint16_t *leave_values;
    void (*move)(void *, const uint8_t move[34]);
    void *user;
} MavenBoardMoves;

/* Compose occupied-board CODE37 traversal with section deduplication, general
 * CODE32 scoring and move metadata. Original prepared leave table is input.
 * The callback receives every scored candidate in generator order. */
void maven_generate_board_moves(MavenBoardMoves *state);
/* Endgame form preserves the same state ABI while accepting the scaled
 * original bingo global. All other scores use supplied letter/board units. */
void maven_generate_board_moves_with_bonus(MavenBoardMoves *state, uint32_t bonus);
/* Optional scorer-state mirror is written before each candidate callback. */
void maven_generate_board_moves_with_score(MavenBoardMoves *state, uint32_t bonus,
                                           MavenScoreScan *last_score);
/* CODE37+84e reads the32-byte A5-0x6d2 row flags; a nonzero row forces
 * the main-word multiplier table to1. NULL uses ordinary board premiums. */
void maven_generate_board_moves_with_controls(MavenBoardMoves *state, uint32_t bonus,
                                              MavenScoreScan *last_score, const uint8_t *row_flags);
/* Local continuation generation retains the original full-rack occurrence
 * masks while enumerating a smaller remaining rack. NULL rebuilds from rack. */
void maven_generate_board_moves_prepared(MavenBoardMoves *state, uint32_t bonus,
                                         MavenScoreScan *last_score, const uint8_t *row_flags,
                                         const uint16_t occurrence_masks[128][8]);
/* CODE37 traversal of a7..16 tile unseen pool. It emits even candidates
 * using more than7 tiles; the caller must perform CODE36's rejection. Masks
 * >=128 preserve the prior scratch move's leave field instead of indexing
 * the seven-tile leave table. Occurrence rows must match the entire pool. */
void maven_generate_pool_board_moves(MavenBoardMoves *, uint32_t bonus, MavenScoreScan *,
                                     const uint8_t *row_flags, const uint16_t occurrences[128][8]);
/* Shared crossing output and aliased row flags, with per-row scoring control
 * frozen after cross preparation. pool selects the unseen-pool scoring form. */
void maven_generate_board_moves_shared(MavenBoardMoves *,uint32_t bonus,MavenScoreScan *,
    uint8_t workspace[64],const uint16_t occurrences[128][8],int pool);
#endif
