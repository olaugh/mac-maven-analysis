#ifndef MAVEN_PREMIUM_EXPOSURE_H
#define MAVEN_PREMIUM_EXPOSURE_H
#include <stdint.h>
typedef struct {
    const uint8_t *board, *word_multipliers, *letter_multipliers, *letter_class;
    const uint8_t *penalties; /*20 records: letter,direction,premium,penalty */
    void (*diagnostic)(void *);
    void *user;
} MavenPremiumExposureInput;
/* CODE35 [0x3d8,0x6a6): adjacent empty premium-square penalties before
 * applying a move. Returns wrapped32 bits; caller emits record20000 only
 * when nonzero. Valid represented-letter move, row1..30,column1..15 through
 * its entire string (or row0 skip), original32x17 board/premium arrays. */
uint32_t maven_adjacent_premium_penalty(const uint8_t *move, const MavenPremiumExposureInput *in);
#endif
