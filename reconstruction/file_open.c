#include "file_open.h"
/* CODE 47 [0x12c,0x16c). Failed truncation does not close the open file. */
int16_t maven_open_file(const uint8_t *name, int16_t volume, int16_t *reference, int16_t truncate,
                        const MavenFileOpenOps *ops) {
    int16_t error = ops->open(ops->user, name, volume, reference);
    if (error)
        return error;
    if (truncate)
        return ops->set_eof(ops->user, *reference, 0);
    return 0;
}

/* CODE 47 [0x16c,0x1da). Any initial error triggers create, including
 * truncation failure; no special test for file-not-found. GetFInfo's error
 * result is ignored. Create's result replaces the initial error. */
int16_t maven_open_or_create_file(const uint8_t *name, int16_t volume, int16_t *reference,
                                  int16_t truncate, uint32_t type,
                                  const uint8_t *current_application_name, uint8_t scratch_info[16],
                                  const MavenFileOpenOps *ops) {
    uint32_t creator;
    int16_t error = maven_open_file(name, volume, reference, truncate, ops);
    if (!error)
        return 0;
    (void)ops->get_finder_info(ops->user, current_application_name, 0, scratch_info);
    creator = (uint32_t)scratch_info[4] << 24 | (uint32_t)scratch_info[5] << 16 |
              (uint32_t)scratch_info[6] << 8 | scratch_info[7];
    error = ops->create(ops->user, name, volume, creator, type);
    if (error)
        return error;
    return maven_open_file(name, volume, reference, truncate, ops);
}
