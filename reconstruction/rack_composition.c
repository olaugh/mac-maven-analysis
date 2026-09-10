#include "rack_composition.h"
static int64_t signed_long(uint32_t x) {
    return x < UINT32_C(0x80000000) ? x : (int64_t)x - INT64_C(0x100000000);
}
uint32_t maven_rack_composition(int16_t held_vowels, int16_t held_consonants, int16_t pool_vowels,
                                int16_t pool_consonants, int16_t total,
                                const uint32_t *terminal_scores) {
    uint32_t grid[8][8];
    int level, consonants;
    for (consonants = 0; consonants <= total; ++consonants)
        grid[consonants][total - consonants] = terminal_scores[consonants];
    for (level = total - 1; level >= held_vowels + held_consonants; --level) {
        for (consonants = held_consonants; consonants <= level - held_vowels; ++consonants) {
            int available_c = pool_consonants - consonants + held_consonants;
            int available_v = consonants + pool_vowels - level + held_vowels;
            unsigned vowels = (unsigned)(level - consonants);
            uint32_t numerator;
            if (available_c < 0)
                available_c = 0;
            if (available_v < 0)
                available_v = 0;
            if (!available_c && !available_v)
                available_c = available_v = 1;
            numerator = grid[consonants + 1][vowels] * (uint32_t)available_c +
                        grid[consonants][vowels + 1] * (uint32_t)available_v;
            grid[consonants][vowels] =
                (uint32_t)(signed_long(numerator) / (available_c + available_v));
        }
    }
    return grid[held_consonants][held_vowels];
}
