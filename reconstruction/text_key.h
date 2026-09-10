#ifndef MAVEN_TEXT_KEY_H
#define MAVEN_TEXT_KEY_H
#include <stdint.h>
typedef struct {
    void *user;
    int16_t (*navigation)(void *, uint8_t, const void *);
    void (*delete_selection)(void *);
    void (*insert)(void *, const uint8_t *, uint32_t);
    uint8_t (*convert_quote)(void *, uint8_t);
    void (*key)(void *, int16_t);
} MavenTextKeyOps;
/* CODE 9+0x46c; modifiers is the original big-endian event word. */
int16_t maven_text_key(const MavenTextKeyOps *ops, uint8_t character, uint16_t modifiers,
                       int16_t suppress, const void *event, const uint8_t tab_bytes[4]);
#endif
