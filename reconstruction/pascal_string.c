/* CODE 34+0x0020..0x003a. DBRA is entered before the copy, so exactly
 * the unsigned length byte's number of bytes move, including for length 0. */
#include "pascal_string.h"
#include <string.h>

int16_t maven_pascal_mismatch(const uint8_t *left, const uint8_t *right) {
    int16_t index, length;
    if (left[0] != right[0])
        return 1;
    length = right[0] < 128 ? right[0] : (int16_t)((int)right[0] - 256);
    for (index = 1; index < length; ++index)
        if (left[index] != right[index])
            return 1;
    return 0;
}

uint8_t *maven_pascal_to_c(uint8_t *buffer) {
    unsigned length = buffer[0], i;
    for (i = 0; i < length; ++i)
        buffer[i] = buffer[i + 1];
    buffer[length] = 0;
    return buffer;
}

uint8_t *maven_c_to_pascal(uint8_t *destination, const uint8_t *source) {
    size_t length = strlen((const char *)source);
    memcpy(destination + 1, source, length + 1);
    destination[0] = (uint8_t)length;
    return destination;
}
