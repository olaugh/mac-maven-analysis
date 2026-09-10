#include "arrow_navigation.h"
static int16_t step(int16_t a, int b) {
    uint16_t v = (uint16_t)((uint16_t)a + b);
    return v < 32768 ? (int16_t)v : (int16_t)((int32_t)v - 65536);
}
int16_t maven_arrow_navigation(const MavenArrowOps *o, uint8_t c, uint16_t mods) {
    void *u = o->user;
    int16_t p;
    int shift = mods & 0x200, command = mods & 0x100, option = mods & 0x800;
    if (c != 28 && c != 29)
        return 0;
    if (shift) {
        if (command) {
            if (c == 28)
                o->select(u, 0, o->end(u));
            else
                o->select(u, o->start(u), 32767);
        } else if (option) {
            o->lock(u);
            if (c == 28) {
                if (!o->separator(u, o->end(u))) {
                    p = step(o->word_edge(u, o->end(u), 1), 1);
                    o->select(u, o->start(u), p);
                }
                o->unlock(u);
                p = o->word_edge(u, o->start(u), -1);
                o->select(u, p, o->end(u));
            } else {
                if (!o->separator(u, step(o->start(u), -1))) {
                    p = o->word_edge(u, o->start(u), -1);
                    o->select(u, p, o->end(u));
                }
                o->unlock(u);
                p = step(o->word_edge(u, o->end(u), 1), 1);
                o->select(u, o->start(u), p);
            }
        } else if (c == 28) {
            if (o->start(u) != 0)
                o->select(u, (int32_t)o->start(u) - 1, o->end(u));
        } else
            o->select(u, o->start(u), (int32_t)o->end(u) + 1);
        return 1;
    }
    if (command) {
        p = c == 28 ? 0 : 32767;
        o->select(u, p, p);
        return 0;
    }
    if (option) {
        p = c == 28 ? o->word_edge(u, o->start(u), -1) : step(o->word_edge(u, o->end(u), 1), 1);
        o->select(u, p, p);
        return 1;
    }
    p = c == 28 ? o->start(u) : o->end(u);
    o->select(u, p, p);
    return 0;
}
