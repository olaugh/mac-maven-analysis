#include "text_key.h"

int16_t maven_text_key(const MavenTextKeyOps *ops, uint8_t character, uint16_t modifiers,
                       int16_t suppress, const void *event, const uint8_t tab_bytes[4]) {
    if (ops->navigation(ops->user, character, event))
        return 0;
    if ((modifiers & 0x0100) || suppress)
        return 0;
    if (character == 9) {
        ops->delete_selection(ops->user);
        ops->insert(ops->user, tab_bytes, 4);
    } else if (character == 27) {
        ops->delete_selection(ops->user);
    } else {
        uint8_t converted = ops->convert_quote(ops->user, character);
        int16_t signed_character = converted < 128 ? converted : (int16_t)converted - 256;
        ops->key(ops->user, signed_character);
    }
    return 1;
}
