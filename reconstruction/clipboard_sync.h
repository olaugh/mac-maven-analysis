#ifndef MAVEN_CLIPBOARD_SYNC_H
#define MAVEN_CLIPBOARD_SYNC_H
#include <stdint.h>
typedef struct {
    int16_t cached_count; /* A5-0xd8c */
    int16_t dirty;        /* A5-0xd8a */
} MavenClipboardState;
typedef struct {
    void *user;
    int16_t (*scrap_count)(void *);
    int16_t (*import_text)(void *);
    int32_t (*zero_scrap)(void *);
    int16_t (*export_text)(void *);
} MavenClipboardOps;
void maven_import_changed_clipboard(MavenClipboardState *, const MavenClipboardOps *);
void maven_export_dirty_clipboard(MavenClipboardState *, const MavenClipboardOps *);
#endif
