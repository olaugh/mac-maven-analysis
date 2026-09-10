#ifndef MAVEN_DICTIONARY_SETUP_H
#define MAVEN_DICTIONARY_SETUP_H
#include "dictionary_tables.h"
#include "error_context.h"
#include "whole_file.h"
#include <stdint.h>
void maven_load_dictionary(const uint8_t *name, MavenDictionaryTables *state,
                           const MavenWholeFileOps *file_ops, MavenErrorContext *errors,
                           const void *load_error, MavenDictionaryDiagnostic diagnostic,
                           void *user);
#endif
