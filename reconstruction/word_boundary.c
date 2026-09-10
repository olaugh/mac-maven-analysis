#include "word_boundary.h"

uint8_t maven_is_word_separator(int16_t index, int32_t allocation_size, uint8_t previous,
                                uint8_t current, uint8_t next, const uint8_t classes[256]) {
    if ((int32_t)index == allocation_size)
        return 0;
    if (classes[current] & 0xd0)
        return 0;
    switch (current) {
    case 0xca:
    case '$':
    case 0xa2:
    case 0xa3:
    case 0xb4:
    case '%':
    case '-':
        return 0;
    case ',':
        return !(index > 0 && (classes[previous] & 16) && (classes[next] & 16));
    case '.':
        return !(classes[next] & 16);
    case '\'':
    case 0xd5:
        return !(index > 0 && (classes[previous] & 0xd0) && (classes[next] & 0xd0));
    default:
        return 1;
    }
}
