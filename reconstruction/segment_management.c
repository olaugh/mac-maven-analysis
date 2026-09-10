/* CODE 11 [0x0d4c,0x0da8), including the four-byte resource header.
 * Passes addresses of A5 jump-table stubs to Macintosh UnloadSeg, in order.
 * Semantic reconstruction: caller supplies the actual A5 world and a Pascal
 * Toolbox adapter. This function is not a binary-compatible ABI replacement.
 * All fifteen arguments/order matched a natural original-runtime capture;
 * see analysis/toolchain/segment-unloads-live.json. Toolbox effects are external.
 */
#include <stdint.h>

void maven_unload_startup_segments(uint8_t *a5_world,
                                   void (*unload_segment)(void *routine_address)) {
    static const uint16_t routine_offsets[] = {0x0ac2, 0x0a92, 0x0aa2, 0x0822, 0x0862,
                                               0x08b2, 0x0aea, 0x0a7a, 0x0a1a, 0x0d72,
                                               0x0a3a, 0x0a52, 0x0912, 0x0842, 0x098a};
    unsigned i;
    for (i = 0; i < sizeof routine_offsets / sizeof routine_offsets[0]; ++i)
        unload_segment(a5_world + routine_offsets[i]);
}
