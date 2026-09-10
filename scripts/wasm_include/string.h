#ifndef MAVEN_WASM_STRING_H
#define MAVEN_WASM_STRING_H
#include <stddef.h>
void *memset(void *, int, size_t);
size_t strlen(const char *);
void *memcpy(void *, const void *, size_t);
char *strcpy(char *, const char *);
void *memmove(void *, const void *, size_t);
int strcmp(const char *, const char *);
char *strchr(const char *, int);
int memcmp(const void *, const void *, size_t);
#endif
