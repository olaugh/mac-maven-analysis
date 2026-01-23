# GDB script to break at Maven's leave value calculation
# Usage: source break_leave_calc.gdb

set architecture m68k
set pagination off

# Connect to QEMU
target remote localhost:1234

echo \n=== Maven Leave Value Breakpoint Setup ===\n

# The key instruction in CODE 32 at offset 0x156A:
#   2068 d58c    MOVEA.L -10868(A0),A0   ; Load MUL handle
#   2d68 0018 ffdc  MOVE.L 24(A0),-36(A6)  ; Load leave adjustment from offset 24
#
# Unique byte sequence to search for:
#   20 68 d5 8c 2d 68 00 18 ff dc

# First, let the app start and load
echo Let Maven start, then we'll search for CODE 32...\n
echo Press Ctrl+C when Maven is at the main screen, then run: find_leave_code\n

define find_leave_code
  echo \nSearching for leave calculation code in memory...\n

  # Search in typical application heap area (0x00100000 - 0x00800000)
  # Looking for the pattern: 2068 d58c 2d68 0018 ffdc
  find /b 0x00100000, 0x00800000, 0x20, 0x68, 0xd5, 0x8c, 0x2d, 0x68, 0x00, 0x18, 0xff, 0xdc

  echo \nIf found, note the address and run: break *ADDRESS\n
end

define break_leave
  # Use this after find_leave_code finds the address
  # Argument: address found by find_leave_code
  if $argc == 1
    break *$arg0
    echo Breakpoint set at leave calculation code\n
    echo When hit, examine:\n
    echo   A0 = MUL resource data pointer\n
    echo   x/28xb $a0  - shows 28-byte MUL record\n
    echo   x/xw $a0+24 - shows leave adjustment value (signed int)\n
    echo   x/gf $a0    - shows expected score double\n
  else
    echo Usage: break_leave ADDRESS\n
  end
end

define show_mul_record
  # Call this when stopped at the breakpoint
  echo \n=== MUL Record at A0 ===\n
  echo Raw 28 bytes:\n
  x/28xb $a0
  echo \nExpected score (double at offset 0):\n
  x/gf $a0
  echo \nLeave adjustment (long at offset 24):\n
  x/dw $a0+24
  echo \n
end

define trace_sane_ops
  # Step through the SANE floating point operations
  echo Stepping through SANE FP operations...\n
  echo Watch for A9EB traps (FP68K)\n
  stepi 20
  x/10i $pc
end

echo \nCommands available:\n
echo   find_leave_code  - Search memory for leave calculation code\n
echo   break_leave ADDR - Set breakpoint at found address\n
echo   show_mul_record  - When stopped, show MUL data at A0\n
echo   trace_sane_ops   - Step through FP operations\n
echo \n

continue
