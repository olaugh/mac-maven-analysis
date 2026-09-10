#include "decimal_scan.h"

int16_t maven_scan_decimal_word(const uint8_t *text, int16_t *destination, int16_t *error_number,
                                const uint8_t character_classes[256]) {
    uint32_t result = 0;
    unsigned remaining = 32767;
    int negative = 0, valid = 0, overflow = 0;
    while (*text && (character_classes[*text] & 6))
        ++text;
    if (*text == '+' || *text == '-') {
        negative = *text == '-';
        ++text;
        --remaining;
    }
    while (remaining && *text >= '0' && *text <= '9') {
        unsigned digit = *text++ - '0';
        uint32_t high_product = (result >> 16) * 10;
        --remaining;
        valid = 1;
        /* Preserve the original two-MULU accumulation, including leaving
         * the accumulator unchanged when its upper product overflows. */
        if (high_product > 65535) {
            overflow = 1;
        } else {
            uint32_t low_product = (result & 65535) * 10;
            uint32_t addend = (high_product << 16) | digit;
            result = low_product + addend;
            if (result < low_product)
                overflow = 1;
        }
    }
    if (!valid)
        return *text ? 0 : -1;
    /* Equivalent to NEG.L, signed-range checks, and the final word-fit
     * check. The sticky overflow flag dominates the eventual assignment. */
    if (negative) {
        if (result > 32768)
            overflow = 1;
    } else if (result > 32767) {
        overflow = 1;
    }
    if (overflow) {
        *destination = negative ? -32768 : 32767;
        *error_number = 34;
    } else {
        *destination = negative ? (int16_t) - (int32_t)result : (int16_t)result;
    }
    return 1;
}
