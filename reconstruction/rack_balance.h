#ifndef MAVEN_RACK_BALANCE_H
#define MAVEN_RACK_BALANCE_H
#include <stdint.h>
typedef struct {
    uint32_t entries[64]; /* index consonants*8+vowels; zero means uncached */
    int32_t pool_vowels, pool_consonants;
    void *user;
    uint32_t (*evaluate_composition)(void *, int16_t vowels, int16_t consonants,
                                     int16_t pool_vowels, int16_t pool_consonants,
                                     int16_t total_tiles);
    void (*diagnostic)(void *);
} MavenRackBalanceCache;
/* CODE32 [0xc00,0xcc4): subtract the empty-rack baseline and memoize.
 * Valid held vowel/consonant indices0..7 required. Cache key omits draws,
 * matching original behavior. Underlying CODE32+0xdb0 remains external. */
uint32_t maven_rack_balance_cached(MavenRackBalanceCache *cache, int16_t vowels, int16_t consonants,
                                   int16_t pool_vowels, int16_t pool_consonants, int16_t draws);
/* CODE32 [0xcc4,0xdb0): two blanks choose max of3 assignments; one blank
 * averages2 assignments with wrapped sum and signed division by2. Other
 * blank counts take the no-blank path, exactly as in the original. */
uint32_t maven_rack_balance_with_blanks(MavenRackBalanceCache *cache, int16_t vowels,
                                        int16_t consonants, int16_t blanks, int16_t pool_vowels,
                                        int16_t pool_consonants, int16_t draws);
#endif
