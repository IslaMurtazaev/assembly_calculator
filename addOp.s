.data
sum_fmt: .asciz "%d.%02d\n"

.section .text
.global add_operands
.extern printf
.extern _start

add_operands:
	@ args: r1 = operand1, r2 = operand2
	add r5, r1, r2

	mov r6, #100
	sdiv r3, r5, r6 @ get integer part
	mul r7, r3, r6
	sub r4, r5, r7 @ get fractional part

	mov r1, r3
	mov r2, r4	

	ldr r0, =sum_fmt
	bl printf
	b _start

