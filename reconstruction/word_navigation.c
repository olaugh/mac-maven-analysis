#include "word_navigation.h"

static int16_t add_word(int16_t a, int16_t b) {
    uint16_t bits = (uint16_t)((uint16_t)a + (uint16_t)b);
    return bits < 32768 ? (int16_t)bits : (int16_t)((int32_t)bits - 65536);
}

int16_t maven_find_word_edge(const MavenWordNavigationOps *ops, int16_t position,
                             int16_t direction) {
    ops->lock_text(ops->user);
    position = add_word(position, direction);
    while (position > 0 && position < ops->text_length(ops->user)) {
        if (!ops->is_separator(ops->user, position) &&
            ops->is_separator(ops->user, add_word(position, direction)))
            break;
        position = add_word(position, direction);
    }
    ops->unlock_text(ops->user);
    return position < 0 ? 0 : position;
}
