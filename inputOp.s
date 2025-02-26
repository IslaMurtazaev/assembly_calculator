.section .bss
buffer: .skip 32

.section .data
str_fmt: .asciz "%31s"  @ Limit input size

.section .text
.global input_operand
.extern scanf

input_operand:
    @ Return r1 = input number * 100
    @ this allows Q2.2 fixed point numbers
    @ "1.2" becomes 120 
    push {lr, r4, r5, r6, r7}  @ Save registers

    ldr r0, =str_fmt          @ Format for scanf (read string)
    ldr r1, =buffer           @ Store input in buffer
    bl scanf

    ldr r1, =buffer           @ Load buffer address
    mov r2, #0                @ Integer part
    mov r3, #0                @ Fractional part
    mov r4, #0                @ Flag for decimal point found
    mov r5, #10               @ Multiplier for integer conversion
    mov r6, #1                @ Multiplier for fractional conversion
    mov r7, #10               @ Store 10 for multiplication

parse_loop:
    ldrb r0, [r1], #1         @ Load a single character
    cmp r0, #0                @ Check for null terminator
    beq done_parsing
    cmp r0, #'.'              @ Check if it's a decimal point
    beq set_fraction_flag

    cmp r4, #0                @ Check if we're processing integer part
    beq process_integer

process_fraction:
    sub r0, r0, #'0'          @ Convert ASCII to integer
    mul r3, r3, r7            @ Multiply previous fraction by 10
    add r3, r3, r0            @ Add new digit
    mul r6, r6, r7            @ Adjust fraction scale
    b parse_loop

process_integer:
    sub r0, r0, #'0'          @ Convert ASCII to integer
    mul r2, r2, r7            @ Multiply previous integer by 10
    add r2, r2, r0            @ Add new digit
    b parse_loop

set_fraction_flag:
    mov r4, #1                @ Set flag to process fraction
    b parse_loop

done_parsing:
    @ Scale the fractional part
    mov r0, #100              @ We use 100 as scaling factor
    mul r3, r3, r0            @ Adjust fraction to fit 2 decimal places
    sdiv r3, r3, r6
    mul r2, r2, r0            @ Scale integer part
    add r1, r2, r3            @ Fixed-point representation = integer_part * 100 + fraction_part

    pop {lr, r4, r5, r6, r7}  @ Restore registers
    bx lr                     @ Return
