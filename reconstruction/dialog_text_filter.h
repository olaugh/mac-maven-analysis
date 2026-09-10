#ifndef MAVEN_DIALOG_TEXT_FILTER_H
#define MAVEN_DIALOG_TEXT_FILTER_H
#include <stdint.h>
typedef struct {
    void *user;
    void (*read_field)(void *user, int16_t item, uint8_t text[256]);
    void (*beep)(void *user, int16_t duration);
    /* Includes the original writer's TextEdit refresh, not just text storage. */
    void (*rewrite_field)(void *user, int16_t item, const uint8_t *text);
} MavenDialogFilterOps;
/* ASCII contract inherited from text_filter.h; reader must terminate text. */
void maven_filter_dialog_field(const MavenDialogFilterOps *ops, int16_t item,
                               const uint8_t *allowed);
/* CODE 12+0x686: dispatch first, then sanitize each field in original order.
 * Event and dialog implementation remain owned by the adapter. */
void maven_word_list_text_event(const MavenDialogFilterOps *ops,
                                void (*dispatch_event)(void *user, const void *event),
                                const void *event, const uint8_t *letter_characters,
                                const uint8_t *length_characters);
#endif
