.section .bss
buffer: .skip 4

.section .data

@ UI messages
menu_prompt: .asciz "Calculator App\n1-Add\n2-Subtract\n3-Multiply\n4-Divide\n5-Exit\n"
operation_prompt: .asciz "Enter Choice > "
operand1_prompt: .asciz "Enter Operand 1 > "
operand2_prompt: .asciz "Enter Operand 2 > "
exit_msg: .asciz "Application Exit!\n"

@ Formats for input
str_fmt: .asciz "%s"
int_fmt: .asciz "%d"
sum_fmt: .asciz "%d+%d=%d\n"
sub_fmt: .asciz "%d-%d=%d\n"
mul_fmt: .asciz "%d*%d=%d\n"
div_fmt: .asciz "%d/%d=%d\n"

.section .text
.global main
.extern printf
.extern scanf

main:
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
	bl input
	ldr r9, [r1]

	@ Take user input for operand 2
	ldr r0, =str_fmt
	ldr r1, =operand2_prompt
	bl printf
	bl input
	ldr r10, [r1]
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

display_menu:
	@ Print menu
	push {lr}

	ldr r0, =str_fmt
	ldr r1, =menu_prompt
	bl printf

	pop {lr}
	bx lr

add_operands:
	@ args: r1 = operand1, r2 = operand2
	add r3, r1, r2
	ldr r0, =sum_fmt

	bl printf
	b main

sub_operands:
	@ args: r1 = operand1, r2 = operand2
	sub r3, r1, r2
	ldr r0, =sub_fmt

	bl printf
	b main

mul_operands:
	@ args: r1 = operand1, r2 = operand2
	mul r3, r1, r2
	ldr r0, =mul_fmt

	bl printf
	b main

div_operands:
	@ args: r1 = operand1, r2 = operand2
	sdiv r3, r1, r2
	ldr r0, =div_fmt

	bl printf
	b main

input:
	@ reads from stdin and loads it to buffer
	@ stores the memory location of input in r1
	push {lr}

	ldr r0, =int_fmt
	ldr r1, =buffer
	bl scanf
	ldr r1, =buffer

	pop {lr}
	bx lr

end:
	@ print exit message
	ldr r0, =str_fmt
	ldr r1, =exit_msg
	bl printf

	@ sys exit call
	mov r7, #1
	mov r0, #0
	svc #0
