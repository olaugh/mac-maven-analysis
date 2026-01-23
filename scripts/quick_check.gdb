set architecture m68k
target remote localhost:1234
set pagination off

printf "=== Current Game State ===\n"
printf "John's score (0xb7b2): "
x/1ub 0xb7b2
printf "Maven's score (0xb7b3): "
x/1ub 0xb7b3

printf "\n=== Score area context ===\n"
x/8xb 0xb7b0

detach
quit
