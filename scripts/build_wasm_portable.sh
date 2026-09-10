#!/bin/sh
set -eu
compiler=${MAVEN_WASM_CLANG:-/opt/homebrew/opt/llvm@18/bin/clang}
mkdir -p .build
"$compiler" --target=wasm32 -O2 -ffreestanding -fno-builtin -nostdlib \
 -Wall -Wextra -Werror -Iscripts/wasm_include -Ireconstruction \
 scripts/wasm_portable.c scripts/wasm_runtime.c \
 reconstruction/endgame_search.c reconstruction/endgame_leaf.c reconstruction/endgame_tree.c reconstruction/endgame_generation.c reconstruction/endgame_rack_bounds.c reconstruction/hash_initializer.c reconstruction/rack_refill.c \
 reconstruction/late_search.c reconstruction/late_search_budget.c reconstruction/late_setup.c reconstruction/late_preparation.c reconstruction/late_pool_select.c reconstruction/late_ranking.c reconstruction/late_reply_value.c reconstruction/pool_weights.c reconstruction/local_replies.c reconstruction/reply_bounds.c reconstruction/endgame_move_cache.c \
 reconstruction/game_turn.c reconstruction/evaluated_application.c reconstruction/evaluation_features.c reconstruction/display_move_score.c reconstruction/move_statistics.c reconstruction/history_records.c reconstruction/history_store.c reconstruction/history_playback.c reconstruction/history_snapshot.c \
 reconstruction/simulation_session.c reconstruction/simulation_search.c reconstruction/simulation_restore.c reconstruction/random_opponent.c reconstruction/opponent_samples.c reconstruction/rollout_search.c reconstruction/search_dispatch.c reconstruction/search_policy.c \
 reconstruction/portable_engine.c reconstruction/dictionary_validate.c \
 reconstruction/engine_tables.c reconstruction/score_statistics.c reconstruction/global_initializer.c \
 reconstruction/heuristic_search.c reconstruction/leave_table.c reconstruction/playing_level.c \
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
 -Wl,--no-entry -Wl,--export-memory -Wl,--export=maven_port_buffer \
 -Wl,--export=maven_port_capacity -Wl,--export=maven_port_create \
 -Wl,--export=maven_port_position -Wl,--export=maven_port_search -Wl,--export=maven_port_get_position -Wl,--export=maven_port_play -Wl,--export=maven_port_load -Wl,--export=maven_port_save -Wl,--export=maven_port_history_select -Wl,--export=maven_port_count -Wl,--export=maven_port_late -Wl,--export=maven_port_endgame -Wl,--export=maven_port_simulate \
 -Wl,-z,stack-size=1048576 -o .build/maven-portable.wasm
