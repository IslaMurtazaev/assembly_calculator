.data
str_fmt: .asciz "%s"
menu_prompt: .asciz "Calculator App\n1-Add\n2-Subtract\n3-Multiply\n4-Divide\n5-Exit\n"

.section .text
.global display_menu
.extern printf

display_menu:
	@ Print menu
	push {lr}

	ldr r0, =str_fmt 
	ldr r1, =menu_prompt
	bl printf

	pop {lr}
	bx lr
