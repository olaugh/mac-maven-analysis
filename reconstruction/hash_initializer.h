#ifndef MAVEN_HASH_INITIALIZER_H
#define MAVEN_HASH_INITIALIZER_H
#include <stdint.h>
/* CODE53[0x18,0x40): lazy16-word initialization via CODE4's private RNG.
 * A nonzero first table word skips all draws. Reject zero seed/table failure
 * atomically instead of calling the original nonlocal error handler. */
int maven_initialize_hash_table(uint32_t table[16], uint32_t *random_state);
#endif
