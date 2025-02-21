.section .bss
buffer: .skip 100

.section .data
start_menu: .asciz "Calculator App\n"

operation_prompt: .asciz "Enter Choice > "

result: .asciz "Done\n"

.section .text
.global _start
_start:
	@ Print start menu
	ldr r1, =start_menu
	mov r2, #15
	bl print
input:
	@Take user input for operation
	ldr r1, =operation_prompt
	mov r2, #15
	bl print 

	mov r0, #0 @ stdin
	ldr r1, =buffer @ load address of buffer
	mov r2, #20 @ max bytes to read
	mov r7, #3 @ read syscall
	svc #0 
output:
	ldr r1, =result
	mov r2, #5
	bl print
end:
	mov r7, #1
	mov r0, #0
	svc #0

@ Functions

print:
	@ Arguments: r1 = message, r2 = length
	mov r0, #1 @ stdout
	mov r7, #4 @ write syscall
	svc #0 @ invoke syscall
	bx lr @ return to caller
	
