# GDB script to capture Maven leave values
# Run with: gdb -x capture_leaves.gdb

set architecture m68k
target remote localhost:1234

# Don't stop on signals
handle SIGINT nostop pass
handle SIGSEGV nostop pass

# Set pagination off for scripting
set pagination off
set logging file /tmp/maven_trace.log
set logging enabled on

echo \n=== Maven Leave Value Capture ===\n

# Continue execution and let user interact
echo Continuing execution. Set breakpoints when Maven is loaded.\n
echo \nUseful commands:\n
echo   info reg - show registers\n
echo   x/10xw ADDR - examine memory\n
echo   break *0xADDR - set breakpoint\n
echo   continue - resume execution\n
echo   stepi - single step\n
echo \nTo find Maven in memory:\n
echo   1. Look for 'DAWG' or 'MUL' strings\n
echo   2. Search for resource signatures\n

# Function to dump memory as floats
define dump_floats
  set $addr = $arg0
  set $count = $arg1
  set $i = 0
  while $i < $count
    set $val = *(double*)($addr + $i * 8)
    printf "  [%d] %g\n", $i, $val
    set $i = $i + 1
  end
end

# Let it run
continue
