#ifndef MAVEN_FILE_METADATA_H
#define MAVEN_FILE_METADATA_H
#include <stdint.h>

/* An original 32-bit guest name address, not a host pointer. The adapter
 * resolves it in guest memory or a port's object table. The parameter block
 * uses original big-endian bytes and two-byte Macintosh alignment. */
typedef struct {
    void *user;
    int16_t (*get_hfile_info)(void *user, uint8_t parameter_block[122], uint8_t asynchronous);
} MavenFileMetadataOps;

int16_t maven_file_modification_time(uint32_t name_address, uint32_t *timestamp,
                                     const MavenFileMetadataOps *ops);
int16_t maven_file_physical_size(uint32_t name_address, uint32_t *size,
                                 const MavenFileMetadataOps *ops);
#endif
