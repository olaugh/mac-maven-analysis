set architecture m68k
target remote localhost:1234
set pagination off

printf "=== Capturing pre-think snapshot ===\n"
dump binary memory /tmp/pre_think.bin 0x1000 0x60000
dump binary memory /tmp/pre_think_high.bin 0x80000 0x100000

printf "Snapshots saved.\n"
printf "Now click Play in Maven to make it think.\n"
printf "Then run the post_think script.\n"

detach
quit
