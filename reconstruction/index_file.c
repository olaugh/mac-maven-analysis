/* CODE 15 [0x0004,0x00d2), including the resource header in offsets.
 * Loads a file through CODE 47+0x025c and searches its final records for 'a'.
 * This is not the "search DAWG with pattern" function named in old notes.
 * The external loader and error globals are explicit integration parameters.
 * Static instruction reconstruction; live file-loading trace pending.
 */
#include "index_file.h"

const uint8_t *maven_load_index_and_find_a(const void *name, uint32_t *record_index,
                                           MavenReadWholeFile read_file, MavenErrorContext *errors,
                                           const void *load_error) {
    uint32_t byte_count, word_count, current;
    const uint8_t *data = read_file(name, 0, &byte_count);
    if (data == 0)
        maven_raise_error(errors, load_error);

    word_count = byte_count >> 2;
    *record_index = word_count - UINT32_C(2);
    /* Original TST.L/BHI checks nonzero, not signed positivity. In particular,
     * files shorter than eight bytes underflow; the original does not validate
     * those malformed sizes. This translation retains its valid-file contract.
     */
    if (*record_index == 0)
        maven_raise_error(errors, load_error);

    for (;;) {
        current = *record_index;
        if (data[current * UINT32_C(4) + UINT32_C(3)] == 'a')
            return data;
        /* Unsigned comparison occurs AFTER examining the candidate. For an
         * ordinary file of at least 27 records this examines exactly 26 final
         * candidate records, skipping the file's last record.
         */
        if (word_count - UINT32_C(26) > current)
            maven_raise_error(errors, load_error);
        --*record_index;
    }
}
