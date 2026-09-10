/* CODE 12+0x082e..0x0894. The parser's return values are discarded. */
#include "word_length_controls.h"
#include "decimal_scan.h"

void maven_read_word_length_controls(const MavenLengthControlOps *ops, int16_t *minimum,
                                     int16_t *maximum) {
    uint8_t text[256];
    ops->read_field(ops->user, 11, text);
    *minimum = 0;
    (void)maven_scan_decimal_word(text, minimum, ops->error_number, ops->character_classes);
    ops->read_field(ops->user, 13, text);
    *maximum = 15;
    (void)maven_scan_decimal_word(text, maximum, ops->error_number, ops->character_classes);
    if (*maximum < *minimum)
        *maximum = 15;
}
