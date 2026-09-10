/* CODE 48+0x0138..0x0182; dialog identity is carried by ops->user. */
#include "dialog_text_filter.h"
#include "text_filter.h"

void maven_filter_dialog_field(const MavenDialogFilterOps *ops, int16_t item,
                               const uint8_t *allowed) {
    uint8_t text[256];
    ops->read_field(ops->user, item, text);
    if (maven_filter_ascii(text, text, allowed)) {
        ops->beep(ops->user, 15);
        ops->rewrite_field(ops->user, item, text);
    }
}

void maven_word_list_text_event(const MavenDialogFilterOps *ops,
                                void (*dispatch_event)(void *user, const void *event),
                                const void *event, const uint8_t *letter_characters,
                                const uint8_t *length_characters) {
    int16_t item;
    dispatch_event(ops->user, event);
    for (item = 2; item <= 5; ++item)
        maven_filter_dialog_field(ops, item, letter_characters);
    maven_filter_dialog_field(ops, 11, length_characters);
    maven_filter_dialog_field(ops, 13, length_characters);
}
