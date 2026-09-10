#include "save_record.h"
void maven_write_save_record(int8_t tag, uintptr_t handle, int16_t file,
                             const MavenSaveRecordOps *ops) {
    uint16_t tag_bits = (uint16_t)(int16_t)tag, size_bits;
    uint8_t tag_word[2] = {(uint8_t)(tag_bits >> 8), (uint8_t)tag_bits};
    uint8_t size_word[2], saved[2] = {0, 0}, *payload;
    int32_t count = 2;
    (void)ops->write(ops->user, file, &count, tag_word);
    size_bits = (uint16_t)ops->handle_size(ops->user, handle);
    size_word[0] = (uint8_t)(size_bits >> 8);
    size_word[1] = (uint8_t)size_bits;
    count = 2;
    (void)ops->write(ops->user, file, &count, size_word);
    payload = ops->lock(ops->user, handle);
    if (tag == 1) {
        saved[0] = payload[4];
        saved[1] = payload[5];
        payload[4] = payload[5] = 0;
    }
    count = size_bits < 32768 ? size_bits : (int32_t)size_bits - 65536;
    (void)ops->write(ops->user, file, &count, payload);
    ops->unlock(ops->user, handle);
    if (tag == 1) {
        payload[4] = saved[0];
        payload[5] = saved[1];
    }
}
