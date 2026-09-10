#include "move_statistics.h"
static int64_t signed_long(uint32_t x) {
    return x < UINT32_C(0x80000000) ? x : (int64_t)x - INT64_C(0x100000000);
}
static uint32_t divide(uint32_t a, uint32_t b) {
    return (uint32_t)(signed_long(a) / signed_long(b));
}
void maven_add_move_statistics(const uint32_t source[22], uint32_t destination[22]) {
    unsigned i;
    for (i = 0; i < 22; ++i)
        destination[i] += source[i];
}
void maven_normalize_move_statistics(uint32_t destination[22], const uint32_t source[22],
                                     uint32_t scale_count) {
    static const unsigned score_fields[] = {1, 2, 3, 4, 5, 7, 8, 9, 10, 11, 12};
    uint32_t divisor = scale_count * 100, half = divide(divisor, 2);
    unsigned i;
    for (i = 0; i < 22; ++i)
        destination[i] = source[i];
    for (i = 0; i < sizeof score_fields / sizeof *score_fields; ++i)
        destination[score_fields[i]] += half;
    destination[14] += divide(destination[0], 2);
    for (i = 0; i < sizeof score_fields / sizeof *score_fields; ++i)
        destination[score_fields[i]] = divide(destination[score_fields[i]], divisor);
    destination[14] = divide(destination[14], destination[0]);
}
