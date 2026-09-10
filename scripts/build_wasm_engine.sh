#!/bin/sh
set -eu
compiler=${MAVEN_WASM_CLANG:-/opt/homebrew/opt/llvm@18/bin/clang}
mkdir -p .build
"$compiler" --target=wasm32 -O2 -ffreestanding -fno-builtin -nostdlib \
 -Wall -Wextra -Werror -Iscripts/wasm_include -Ireconstruction \
 scripts/wasm_engine.c reconstruction/heuristic_search.c reconstruction/leave_table.c \
 reconstruction/evaluated_application.c reconstruction/evaluation_features.c \
 reconstruction/display_move_score.c reconstruction/move_statistics.c \
 reconstruction/adjusted_pattern_lookup.c reconstruction/rack_masks.c \
 reconstruction/exchange_candidates.c reconstruction/candidate_ranking.c \
 reconstruction/opening_moves.c reconstruction/opening_placements.c \
 reconstruction/board_moves.c reconstruction/board_placements.c \
 reconstruction/cross_check_letters.c reconstruction/dictionary_lookup.c \
 reconstruction/move_evaluation.c reconstruction/pattern_cache.c \
 reconstruction/apply_move.c reconstruction/board_state.c reconstruction/move_finalize.c \
 reconstruction/score_move.c reconstruction/score_accumulate.c reconstruction/place_letters.c \
 reconstruction/rack_counts.c reconstruction/remaining_tiles.c reconstruction/undo_move.c \
 reconstruction/premium_exposure.c reconstruction/rack_balance.c reconstruction/rack_composition.c \
 reconstruction/pattern_match.c reconstruction/pattern_lookup.c reconstruction/letter_expectation.c \
 -Wl,--no-entry -Wl,--export-memory -Wl,--export=maven_engine_buffer \
 -Wl,--export=maven_engine_initialize -Wl,--export=maven_engine_penalties \
 -Wl,--export=maven_engine_set -Wl,--export=maven_engine_get -Wl,--export=maven_engine_run -Wl,--export=maven_engine_apply \
 -Wl,-z,stack-size=1048576 -o .build/maven-engine.wasm
