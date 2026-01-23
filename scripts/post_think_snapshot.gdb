set architecture m68k
target remote localhost:1234
set pagination off

printf "=== Capturing post-think snapshot ===\n"
dump binary memory /tmp/post_think.bin 0x1000 0x60000
dump binary memory /tmp/post_think_high.bin 0x80000 0x100000

printf "Snapshots saved. Now comparing...\n"

detach
quit
