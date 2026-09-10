#ifndef MAVEN_GLOBAL_INITIALIZER_H
#define MAVEN_GLOBAL_INITIALIZER_H
#include <stddef.h>
#include <stdint.h>
int maven_initialize_globals(uint8_t *,size_t,const uint8_t *,size_t,
    const uint8_t *,size_t,const uint8_t *,size_t,uint32_t);
#endif
