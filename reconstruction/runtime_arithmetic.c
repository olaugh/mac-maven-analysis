/* Readable semantic reconstruction of CODE 1 resource offset 0x00ee.
 *
 * Original binary: resources/CODE/1_1.bin, 578 bytes.
 * Original routine spans [0x00ee, 0x0124). Offsets INCLUDE the 4-byte
 * segment header. See analysis/toolchain/STATUS.md for evidence and limits.
 *
 * Guest ABI: two 32-bit stack operands, result D0, preserve D1 and D2-D5,
 * callee removes 8 argument bytes. This portable C function expresses the
 * arithmetic only; its host compiler ABI does not reproduce that guest ABI.
 */
#include <stdint.h>

uint32_t maven_multiply_low32(uint32_t left, uint32_t right) {
    /* The 68000 routine combines three unsigned 16x16 multiplies and
     * discards carries above bit 31. uint32_t multiplication has exactly
     * that modulo-2^32 result, including signed operands' bit patterns. */
    return left * right;
}
