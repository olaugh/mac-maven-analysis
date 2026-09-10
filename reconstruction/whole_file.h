#ifndef MAVEN_WHOLE_FILE_H
#define MAVEN_WHOLE_FILE_H
#include <stdint.h>
typedef struct {
    void *user;
    int16_t (*open)(void *, const uint8_t *pascal_name, int16_t volume, int16_t *ref);
    int16_t (*get_eof)(void *, int16_t ref, uint32_t *length);
    uint8_t *(*new_ptr_clear)(void *, uint32_t length);
    int16_t (*read)(void *, int16_t ref, uint32_t *count, uint8_t *destination);
    uint32_t (*ptr_size)(void *, uint8_t *pointer);
    int16_t (*close)(void *, int16_t ref);
    void (*dispose)(void *, uint8_t *pointer);
} MavenWholeFileOps;
uint8_t *maven_read_whole_file(const uint8_t *name, int16_t volume, uint32_t *length,
                               const MavenWholeFileOps *ops);
#endif
