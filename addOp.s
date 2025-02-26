.data
sum_fmt: .asciz "%d+%d=%d\n"

.section .text
.global add_operands
.extern printf
.extern _start

add_operands:
	@ args: r1 = operand1, r2 = operand2
	add r3, r1, r2

	ldr r0, =sum_fmt
	bl printf
	b _start

