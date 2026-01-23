set architecture m68k
target remote localhost:1234
set pagination off

printf "Capturing pre-swap memory snapshot...\n"
dump binary memory /tmp/rack_before.bin 0x1000 0x60000

printf "Done. Snapshot saved to /tmp/rack_before.bin\n"

detach
quit
