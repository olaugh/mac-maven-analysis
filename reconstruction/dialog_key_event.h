#ifndef MAVEN_DIALOG_KEY_EVENT_H
#define MAVEN_DIALOG_KEY_EVENT_H
#include <stddef.h>
#include <stdint.h>
typedef struct {
    int16_t type;
    uintptr_t handle;
} MavenDialogItem;
typedef struct {
    void *user;
    int16_t (*default_item)(void *user);
    int16_t (*active_edit_index)(void *user);
    /* Raw signed word at the item-list handle, not an inferred item count. */
    int16_t (*item_list_header)(void *user);
    void (*get_item)(void *user, int16_t item, MavenDialogItem *result);
    void (*activate_control)(void *user, uintptr_t handle, int16_t highlight);
    void (*debugger)(void *user);
    void (*focus_item)(void *user, int16_t item);
    void (*select_all)(void *user);
    void (*text_key)(void *user, const void *event, int16_t flag);
} MavenDialogKeyOps;
/* character is the low byte of EventRecord.message (event+5). Toolbox
 * structures stay external. Tab traversal has no invented iteration limit. */
void maven_dialog_key_event(const MavenDialogKeyOps *ops, uint8_t character, const void *event);
#endif
