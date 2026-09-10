#include "endgame_probe_support.h"
static unsigned phase_count, phase_index;
static const char *phase_names[] = {"generation", "candidates", "replies", "continuations",
                                    "finished"};
static unsigned expected_phases[6];
static void checkpoint(void *u, const char *phase) {
    (void)u;
    if (phase_index >= phase_count)
        fail(phase, "extra phase", phase_index, 0, 0);
    if (strcmp(phase, phase_names[expected_phases[phase_index]]))
        fail(phase, "phase order", phase_index, 0, 0);
    compare(&active, &expected[phase_index], phase);
    ++phase_index;
}
int main(int argc, char **argv) {
    FILE *dictionary;
    uint8_t *data;
    long size;
    unsigned calls, sections_count, i, k;
    uint8_t own[8], other[8], final_own[8], final_other[8];
    if (argc != 3)
        return 2;
    fixture = fopen(argv[1], "rb");
    dictionary = fopen(argv[2], "rb");
    if (!fixture || !dictionary)
        return 2;
    fseek(dictionary, 0, SEEK_END);
    size = ftell(dictionary);
    rewind(dictionary);
    data = malloc((size_t)size);
    if (!data || fread(data, 1, (size_t)size, dictionary) != (size_t)size)
        return 2;
    fclose(dictionary);
    capacity = word();
    calls = word();
    words(letter_values, 128);
    bytes(word_multipliers, 544);
    bytes(letter_multipliers, 544);
    bytes(letter_class, 128);
    numbers(bits, 32);
    numbers(hash_table, 16);
    bytes(alphabet, 28);
    bonus = word();
    sections_count = word();
    for (i = 0; i < sections_count; ++i) {
        uint32_t off = number(), root = number();
        sections[i] = (MavenDictionarySection){data + off, root};
    }
    for (call_index = 0; call_index < calls; ++call_index) {
        bytes(own, 8);
        bytes(other, 8);
        bytes(final_own, 8);
        bytes(final_other, 8);
        load(&active);
        phase_count = word();
        for (k = 0; k < phase_count; ++k) {
            expected_phases[k] = word();
            load(&expected[k]);
        }
        phase_index = 0;
        active.leaf.own_rack = own;
        active.leaf.other_rack = other;
        active.leaf.checkpoint = checkpoint;
        maven_expand_endgame_leaf(&active.leaf);
        if (phase_index != phase_count)
            fail("return", "missing phase", phase_index, phase_index, phase_count);
        equal("return", "own", own, final_own, 8);
        equal("return", "other", other, final_other, 8);
        if (diagnostics)
            fail("return", "diagnostics", 0, diagnostics, 0);
    }
    fclose(fixture);
    free(data);
    return 0;
}
