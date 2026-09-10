#ifndef MAVEN_FILE_ACCESS_CHECK_H
#define MAVEN_FILE_ACCESS_CHECK_H
#include <stdint.h>

/* Toolbox adapter boundary. Counts and lengths remain 32-bit on a 64-bit host.
 * The original calls Pascal Toolbox wrappers through the A5 jump table.
 */
typedef struct MavenFileOperations {
    int16_t (*open)(const uint8_t *pascal_name, int16_t volume, int16_t *file);
    int16_t (*get_eof)(int16_t file, int32_t *length);
    int16_t (*read)(int16_t file, int32_t *count, void *buffer);
    int16_t (*write)(int16_t file, int32_t *count, const void *buffer);
    int16_t (*set_eof)(int16_t file, int32_t length);
    int16_t (*close)(int16_t file);
} MavenFileOperations;

int16_t maven_check_file_access(const uint8_t *name, int16_t volume,
                                const MavenFileOperations *operations);
#endif
