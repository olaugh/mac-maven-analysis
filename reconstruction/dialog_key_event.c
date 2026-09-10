/* CODE 48+0x0376..0x0446. */
#include "dialog_key_event.h"

static int16_t add_word(int16_t value, unsigned increment) {
    uint16_t bits = (uint16_t)((uint16_t)value + increment);
    return bits < 32768 ? (int16_t)bits : (int16_t)((int32_t)bits - 65536);
}

void maven_dialog_key_event(const MavenDialogKeyOps *ops, uint8_t character, const void *event) {
    int16_t active;
    if (character == 3 || character == 13) {
        int16_t item = ops->default_item(ops->user);
        if (item) {
            MavenDialogItem result;
            ops->get_item(ops->user, item, &result);
            ops->activate_control(ops->user, result.handle, 10);
            return;
        }
    }
    if (character == 3)
        return;
    active = ops->active_edit_index(ops->user);
    if (active == -1)
        return;
    if (character == 9) {
        int16_t item = add_word(active, 2);
        for (;;) {
            MavenDialogItem result = {-1, 0};
            if (item > ops->item_list_header(ops->user))
                item = 1;
            ops->get_item(ops->user, item, &result);
            if (!result.handle)
                ops->debugger(ops->user);
            if (result.type & 16) {
                ops->focus_item(ops->user, item);
                ops->select_all(ops->user);
                return;
            }
            item = add_word(item, 1);
        }
    }
    ops->text_key(ops->user, event, 0);
}
