#include "file_metadata.h"

static uint32_t read_long(const uint8_t *p) {
    return (uint32_t)p[0] << 24 | (uint32_t)p[1] << 16 | (uint32_t)p[2] << 8 | p[3];
}

static void set_name(uint8_t *block, uint32_t address) {
    block[18] = (uint8_t)(address >> 24);
    block[19] = (uint8_t)(address >> 16);
    block[20] = (uint8_t)(address >> 8);
    block[21] = (uint8_t)address;
}

/* CODE 47 [0x5a,0x92). The output is assigned even on Toolbox error.
 * Timestamp is the original 32-bit Mac value; no timezone/epoch conversion.
 * Static reconstruction. Natural debugger capture still pending. */
int16_t maven_file_modification_time(uint32_t name_address, uint32_t *timestamp,
                                     const MavenFileMetadataOps *ops) {
    uint8_t block[122] = {0};
    int16_t error;
    set_name(block, name_address);
    error = ops->get_hfile_info(ops->user, block, 0);
    *timestamp = read_long(block + 76);
    return error;
}

/* CODE 47 [0x92,0xd0). Physical fork sizes, not logical file lengths.
 * Unsigned addition preserves the original ADD.L wraparound. */
int16_t maven_file_physical_size(uint32_t name_address, uint32_t *size,
                                 const MavenFileMetadataOps *ops) {
    uint8_t block[122] = {0};
    int16_t error;
    set_name(block, name_address);
    error = ops->get_hfile_info(ops->user, block, 0);
    *size = read_long(block + 68) + read_long(block + 58);
    return error;
}
