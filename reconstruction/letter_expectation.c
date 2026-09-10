#include "letter_expectation.h"
static uint64_t choose(unsigned n, unsigned k) {
    uint64_t value = 1;
    unsigned i;
    if (k > n)
        return 0;
    for (i = 1; i <= k; ++i)
        value = value * (n - i + 1) / i;
    return value;
}
static int32_t signed_long(uint32_t v) {
    return v <= INT32_MAX ? (int32_t)v : -1 - (int32_t)(UINT32_MAX - v);
}
uint32_t maven_letter_expectation(int16_t total, int16_t letter_count, const uint32_t scores[8]) {
    unsigned draws, i;
    uint64_t denominator = 0;
    int64_t numerator = 0;
    if (total < 7)
        return 0;
    draws = (unsigned)(total - 7);
    if (draws > 6)
        draws = 6;
    for (i = 0; i <= draws && i <= (unsigned)letter_count; ++i) {
        uint64_t weight =
            choose((unsigned)letter_count, i) * choose((unsigned)(total - letter_count), draws - i);
        int32_t delta = signed_long(scores[i + 1] - scores[0]);
        denominator += weight;
        numerator += (int64_t)weight * delta;
    }
    return (uint32_t)(numerator / (int64_t)denominator);
}
