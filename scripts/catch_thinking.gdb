set architecture m68k
target remote localhost:1234
set pagination off

printf "\n=== Ready to catch Maven thinking ===\n"
printf "Current PC:\n"
info reg pc

printf "\nCurrent state:\n"
info reg

printf "\n=== To catch evaluation: ===\n"
printf "1. Keep this GDB session ready\n"
printf "2. Click Play in Maven\n"  
printf "3. While thinking, I'll interrupt with Ctrl+C\n"
printf "4. Then examine the PC to see where we are\n"

# Save current location for later comparison
set logging file /tmp/thinking_trace.log
set logging enabled on

printf "\nWaiting for interrupt (Ctrl+C) during thinking...\n"
continue
