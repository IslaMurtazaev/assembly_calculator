.data
sub_fmt: .asciz "%d-%d=%d\n"

.section .text
.global sub_operands
.extern printf
.extern main

sub_operands:
	@ args: r1 = operand1, r2 = operand2
	sub r3, r1, r2

	ldr r0, =sub_fmt
	bl printf
	b main

