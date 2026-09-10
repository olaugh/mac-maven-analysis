#!/bin/sh
# Build the playable Maven engine for the browser. Uses the unmodified
# reconstruction sources plus the application extension in this directory.
set -eu
cd "$(dirname "$0")/../.."
compiler=${MAVEN_WASM_CLANG:-/opt/homebrew/opt/llvm@18/bin/clang}
mkdir -p web/build
files=$(grep -o 'reconstruction/[a-z_]*\.c' scripts/build_wasm_portable.sh | sort -u | grep -v 'portable_engine\.c')
files="$files reconstruction/query_prepare.c reconstruction/word_enumerator.c"
"$compiler" --target=wasm32 -O2 -ffreestanding -fno-builtin -nostdlib \
 -Wall -Wextra -Werror -Wno-unused-function -Iscripts/wasm_include -Ireconstruction -Iweb/engine \
 web/engine/maven_app.c web/engine/portable_engine_app.c scripts/wasm_runtime.c \
 $files \
 -Wl,--no-entry -Wl,--export-memory \
 -Wl,--export=app_buffer -Wl,--export=app_capacity -Wl,--export=app_create \
 -Wl,--export=app_set_lexicon -Wl,--export=app_set_seeds -Wl,--export=app_private_seed -Wl,--export=app_toolbox_seed \
 -Wl,--export=app_set_position -Wl,--export=app_get_position -Wl,--export=app_deal \
 -Wl,--export=app_search_heuristic -Wl,--export=app_search_late -Wl,--export=app_search_endgame -Wl,--export=app_kibitz -Wl,--export=app_move -Wl,--export=app_set_level -Wl,--export=app_level_reset -Wl,--export=app_set_level_counter -Wl,--export=app_level_counter \
 -Wl,--export=app_count -Wl,--export=app_play_ranked -Wl,--export=app_play_move -Wl,--export=app_play_exchange \
 -Wl,--export=app_save -Wl,--export=app_load -Wl,--export=app_history_select -Wl,--export=app_history_records \
 -Wl,--export=app_statistics -Wl,--export=app_unseen -Wl,--export=app_word_acceptable -Wl,--export=app_word_list \
 -Wl,--export=app_letter_values -Wl,--export=app_simulate \
 -Wl,-z,stack-size=1048576 -o web/build/maven-app.wasm
ls -la web/build/maven-app.wasm
