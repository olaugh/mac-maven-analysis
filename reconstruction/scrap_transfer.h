#ifndef MAVEN_SCRAP_TRANSFER_H
#define MAVEN_SCRAP_TRANSFER_H
#include <stdint.h>
typedef struct {
    uint16_t length;  /* low memory 0xab0 */
    uintptr_t handle; /* low memory 0xab4 */
} MavenTextScrap;
typedef struct {
    void *user;
    /* GetScrap TEXT; handle 0 queries size. The unused offset is external. */
    int32_t (*get_text)(void *, uintptr_t handle);
    const uint8_t *(*lock)(void *, uintptr_t handle);
    int32_t (*put_text)(void *, uint32_t length, const uint8_t *);
    void (*unlock)(void *, uintptr_t handle);
} MavenScrapTransferOps;
int16_t maven_import_text_scrap(MavenTextScrap *, const MavenScrapTransferOps *);
int16_t maven_export_text_scrap(MavenTextScrap *, const MavenScrapTransferOps *);
#endif
