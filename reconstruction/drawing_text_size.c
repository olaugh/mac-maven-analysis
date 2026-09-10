#include "drawing_text_size.h"

void maven_set_drawing_text_size(int16_t source_size, int16_t incoming_d7, void *user,
                                 void (*debugger)(void *), void (*text_size)(void *, int16_t)) {
    int16_t size = incoming_d7;
    switch (source_size) {
    case 12:
        size = 10;
        break;
    case 14:
        size = 12;
        break;
    case 15:
        size = 13;
        break;
    case 18:
    case 20:
        size = 14;
        break;
    case 26:
    case 28:
        size = 24;
        break;
    default:
        debugger(user);
        break;
    }
    text_size(user, size);
}
