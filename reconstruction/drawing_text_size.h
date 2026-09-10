#ifndef MAVEN_DRAWING_TEXT_SIZE_H
#define MAVEN_DRAWING_TEXT_SIZE_H
#include <stdint.h>
/* CODE 20+0x7ee..0x82e. source_size is the word at global pointer
 * (A5-0x2180)+10; its owning structure is not yet identified. */
void maven_set_drawing_text_size(int16_t source_size, int16_t incoming_d7, void *user,
                                 void (*debugger)(void *), void (*text_size)(void *, int16_t));
#endif
