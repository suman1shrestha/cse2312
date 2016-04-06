/*************************************************************************
* @file calculator.s
* @brief simple get keyboard character and compare
*
* Simple program of invoking syscall to retrieve a char and two integerd * numbers from keyboard, and perform the desired operation 
*
* @author Suman Shrestha
*************************************************************************/

	.global main
	.func main

main:
	BL _scanf				@ branch to scanf prodecure with return
	MOV R1, R0
	BL _getchar
	MOV R2, R0
	BL _scanf
	MOV R3, R0
	BL _compare
	MOV R8, R0
	BL _printf
	B main

_getchar:
	MOV R7, #3 				@ write syscall, 4
	MOV R0, #0				@ output stream to monitor, 1
	MOV R2, #1				@ read a single character
	LDR R1, =read_char		@ store the character in data memory
	SWI 0					@ excute the system call
	LDR R0, [R1]			@ move the character to the return register
	AND R0, #0xFF			@ mask out all but the lowest 8 bits
	MOV PC LDR 				@ return

_scanf:
	MOV R4, LDR 			@ store LR since scanf call overwrites
	SUB SP, SP, #4			@ make romm on stack
	LDR R0, =format_str		@ R0 contains address of format string
	MOV R1, SP 				@ move SP to R1 to store entry on stack
	BL scanf 				@ call scanf
	LDR R0, [SP]  			@ load value at SP into R0
	ADD SP, SP, #4			@ restore the stack pointer
	MOV PC, R4				@ return

_compare:
	CMP R2, #'+'			@ compare against the constant char '+'
	BLEQ _add				@ branch to equal handler
	CMP R2, #'-'			@ compare against the constatn char '-'
	BLEQ _sub				@ branch to equal handler
	CMP R2, #'*'			@ compare against the constatn char '*'
	BLEQ _mult				@ branch to equal handler
	CMP R2, #'M'			@ compare against the constatn char 'M'
	BLEQ _max				@ branch to equal handler

_printf:
	MOV R4, LR 				@ store LR since printf call overwrites
	LDR R0, =format_str		@ R0 contains formatted string address
	MOV R8, R8				@ R8 contains printf argument (redundant line)
	BL printf 				@ call printf
	MOV PC, R4				@ return

_add: 
	ADD R0, R1, R3
	MOV PC, LR

_sub:
	SUB R0, R1, R3
	MOV PC, LR

_mult:
	MULT R0, R1, R3
	MOV PC, LR

_max:
	CMP R1, R3
	MOVGT R0, R1
	MOVLT R0, R3


.data
format_str:		.asciz		"%d"
read_char:		.ascii		" "

