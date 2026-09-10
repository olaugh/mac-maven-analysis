#include "volume_lookup.h"
#include "pascal_string.h"

/* CODE 47 [0xd0,0x12c). Keep the original imperfect comparison and
 * 16-bit enumeration wrap. No new exhaustion limit or normalization.
 * A successful Toolbox call must fill a valid Pascal name buffer. */
int16_t maven_find_volume(const uint8_t *wanted, uint32_t scratch_name_address,
                          int16_t *volume_reference, const MavenVolumeLookupOps *ops) {
    uint8_t block[80] = {0}, name[256];
    int16_t error;
    uint16_t index, reference;
    block[18] = (uint8_t)(scratch_name_address >> 24);
    block[19] = (uint8_t)(scratch_name_address >> 16);
    block[20] = (uint8_t)(scratch_name_address >> 8);
    block[21] = (uint8_t)scratch_name_address;
    block[29] = 1;
    for (;;) {
        error = ops->get_volume_info(ops->user, block, name, 0);
        if (error)
            return error;
        if (!maven_pascal_mismatch(name, wanted)) {
            reference = (uint16_t)((uint16_t)block[22] << 8 | block[23]);
            *volume_reference =
                reference < 32768 ? (int16_t)reference : (int16_t)((int32_t)reference - 65536);
            return 0;
        }
        index = (uint16_t)(((uint16_t)block[28] << 8 | block[29]) + 1);
        block[28] = (uint8_t)(index >> 8);
        block[29] = (uint8_t)index;
    }
}
