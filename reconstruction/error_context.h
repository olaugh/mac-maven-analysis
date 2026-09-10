#ifndef MAVEN_ERROR_CONTEXT_H
#define MAVEN_ERROR_CONTEXT_H

#include <setjmp.h>

/* Classic THINK layout, with 32-bit pointers and its non-68881 jmp_buf:
 * pending_error: A5-24030; handlers: A5-24026; depth: A5-23674.
 * Host jmp_buf/pointer sizes differ: this is native source, NOT a serialized
 * guest-memory structure. The error payload's concrete type remains unknown.
 */
typedef struct MavenErrorContext {
    const void *pending_error;
    jmp_buf handlers[8];
    short depth;
} MavenErrorContext;

/* Call only with an available slot, after the caller's depth check. This must
 * expand in the caller: a function that returned after setjmp would be invalid.
 * Use as the controlling expression of an if, as required by standard C.
 */
#define MAVEN_SAVE_ERROR_CONTEXT(context) setjmp((context)->handlers[(context)->depth++])

/* Requires depth in 1..8 and a still-active matching setjmp frame.
 * The original error paths do not check for underflow; no new recovery behavior
 * is introduced here. They store the payload, pop a frame, and longjmp with 1.
 */
void maven_raise_error(MavenErrorContext *context, const void *error);

#endif
