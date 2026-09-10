#ifndef MAVEN_DICTIONARY_TABLES_H
#define MAVEN_DICTIONARY_TABLES_H
#include <stdint.h>
typedef struct {
    uint32_t roots[2];
    uint8_t *tables[2];
} MavenDictionaryTables;
typedef void (*MavenDictionaryDiagnostic)(void *);
/* Valid original-format allocation required. Deliberately not an untrusted
 * file parser. Diagnostic callbacks may return, as the original call can. */
void maven_install_dictionary(uint8_t *data, MavenDictionaryTables *state,
                              MavenDictionaryDiagnostic diagnostic, void *user);
#endif
