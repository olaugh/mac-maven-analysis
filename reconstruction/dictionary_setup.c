#include "dictionary_setup.h"
/* CODE 2 [0xf4,0x138), joined to the installation above. The allocation
 * remains alive through the table pointers. No redundant copied tables. */
void maven_load_dictionary(const uint8_t *name, MavenDictionaryTables *state,
                           const MavenWholeFileOps *file_ops, MavenErrorContext *errors,
                           const void *load_error, MavenDictionaryDiagnostic diagnostic,
                           void *user) {
    uint32_t byte_count;
    uint8_t *data = maven_read_whole_file(name, 0, &byte_count, file_ops);
    if (!data)
        maven_raise_error(errors, load_error);
    maven_install_dictionary(data, state, diagnostic, user);
}
