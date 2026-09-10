#include "clipboard_sync.h"

/* CODE 9+0xc5e..0xc84. Import can change the system count: read it again. */
void maven_import_changed_clipboard(MavenClipboardState *state, const MavenClipboardOps *ops) {
    if (state->cached_count != ops->scrap_count(ops->user)) {
        (void)ops->import_text(ops->user);
        state->cached_count = ops->scrap_count(ops->user);
    }
}

/* CODE 9+0xc84..0xca2. Preserve the original assignment from ZeroScrap's
 * low return word, rather than substituting a new InfoScrap query. */
void maven_export_dirty_clipboard(MavenClipboardState *state, const MavenClipboardOps *ops) {
    if (state->dirty) {
        uint16_t bits = (uint16_t)ops->zero_scrap(ops->user);
        state->cached_count = bits < 32768 ? (int16_t)bits : (int16_t)((int32_t)bits - 65536);
        (void)ops->export_text(ops->user);
        state->dirty = 0;
    }
}
