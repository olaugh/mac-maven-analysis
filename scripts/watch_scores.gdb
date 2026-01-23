set architecture m68k
target remote localhost:1234
set pagination off

printf "\n=== Setting watchpoint on Maven's score at 0xb7b3 ===\n"
printf "Current value: "
x/1xb 0xb7b3

# Set a write watchpoint - will trigger when this byte is written
watch *(char*)0xb7b3
printf "Watchpoint set. Will break when Maven's score changes.\n"

printf "\n=== Now play a move to trigger score update ===\n"
printf "When the watchpoint hits, we'll see the scoring code.\n"

# Continue and wait for watchpoint
continue
