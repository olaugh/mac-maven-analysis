#!/bin/sh
set -eu
compiler=${MAVEN_WASM_CLANG:-/opt/homebrew/opt/llvm@18/bin/clang}
mkdir -p .build
"$compiler" --target=wasm32 -O2 -ffreestanding -fno-builtin -nostdlib \
 -Wall -Wextra -Werror -Iscripts/wasm_include -Ireconstruction \
 scripts/wasm_late.c reconstruction/exchange_candidates.c reconstruction/cross_check_letters.c reconstruction/late_search.c reconstruction/late_setup.c reconstruction/late_preparation.c reconstruction/late_pool_select.c reconstruction/late_ranking.c reconstruction/late_reply_value.c reconstruction/pool_weights.c reconstruction/leave_table.c reconstruction/adjusted_pattern_lookup.c reconstruction/pattern_lookup.c reconstruction/letter_expectation.c reconstruction/rack_balance.c reconstruction/rack_composition.c reconstruction/local_replies.c reconstruction/board_moves.c reconstruction/board_placements.c reconstruction/dictionary_lookup.c reconstruction/score_move.c reconstruction/score_accumulate.c reconstruction/rack_masks.c reconstruction/apply_move.c reconstruction/place_letters.c reconstruction/move_finalize.c reconstruction/undo_move.c reconstruction/board_state.c reconstruction/rack_counts.c reconstruction/remaining_tiles.c reconstruction/pattern_match.c reconstruction/reply_bounds.c reconstruction/candidate_ranking.c reconstruction/endgame_move_cache.c \
 -Wl,--no-entry -Wl,--export-memory -Wl,--export=maven_late_buffer \
 -Wl,--export=maven_late_initialize -Wl,--export=maven_late_set \
 -Wl,--export=maven_late_get -Wl,--export=maven_late_run \
 -Wl,-z,stack-size=1048576 -o .build/maven-late.wasm
