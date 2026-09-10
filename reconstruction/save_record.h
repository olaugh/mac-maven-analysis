#ifndef MAVEN_SAVE_RECORD_H
#define MAVEN_SAVE_RECORD_H
#include <stdint.h>
typedef struct {
    void *user;
    int16_t (*write)(void *, int16_t file, int32_t *count, const uint8_t *data);
    int32_t (*handle_size)(void *, uintptr_t handle);
    uint8_t *(*lock)(void *, uintptr_t handle);
    void (*unlock)(void *, uintptr_t handle);
} MavenSaveRecordOps;
/* CODE 22 [0x200,0x28e). Valid allocated payload required; tag 1 requires
 * at least six bytes. The original restores through the unlocked pointer:
 * this interface requires it to remain valid through the restoration. */
void maven_write_save_record(int8_t tag, uintptr_t handle, int16_t file,
                             const MavenSaveRecordOps *ops);
#endif
