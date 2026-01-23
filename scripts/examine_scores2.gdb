set architecture m68k
target remote localhost:1234
set pagination off

printf "\n=== Examining 0x1f200 area (found 21 here) ===\n"
x/32xh 0x1f200

printf "\nAs bytes:\n"
x/64xb 0x1f200

printf "\n=== Searching for 100 (0x64) near score area ===\n"
x/128xb 0x1f1e0

printf "\n=== Also check near displayed UI areas ===\n"
printf "\nWindow/dialog memory might have score display values\n"
x/64xb 0x1f280

printf "\n=== Dump a snapshot for comparison ===\n"
dump binary memory /tmp/snapshot2.bin 0x1000 0x60000

detach
quit
