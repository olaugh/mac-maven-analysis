set architecture m68k
target remote localhost:1234
set pagination off

printf "\n=== Setting watchpoint on Maven's score at 0xb7b3 ===\n"
printf "Current value: "
x/1xb 0xb7b3

# Set hardware watchpoint on write to this address
watch *(unsigned char *)0xb7b3

printf "\nWatchpoint set. Continuing execution...\n"
printf "Play a move to trigger Maven's score update.\n"
printf "GDB will break when the score is written.\n\n"

# Continue execution - will break when watchpoint triggers
continue
