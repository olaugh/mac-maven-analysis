#ifndef MAVEN_VOLUME_LOOKUP_H
#define MAVEN_VOLUME_LOOKUP_H
#include <stdint.h>
typedef struct {
    void *user;
    /* Resolve the parameter block's name address to the supplied name buffer.
     * This synchronous adapter represents PBGetVInfo, not a host struct cast. */
    int16_t (*get_volume_info)(void *, uint8_t block[80], uint8_t name[256], uint8_t async);
} MavenVolumeLookupOps;
int16_t maven_find_volume(const uint8_t *wanted, uint32_t scratch_name_address,
                          int16_t *volume_reference, const MavenVolumeLookupOps *ops);
#endif
