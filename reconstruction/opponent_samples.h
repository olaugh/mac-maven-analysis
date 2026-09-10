#ifndef MAVEN_OPPONENT_SAMPLES_H
#define MAVEN_OPPONENT_SAMPLES_H
#include <stdint.h>
/* CODE38[0x46,0x17a): enumerate seven-tile opponent racks from unseen counts.
 * Valid inputs: original alphabet order, nonnegative counts, unseen total<18.
 * Each rack is sorted in alphabet order. Skipping a letter precedes including
 * it, so enumeration order differs from an ordinary lexical word iterator.
 * Weight is the product of C(available,selected), with original signed-word
 * table entries and wrapping32-bit multiplication. A nonzero callback word
 * stops enumeration. Fewer than seven available tiles produce no callbacks.
 * choose[n][k] is the original eight-word row at A5-0x65a8+16*n.
 * Counts are left unchanged; callback rack storage is temporary. */
typedef int16_t (*MavenOpponentSampleVisitor)(void *, const uint8_t *, uint32_t);
int16_t maven_enumerate_opponent_samples(const uint8_t counts[128], const uint8_t *alphabet,
                                         const uint16_t choose[][8],
                                         MavenOpponentSampleVisitor visit, void *user);
#endif
