#include "file_access_check.h"

/* CODE 15 [0x0d4c,0x0df4). Original startup success-path trace is recorded in
 * analysis/toolchain/file-check-live.json. No seek is inserted, and early
 * failures deliberately do not add close calls absent from the original.
 * This native source preserves semantics through adapters, not the guest ABI.
 */
int16_t maven_check_file_access(const uint8_t *name, int16_t volume,
                                const MavenFileOperations *operations) {
    int32_t original_length;
    int32_t count = 1;
    int16_t file, error;
    uint8_t buffer[32];

    if (operations->open(name, volume, &file) != 0)
        return 1;
    if (operations->get_eof(file, &original_length) != 0)
        return 1;
    error = operations->read(file, &count, buffer);
    if (error != 0 && error != -39) /* eofErr */
        return 1;
    if (operations->write(file, &count, buffer) != 0)
        return 1;
    if (operations->set_eof(file, original_length) != 0)
        return 1;
    if (operations->close(file) != 0)
        return 1;
    return 0;
}
