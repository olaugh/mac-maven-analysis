#ifndef MAVEN_LETTER_EXPECTATION_H
#define MAVEN_LETTER_EXPECTATION_H
#include <stdint.h>
/* CODE32 [0x140a,0x164c), mathematical port of its binomial expectation.
 * total<7 returns0 before table use. Otherwise require7<=total<=100 and
 * 0<=letter_count<=total. scores[0..7] are original BE-decoded long bits
 * for the selected letter (? index0, a..z indices1..26), at record+24.
 * This replaces the original allocated101x8 extended-precision Pascal
 * triangle with exact integer combinations, preserving wrapped score
 * differences and final truncation toward0. Alternate SANE precision modes,
 * exception flags, allocation side effects and invalid inputs are excluded. */
uint32_t maven_letter_expectation(int16_t total, int16_t letter_count, const uint32_t scores[8]);
#endif
