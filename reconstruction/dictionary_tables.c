#include "dictionary_tables.h"
static uint32_t big_long(const uint8_t *p) {
    return (uint32_t)p[0] << 24 | (uint32_t)p[1] << 16 | (uint32_t)p[2] << 8 | p[3];
}

/* CODE 2 [0x138,0x18a). Offsets include the CODE resource header.
 * The second table begins 104 bytes after the first root's record address.
 * Preserve global assignment order and re-read globals after diagnostics. */
void maven_install_dictionary(uint8_t *data, MavenDictionaryTables *state,
                              MavenDictionaryDiagnostic diagnostic, void *user) {
    state->roots[0] = big_long(data + 4);
    state->roots[1] = big_long(data + 8);
    state->tables[0] = data + 12;
    state->tables[1] = data + (UINT32_C(116) + (state->roots[0] << 2));
    if (state->tables[0][(state->roots[0] << 2) + UINT32_C(3)] != 'a')
        diagnostic(user);
    if (state->tables[1][(state->roots[1] << 2) + UINT32_C(3)] != 'a')
        diagnostic(user);
}
