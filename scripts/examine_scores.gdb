set architecture m68k
target remote localhost:1234
set pagination off

printf "\n=== Examining 0xb7b0 area (33 and 108 adjacent) ===\n"
x/32xb 0xb7a0

printf "\nAs words:\n"
x/16xh 0xb7a0

printf "\n=== Examining 0xccf0 area (word format) ===\n"
x/32xb 0xccd0

printf "\nAs words:\n"
x/16xh 0xccd0

printf "\n=== Check if 0xb6bd changed (was 100=0x64, should be 108=0x6c) ===\n"
x/16xb 0xb6b0

detach
quit
