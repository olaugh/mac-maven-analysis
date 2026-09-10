#!/bin/sh
set -eu
compiler=${MAVEN_WASM_CLANG:-/opt/homebrew/opt/llvm@18/bin/clang}
mkdir -p .build
"$compiler" --target=wasm32 -O2 -ffreestanding -fno-builtin -nostdlib \
 -Wall -Wextra -Werror -Iscripts/wasm_include -Ireconstruction \
 scripts/wasm_simulation.c reconstruction/search_dispatch.c reconstruction/late_search_budget.c reconstruction/search_policy.c reconstruction/endgame_search.c reconstruction/endgame_leaf.c reconstruction/endgame_tree.c reconstruction/endgame_generation.c reconstruction/endgame_move_cache.c reconstruction/endgame_rack_bounds.c reconstruction/reply_bounds.c reconstruction/local_replies.c reconstruction/late_search.c reconstruction/late_preparation.c reconstruction/late_pool_select.c reconstruction/late_setup.c reconstruction/late_ranking.c reconstruction/late_reply_value.c reconstruction/pool_weights.c reconstruction/simulation_session.c reconstruction/simulation_search.c reconstruction/simulation_restore.c reconstruction/rollout_search.c reconstruction/opponent_samples.c reconstruction/random_opponent.c reconstruction/rack_refill.c reconstruction/heuristic_search.c reconstruction/leave_table.c \
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
 -Wl,--no-entry -Wl,--export-memory -Wl,--export=maven_late_search_decision -Wl,--export=maven_engine_buffer \
 -Wl,--export=maven_engine_initialize -Wl,--export=maven_engine_penalties \
 -Wl,--export=maven_engine_set -Wl,--export=maven_engine_get -Wl,--export=maven_engine_run \
 -Wl,--export=maven_simulation_buffer -Wl,--export=maven_simulation_set -Wl,--export=maven_simulation_get \
 -Wl,--export=maven_simulation_event -Wl,--export=maven_simulation_run \
 -Wl,--export=maven_simulation_save_position -Wl,--export=maven_simulation_restore_position \
 -Wl,-z,stack-size=1048576 -o .build/maven-simulation.wasm
