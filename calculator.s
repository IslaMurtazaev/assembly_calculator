.section .bss
buffer: .skip 4

.section .data
start_menu: .asciz "Calculator App\n"

operation_prompt: .asciz "Enter Choice > "
operand1_prompt: .asciz "Enter Operand 1 > "
operand2_prompt: .asciz "Enter Operand 2 > "

str_fmt: .asciz "%s"
int_fmt: .asciz "%d" @ Format string for integer input
sum_fmt: .asciz "%d+%d=%d\n"

.section .text
.global _start
.extern printf
.extern scanf

_start:
	@ Print start menu
	ldr r0, =str_fmt
	ldr r1, =start_menu
	bl printf
input_variables:
	@ Take user input to calculate
	@ Stores r8 = operation, r9 = operand1, r10 = operand2

	@ Take user input for operation
	ldr r0, =str_fmt
	ldr r1, =operation_prompt
	bl printf
	bl input
	ldr r8, [r1]

	@ Take user input for operand 1
	ldr r0, =str_fmt
	ldr r1, =operand1_prompt
	bl printf
	bl input
	ldr r9, [r1]

	@ Take user input for operand 2
	ldr r0, =str_fmt
	ldr r1, =operand2_prompt
	bl printf
	bl input
	ldr r10, [r1]
output:
	ldr r0, =sum_fmt
	mov r1, r8
	mov r2, r9
	mov r3, r10
	bl printf
end:
	mov r7, #1
	mov r0, #0
	svc #0

@ Functions

input:
	@ reads from stdin and loads it to buffer
	push {lr}

	ldr r0, =int_fmt
	ldr r1, =buffer
	bl scanf
	ldr r1, =buffer

	pop {lr}
	bx lr

