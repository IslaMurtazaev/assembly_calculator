.section .bss
buffer: .skip 4

.section .data

@ UI messages
operation_prompt: .asciz "Enter Choice > "
operand1_prompt: .asciz "Enter Operand 1 > "
operand2_prompt: .asciz "Enter Operand 2 > "
exit_msg: .asciz "Application Exit!\n"

@ Formats for input
str_fmt: .asciz "%s"
int_fmt: .asciz "%d"
mul_fmt: .asciz "%d*%d=%d\n"
div_fmt: .asciz "%d/%d=%d\n"

.section .text
.global _start

.extern printf
.extern scanf

.extern display_menu
.extern add_operands
.extern sub_operands
.extern input_operand

_start:
	bl display_menu
input_operation:
	@ Take user input for operation
	@ store r8 = selected operation
	ldr r0, =str_fmt
	ldr r1, =operation_prompt
	bl printf
	bl input
	ldr r8, [r1]

	@ check if user chose to exit
	cmp r8, #5
	beq end
input_operands:
	@ Take user input for operands
	@ Stores r9 = operand1, r10 = operand2

	@ Take user input for operand 1
	ldr r0, =str_fmt
	ldr r1, =operand1_prompt
	bl printf
	bl input_operand
	mov r9, r1

	@ Take user input for operand 2
	ldr r0, =str_fmt
	ldr r1, =operand2_prompt
	bl printf
	bl input_operand
	mov r10, r1
calculate:
	@ set operands as aguments to the following function
	mov r1, r9
	mov r2, r10
 
	cmp r8, #1
	beq add_operands
	cmp r8, #2
	beq sub_operands
	cmp r8, #3
	beq mul_operands
	cmp r8, #4
	beq div_operands

@ Functions

input:
	@ stores the memory location of input in r1
	push {lr}

	ldr r0, =int_fmt
	ldr r1, =buffer
	bl scanf
	ldr r1, =buffer

	pop {lr}
	bx lr

mul_operands:
	@ args: r1 = operand1, r2 = operand2
	mul r3, r1, r2
	ldr r0, =mul_fmt

	bl printf
	b _start

div_operands:
	@ args: r1 = operand1, r2 = operand2
	sdiv r3, r1, r2
	ldr r0, =div_fmt

	bl printf
	b _start

end:
	@ print exit message
	ldr r0, =str_fmt
	ldr r1, =exit_msg
	bl printf

	@ sys exit call
	mov r7, #1
	mov r0, #0
	svc #0
