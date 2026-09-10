#ifndef MAVEN_RACK_COMPOSITION_H
#define MAVEN_RACK_COMPOSITION_H
#include <stdint.h>
/* CODE32 [0xdb0,0xefa): integer backward recurrence over final composition.
 * Valid0<=held_vowels+held_consonants<=total<=7 and nonnegative held counts.
 * terminal_scores[c] is the BE32 value at original table+24+28*c, decoded
 * by the caller for this total. Pool counts are signed words and clamp at0.
 * Intermediate products/sums wrap32 bits before signed division. */
uint32_t maven_rack_composition(int16_t held_vowels, int16_t held_consonants, int16_t pool_vowels,
                                int16_t pool_consonants, int16_t total,
                                const uint32_t *terminal_scores);
#endif
