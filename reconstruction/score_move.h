#ifndef MAVEN_SCORE_MOVE_H
#define MAVEN_SCORE_MOVE_H
#include "score_accumulate.h"
/* CODE32 [4,0x650), using the shared first-phase accumulator.
 * Valid ASCII rack/alphabet, playable coordinates, <=2 missing letters and
 * sufficient remaining-rack capacity required. Zero row returns zeroed
 * score/globals without touching remaining_rack. Diagnostics may return.
 * Coordinates identify cells to zero AFTER placement; board is read-only here. */
MavenScoreScan maven_score_move(const uint8_t *move, const uint8_t *rack, uint8_t *remaining_rack,
                                const MavenScoreInput *input);
MavenScoreScan maven_score_move_with_bonus(const uint8_t *move, const uint8_t *rack,
                                           uint8_t *remaining_rack, const MavenScoreInput *input,
                                           uint32_t bonus);
MavenScoreScan maven_score_move_with_main_control(const uint8_t *move, const uint8_t *rack,
                                                  uint8_t *remaining, const MavenScoreInput *input,
                                                  uint32_t bonus, int suppress_main_multiplier);
/* CODE37 larger-pool scoring; output rack requires17 bytes. */
MavenScoreScan maven_score_pool_move(const uint8_t *, const uint8_t *, uint8_t *,
                                     const MavenScoreInput *, uint32_t bonus,
                                     int suppress_main_multiplier);
#endif
