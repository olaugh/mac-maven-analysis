#!/bin/sh
set -eu
compiler=${MAVEN_WASM_CLANG:-/opt/homebrew/opt/llvm@18/bin/clang}
mkdir -p .build
"$compiler" --target=wasm32 -O2 -ffreestanding -fno-builtin -nostdlib \
 -Wall -Wextra -Werror -Iscripts/wasm_include -Ireconstruction \
 scripts/wasm_endgame.c reconstruction/endgame_search.c reconstruction/endgame_leaf.c \
 reconstruction/endgame_tree.c reconstruction/endgame_generation.c \
 reconstruction/endgame_move_cache.c reconstruction/endgame_rack_bounds.c \
 reconstruction/reply_bounds.c reconstruction/candidate_ranking.c \
 reconstruction/local_replies.c reconstruction/board_state.c reconstruction/apply_move.c \
 reconstruction/place_letters.c reconstruction/move_finalize.c reconstruction/undo_move.c \
 reconstruction/board_moves.c reconstruction/board_placements.c reconstruction/rack_counts.c \
 reconstruction/rack_masks.c reconstruction/score_move.c reconstruction/score_accumulate.c \
 reconstruction/dictionary_lookup.c reconstruction/cross_check_letters.c \
 -Wl,--no-entry -Wl,--export-memory -Wl,--export=maven_endgame_buffer \
 -Wl,--export=maven_endgame_initialize -Wl,--export=maven_endgame_set \
 -Wl,--export=maven_endgame_get -Wl,--export=maven_endgame_run \
 -Wl,-z,stack-size=1048576 -o .build/maven-endgame.wasm
