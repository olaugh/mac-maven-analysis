set architecture m68k
target remote localhost:1234
set pagination off

printf "=== Pre-kibitz snapshot ===\n"
dump binary memory /tmp/pre_kibitz.bin 0x1000 0x60000
dump binary memory /tmp/pre_kibitz_high.bin 0x80000 0x200000

printf "Snapshot saved. Now click Kibitz in Maven.\n"

detach
quit
