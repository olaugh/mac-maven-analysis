/* Controlled compiler/linker probe; no library dependencies. */
volatile unsigned long left_operand = 0x12345678UL;
volatile unsigned long right_operand = 0x00010003UL;
volatile unsigned long product;
volatile unsigned long quotient;
volatile unsigned long remainder;
volatile unsigned short finished;

void main(void)
{
    product = left_operand * right_operand;
    quotient = left_operand / right_operand;
    remainder = left_operand % right_operand;
    finished = 1;
    for (;;) {}
}
