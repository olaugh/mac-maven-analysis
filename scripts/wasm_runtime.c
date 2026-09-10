#include <stddef.h>
#include <stdint.h>
#include <string.h>
void *memset(void *p, int c, size_t n) {
  uint8_t *s = p;
  while (n--)
    *s++ = (uint8_t)c;
  return p;
}
void *memcpy(void *to, const void *from, size_t n) {
  uint8_t *d = to;
  const uint8_t *s = from;
  while (n--)
    *d++ = *s++;
  return to;
}
void *memmove(void *to, const void *from, size_t n) {
  uint8_t *d = to;
  const uint8_t *s = from;
  if (d < s)
    while (n--)
      *d++ = *s++;
  else {
    d += n;
    s += n;
    while (n--)
      *--d = *--s;
  }
  return to;
}
int memcmp(const void *a, const void *b, size_t n) {
  const unsigned char *x = a, *y = b;
  while (n--) {
    if (*x != *y)
      return *x - *y;
    ++x;
    ++y;
  }
  return 0;
}
char *strcpy(char *to, const char *from) {
  char *d = to;
  while ((*d++ = *from++)) {
  }
  return to;
}
size_t strlen(const char *p) {
  const char *s = p;
  while (*p)
    ++p;
  return (size_t)(p - s);
}
int strcmp(const char *a, const char *b) {
  while (*a && *a == *b) {
    ++a;
    ++b;
  }
  return (unsigned char)*a - (unsigned char)*b;
}
char *strchr(const char *s, int c) {
  do {
    if ((unsigned char)*s == (unsigned char)c)
      return (char *)s;
  } while (*s++);
  return NULL;
}
