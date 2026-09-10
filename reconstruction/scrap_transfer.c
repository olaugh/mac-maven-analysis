#include "scrap_transfer.h"
static int16_t low_word(int32_t value) {
    uint16_t bits = (uint16_t)value;
    return bits < 32768 ? (int16_t)bits : (int16_t)((int32_t)bits - 65536);
}
/* CODE 34+0x4ce..0x524. The second read is not rechecked against 32000. */
int16_t maven_import_text_scrap(MavenTextScrap *state, const MavenScrapTransferOps *ops) {
    int32_t result = ops->get_text(ops->user, 0);
    if (result >= 0) {
        if (result >= 32001)
            result = -501;
        else
            result = ops->get_text(ops->user, state->handle);
    }
    if (result < 0) {
        state->length = 0;
        return low_word(result);
    }
    state->length = (uint16_t)result;
    return 0;
}
/* CODE 34+0x524..0x54a. Length is zero-extended by the original stack setup. */
int16_t maven_export_text_scrap(MavenTextScrap *state, const MavenScrapTransferOps *ops) {
    const uint8_t *text = ops->lock(ops->user, state->handle);
    int32_t result = ops->put_text(ops->user, state->length, text);
    ops->unlock(ops->user, state->handle);
    return low_word(result);
}
