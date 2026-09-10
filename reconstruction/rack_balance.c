#include "rack_balance.h"
#include <string.h>
static int16_t word(uint16_t x) {
    return x < 32768 ? (int16_t)x : (int16_t)((int32_t)x - 65536);
}
static int64_t signed_long(uint32_t x) {
    return x < UINT32_C(0x80000000) ? x : (int64_t)x - INT64_C(0x100000000);
}
static int16_t plus(int16_t x, int16_t y) {
    return word((uint16_t)((uint16_t)x + (uint16_t)y));
}
uint32_t maven_rack_balance_cached(MavenRackBalanceCache *s, int16_t vowels, int16_t consonants,
                                   int16_t pool_vowels, int16_t pool_consonants, int16_t draws) {
    unsigned index;
    int16_t total;
    if (draws < 0)
        s->diagnostic(s->user);
    if (plus(plus(plus(vowels, consonants), draws), -7) > 0)
        draws = word((uint16_t)(7 - vowels - consonants));
    if (!vowels && !consonants)
        return 0;
    if (s->pool_vowels != pool_vowels || s->pool_consonants != pool_consonants) {
        memset(s->entries, 0, 256);
        s->pool_vowels = pool_vowels;
        s->pool_consonants = pool_consonants;
    }
    index = (unsigned)(consonants * 8 + vowels);
    if (!s->entries[index]) {
        uint32_t value;
        total = plus(plus(vowels, consonants), draws);
        value = s->evaluate_composition(s->user, vowels, consonants, pool_vowels, pool_consonants,
                                        total);
        s->entries[index] =
            value - s->evaluate_composition(s->user, 0, 0, pool_vowels, pool_consonants, total);
    }
    return s->entries[index];
}
uint32_t maven_rack_balance_with_blanks(MavenRackBalanceCache *s, int16_t vowels,
                                        int16_t consonants, int16_t blanks, int16_t pool_vowels,
                                        int16_t pool_consonants, int16_t draws) {
    uint32_t first, second, third;
    if (blanks == 2) {
        first = maven_rack_balance_cached(s, vowels, plus(consonants, 2), pool_vowels,
                                          pool_consonants, draws);
        second = maven_rack_balance_cached(s, plus(vowels, 1), plus(consonants, 1), pool_vowels,
                                           pool_consonants, draws);
        if (signed_long(second) > signed_long(first))
            first = second;
        third = maven_rack_balance_cached(s, plus(vowels, 2), consonants, pool_vowels,
                                          pool_consonants, draws);
        if (signed_long(third) > signed_long(first))
            first = third;
        return first;
    }
    if (blanks == 1) {
        first = maven_rack_balance_cached(s, vowels, plus(consonants, 1), pool_vowels,
                                          pool_consonants, draws);
        second = maven_rack_balance_cached(s, plus(vowels, 1), consonants, pool_vowels,
                                           pool_consonants, draws);
        return (uint32_t)(signed_long(first + second) / 2);
    }
    return maven_rack_balance_cached(s, vowels, consonants, pool_vowels, pool_consonants, draws);
}
