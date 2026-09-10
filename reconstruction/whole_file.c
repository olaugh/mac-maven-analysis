#include "whole_file.h"
#include <stddef.h>

/* CODE 47 [0x25c,0x2ee). Ownership/error order follows the original,
 * including paths that return without closing an opened file. A port can
 * fix those deliberately, but this reconstruction must expose the difference.
 * The read callback may change length, as FSRead changes ioReqCount.
 * Guest memory faults for pathological sizes are outside this host interface. */
uint8_t *maven_read_whole_file(const uint8_t *name, int16_t volume, uint32_t *length,
                               const MavenWholeFileOps *ops) {
    int16_t ref;
    uint8_t *buffer;
    if (ops->open(ops->user, name, volume, &ref))
        return NULL;
    if (ops->get_eof(ops->user, ref, length))
        return NULL;
    buffer = ops->new_ptr_clear(ops->user, *length + UINT32_C(1));
    if (!buffer)
        return NULL;
    if (ops->read(ops->user, ref, length, buffer) ||
        ops->ptr_size(ops->user, buffer) != *length + UINT32_C(1) || ops->close(ops->user, ref)) {
        ops->dispose(ops->user, buffer);
        return NULL;
    }
    buffer[*length] = 0;
    return buffer;
}
