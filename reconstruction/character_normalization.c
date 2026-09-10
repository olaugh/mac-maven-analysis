#include "character_normalization.h"

int16_t maven_lowercase_character(int16_t character, const uint8_t classes[256]) {
    /* THINK's classification macro casts to unsigned char; EOF and other
     * negative values therefore still index by their low byte. */
    if (classes[(uint8_t)character] & 0x40)
        return (int16_t)(character ^ 0x20);
    return character;
}

uint8_t *maven_copy_lowercase(uint8_t *destination, const uint8_t *source,
                              const uint8_t classes[256]) {
    uint8_t *start = destination;
    while (*source) {
        /* MOVE.B followed by EXT.W sign-extends the source byte. */
        int16_t character = *source < 128 ? *source : (int16_t)*source - 256;
        *destination++ = (uint8_t)maven_lowercase_character(character, classes);
        ++source;
    }
    *destination = 0;
    return start;
}
