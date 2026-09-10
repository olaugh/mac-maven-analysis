#include "endgame_probe_support.h"
#include "endgame_search.h"
static MavenEndgameSearch search;
static uint32_t clock_results[4096], clock_index, clock_count, start_ticks, tick_values[4096];
static int prefix_only;
static unsigned expected_iterations, iteration_index, leaf_index;
static struct LeafEntry {
    uint16_t current;
    uint8_t own[8], other[8], board[544];
} leaves[4096];
static uint8_t final_own[8], final_other[8], own[8], other[8], initial_selected[34];
static uint16_t original_letter_values[128];
static void search_checkpoint(void *user, const char *phase) {
    (void)user;
    if (!strcmp(phase, "leaf_entry")) {
        struct LeafEntry *entry;
        if (leaf_index >= expected_iterations)
            fail(phase, "extra leaf", leaf_index, 0, 0);
        entry = &leaves[leaf_index++];
        if (active.tree.current != entry->current)
            fail(phase, "current", leaf_index, active.tree.current, entry->current);
        equal(phase, "own", search.leaf.own_rack, entry->own, 8);
        equal(phase, "other", search.leaf.other_rack, entry->other, 8);
        equal(phase, "board", active.board, entry->board, 544);
        return;
    }
    call_index = iteration_index + 1;
    load(&expected[0]);
    if (getenv("MAVEN_DUMP_ITERATION") && iteration_index + 1 == (unsigned)atoi(getenv("MAVEN_DUMP_ITERATION")) && !strcmp(phase, "iteration")) {
        FILE *dump = fopen("/tmp/maven-actual-403.bin", "wb");
        fwrite(active.nodes, sizeof active.nodes, 1, dump); fclose(dump);
        fprintf(stderr, "iteration%u actual free=%u expected=%u current=%u expected=%u\n", iteration_index + 1, active.tree.free_head, expected[0].tree.free_head, active.tree.current, expected[0].tree.current);
    }
    compare(&active, &expected[0], phase);
    if (!strcmp(phase, "iteration")) {
        unsigned next = word(), optimistic = word(), alternative = word(), guaranteed = word();
        int16_t initial = sw(word());
        if (search.next_frontier != next)
            fail(phase, "next", iteration_index, search.next_frontier, next);
        if (search.frontier.optimistic != optimistic)
            fail(phase, "optimistic", iteration_index, search.frontier.optimistic, optimistic);
        if (search.frontier.alternative != alternative)
            fail(phase, "alternative", iteration_index, search.frontier.alternative, alternative);
        if (search.frontier.guaranteed != guaranteed)
            fail(phase, "guaranteed", iteration_index, search.frontier.guaranteed, guaranteed);
        if (search.initial_reserve != initial)
            fail(phase, "initial reserve", iteration_index, search.initial_reserve, initial);
        ++iteration_index;
        if(prefix_only && iteration_index==expected_iterations)exit(0);
    } else if (!strcmp(phase, "finished")) {
        equal(phase, "ranked moves", active.generation.ranking.moves,
              expected[0].generation.ranking.moves, 340);
        equal(phase, "restored selection", search.selected_move, initial_selected, 34);
        equal(phase, "restored letter values", letter_values, original_letter_values, 256);
        if (active.generation.bingo_bonus != bonus)
            fail(phase, "bingo", 0, active.generation.bingo_bonus, bonus);
    } else if (strcmp(phase, "ranking"))
        fail(phase, "unknown phase", 0, 0, 0);
}
static int32_t elapsed(void *user) {
    uint32_t raw;
    int32_t rounded;
    (void)user;
    if (clock_index >= clock_count)
        fail("clock", "extra clock read", clock_index, 0, 0);
    raw = tick_values[clock_index] - start_ticks + 30;
    rounded =
        (raw <= INT32_MAX ? (int32_t)raw : (int32_t)((int64_t)raw - INT64_C(4294967296))) / 60;
    if ((uint32_t)rounded != clock_results[clock_index])
        fail("clock", "rounded ticks", clock_index, rounded, clock_results[clock_index]);
    ++clock_index;
    return rounded;
}
int main(int argc, char **argv) {
    FILE *dictionary;
    uint8_t *data;
    long size;
    unsigned count, i;
    int16_t reserve;
    int32_t budget;
    if (argc != 3 && (argc != 4 || strcmp(argv[3],"--prefix")))
        return 2;
    prefix_only=argc==4;
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
    expected_iterations = word();
    words(letter_values, 128);
    memcpy(original_letter_values, letter_values, 256);
    bytes(word_multipliers, 544);
    bytes(letter_multipliers, 544);
    bytes(letter_class, 128);
    numbers(bits, 32);
    numbers(hash_table, 16);
    bytes(alphabet, 28);
    bonus = word();
    count = word();
    for (i = 0; i < count; ++i) {
        uint32_t off = number(), root = number();
        sections[i] = (MavenDictionarySection){data + off, root};
    }
    bytes(own, 8);
    bytes(other, 8);
    bytes(final_own, 8);
    bytes(final_other, 8);
    budget = (int32_t)number();
    reserve = sw(word());
    start_ticks = number();
    clock_count = word();
    if (clock_count > 4096 || expected_iterations > 4096)
        return 2;
    for (i = 0; i < clock_count; ++i) {
        clock_results[i] = number();
        tick_values[i] = number();
    }
    for (i = 0; i < expected_iterations; ++i) {
        leaves[i].current = word();
        bytes(leaves[i].own, 8);
        bytes(leaves[i].other, 8);
        bytes(leaves[i].board, 544);
    }
    load(&active);
    search.leaf = active.leaf;
    search.letter_values = letter_values;
    search.own_rack = own;
    search.other_rack = other;
    search.reserve_control = reserve;
    search.budget_seconds = budget;
    search.elapsed_seconds = elapsed;
    search.checkpoint = search_checkpoint;
    memcpy(search.selected_move, active.leaf.best_empty_move, 34);
    memcpy(initial_selected, search.selected_move, 34);
    maven_search_endgame(&search);
    if (iteration_index != expected_iterations || leaf_index != expected_iterations)
        fail("return", "iteration count", iteration_index, iteration_index, expected_iterations);
    if (clock_index != clock_count)
        fail("return", "clock count", clock_index, clock_index, clock_count);
    equal("return", "own", own, final_own, 8);
    equal("return", "other", other, final_other, 8);
    if (diagnostics)
        fail("return", "diagnostics", 0, diagnostics, 0);
    fclose(fixture);
    free(data);
    return 0;
}
