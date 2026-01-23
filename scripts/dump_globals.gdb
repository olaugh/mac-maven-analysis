set architecture m68k
target remote localhost:1234
set pagination off

printf "=== Getting A5 register value ===\n"
info registers a5

printf "\n=== Dumping A5-relative data structures ===\n"
# A5 should point to globals. Get its value first.
set $a5val = $a5

printf "A5 = 0x%x\n", $a5val

# Dump board area (17154 bytes before A5)
printf "\nDumping board at A5-17154...\n"
dump binary memory /tmp/maven_board.bin ($a5val - 17154) ($a5val - 17154 + 512)

# Dump score table at A5-27630
printf "Dumping score table at A5-27630...\n"
dump binary memory /tmp/maven_scores_tbl.bin ($a5val - 27630) ($a5val - 27630 + 256)

# Dump table at A5-16610
printf "Dumping eval table at A5-16610...\n"
dump binary memory /tmp/maven_eval_tbl.bin ($a5val - 16610) ($a5val - 16610 + 512)

# Show some board data
printf "\n=== Board data (17x17 at A5-17154) ===\n"
x/17xb ($a5val - 17154)
x/17xb ($a5val - 17154 + 17)
x/17xb ($a5val - 17154 + 34)
x/17xb ($a5val - 17154 + 51)

detach
quit
