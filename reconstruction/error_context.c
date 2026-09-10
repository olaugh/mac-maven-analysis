#include "error_context.h"

/* Repeated error-transfer sequence, e.g. CODE 15 [0x0028,0x004e).
 * Static source/header reconstruction; original-runtime error trace pending.
 * The original inlines longjmp; ordinary C may emit a call instead.
 */
void maven_raise_error(MavenErrorContext *context, const void *error) {
    context->pending_error = error;
    --context->depth;
    longjmp(context->handlers[context->depth], 1);
}
