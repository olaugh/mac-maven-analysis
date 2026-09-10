/* Portable reconstruction of CODE 1 offsets 0x0048..0x00a8.
 * Mac resource/Handle API calls remain outside this pure data operation.
 * Operates on serialized big-endian guest bytes; host pointers are never
 * confused with 32-bit guest addresses. Error returns are host safeguards,
 * not inferred behaviors of the original unchecked startup routine.
 */
#include <stddef.h>
#include <stdint.h>

static uint16_t read_be16(const uint8_t *p) {
    return (uint16_t)((uint16_t)p[0] << 8 | p[1]);
}

static uint32_t read_be32(const uint8_t *p) {
    return (uint32_t)p[0] << 24 | (uint32_t)p[1] << 16 | (uint32_t)p[2] << 8 | p[3];
}

static void write_be32(uint8_t *p, uint32_t value) {
    p[0] = (uint8_t)(value >> 24);
    p[1] = (uint8_t)(value >> 16);
    p[2] = (uint8_t)(value >> 8);
    p[3] = (uint8_t)value;
}

int maven_initialize_globals(uint8_t *globals, size_t below_a5, const uint8_t *data,
                             size_t data_size, const uint8_t *zero, size_t zero_size,
                             const uint8_t *relocations, size_t relocation_size,
                             uint32_t a5_address) {
    size_t out = 0, in = 0, run = 0;
    while (out < below_a5) {
        uint16_t word;
        if (data_size - in < 2 || below_a5 - out < 2)
            return -1;
        word = read_be16(data + in);
        globals[out++] = data[in++];
        globals[out++] = data[in++];
        if (word == 0) {
            size_t count;
            if (zero_size - run < 2)
                return -1;
            count = read_be16(zero + run);
            run += 2;
            if (count > below_a5 - out)
                return -1;
            while (count--)
                globals[out++] = 0;
        }
    }
    if (relocation_size & 1)
        return -1;
    for (in = 0; in < relocation_size; in += 2) {
        uint16_t encoded = read_be16(relocations + in);
        int32_t displacement = encoded < 0x8000 ? encoded : (int32_t)encoded - 0x10000;
        int64_t offset = (int64_t)below_a5 + displacement;
        if (offset < 0 || (uint64_t)offset + 4 > below_a5)
            return -1;
        write_be32(globals + offset, read_be32(globals + offset) + a5_address);
    }
    return 0;
}
