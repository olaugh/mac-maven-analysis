#ifndef MAVEN_FILE_OPEN_H
#define MAVEN_FILE_OPEN_H
#include <stdint.h>
typedef struct {
    void *user;
    int16_t (*open)(void *, const uint8_t *, int16_t, int16_t *);
    int16_t (*set_eof)(void *, int16_t, uint32_t);
    int16_t (*get_finder_info)(void *, const uint8_t *, int16_t, uint8_t info[16]);
    int16_t (*create)(void *, const uint8_t *, int16_t, uint32_t creator, uint32_t type);
} MavenFileOpenOps;
int16_t maven_open_file(const uint8_t *name, int16_t volume, int16_t *reference, int16_t truncate,
                        const MavenFileOpenOps *ops);
/* current_application_name represents the Pascal name at low memory 0x910.
 * scratch_info preserves the original stack bytes if GetFInfo fails without
 * filling them. Supplying initialized bytes is a port policy, not original
 * behavior. This adapter avoids a host uninitialized C read. */
int16_t maven_open_or_create_file(const uint8_t *name, int16_t volume, int16_t *reference,
                                  int16_t truncate, uint32_t type,
                                  const uint8_t *current_application_name, uint8_t scratch_info[16],
                                  const MavenFileOpenOps *ops);
#endif
