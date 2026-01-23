set architecture m68k
target remote localhost:1234
set pagination off

printf "=== Post-kibitz snapshot ===\n"
dump binary memory /tmp/post_kibitz.bin 0x1000 0x60000
dump binary memory /tmp/post_kibitz_high.bin 0x80000 0x200000

printf "Snapshot saved. Now comparing...\n"

detach
quit
