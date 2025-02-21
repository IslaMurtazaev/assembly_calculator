.section .bss
buffer: .skip 100

.section .data
start_menu: .asciz "Calculator App\n"

operation_prompt: .asciz "Enter Choice > "
operand1_prompt: .asciz "Enter Operand 1 > "
operand2_prompt: .asciz "Enter Operand 2 > "

result: .asciz "Done\n"

.section .text
.global _start
_start:
	@ Print start menu
	ldr r1, =start_menu
	mov r2, #15
	bl print
input_variables:
	@Take user input for operation
	ldr r1, =operation_prompt
	mov r2, #15
	bl print 

	mov r2, #100 @ max bytes to read
	bl input

	@ Take user input for operand 1
	ldr r1, =operand1_prompt
	mov r2, #18
	bl print

	mov r2, #100
	bl input

	@ Take user input for operand 2
	ldr r1, =operand2_prompt
	mov r2, #18
	bl print

	mov r2, #100
	bl input
output:
	ldr r1, =result
	mov r2, #5
	bl print
end:
	mov r7, #1
	mov r0, #0
	svc #0

@ Functions

input:
	@ Arguments: r2 = max_length
	@ reads from stdin and loads it to buffer
	mov r0, #0 @ stdin
	ldr r1, =buffer @ load to buffer memory
	mov r7, #3 @ read syscall
	svc #0 @ invoke syscall
	bx lr @ return to caller

print:
	@ Arguments: r1 = message, r2 = length
	mov r0, #1 @ stdout
	mov r7, #4 @ write syscall
	svc #0 @ invoke syscall
	bx lr @ return to caller
	
