#ifndef MAVEN_WORD_LENGTH_CONTROLS_H
#define MAVEN_WORD_LENGTH_CONTROLS_H
#include <stdint.h>

/* Text extraction remains external. read_field provides a NUL-terminated
 * string within 256 bytes. Classes and errno belong to the application.
 */
typedef struct {
    void *user;
    void (*read_field)(void *user, int16_t item, uint8_t text[256]);
    const uint8_t *character_classes;
    int16_t *error_number;
} MavenLengthControlOps;

void maven_read_word_length_controls(const MavenLengthControlOps *ops, int16_t *minimum,
                                     int16_t *maximum);
#endif
