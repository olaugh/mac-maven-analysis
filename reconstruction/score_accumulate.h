#ifndef MAVEN_SCORE_ACCUMULATE_H
#define MAVEN_SCORE_ACCUMULATE_H
#include <stdint.h>
typedef struct {
    const uint8_t *board;              /* 544 bytes */
    const uint16_t *values;            /* 544 words */
    const uint16_t *letter_values;     /* 128 words */
    const uint8_t *word_multipliers;   /* 544 bytes */
    const uint8_t *letter_multipliers; /* 544 bytes */
    const uint8_t *letter_class;       /* 128 bytes; bit7 must mark word characters */
    const uint8_t *alphabet;
    void (*diagnostic)(void *);
    void *user;
} MavenScoreInput;
typedef struct {
    uint32_t score_bits;
    uint32_t word_multiplier;
    int16_t remaining_counts[128];
    int16_t new_tiles;
    int16_t remaining_blanks;
    int16_t initial_blanks;
    uint8_t missing_letters[2];
    int16_t zero_value_row[2];
    int16_t zero_value_column[2];
} MavenScoreScan;
/* CODE32 [0x32,0x352), plus the preceding zero-initialized globals.
 * Nonzero row, valid coordinates/ASCII alphabet and at most two missing
 * letters required. Computes the score BEFORE blank-value optimization.
 * It does not modify board values or supply the final CODE32 return value. */
MavenScoreScan maven_accumulate_move_score(const uint8_t *move, const uint8_t *rack,
                                           const MavenScoreInput *input);
/* Same arithmetic with caller-supplied original bingo global. CODE30 scales
 * this value from5000 to50 during exact-endgame search. */
MavenScoreScan maven_accumulate_move_score_with_bonus(const uint8_t *move, const uint8_t *rack,
                                                      const MavenScoreInput *input, uint32_t bonus);
/* Generator row-control form: suppress main-word multipliers while retaining
 * cross-word multipliers. This is CODE37's row-table behavior, not CODE32's
 * ordinary score entry point. */
MavenScoreScan maven_accumulate_move_score_with_main_control(const uint8_t *move,
                                                             const uint8_t *rack,
                                                             const MavenScoreInput *input,
                                                             uint32_t bonus,
                                                             int suppress_main_multiplier);
/* CODE37 pool traversal scores up to15 new tiles; its CODE36 callback
 * subsequently rejects moves using more than7. */
MavenScoreScan maven_accumulate_pool_move_score(const uint8_t *, const uint8_t *,
                                                const MavenScoreInput *, uint32_t bonus,
                                                int suppress_main_multiplier);
#endif
