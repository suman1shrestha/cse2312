/*************************************************************************
* @file calculator.s
* @brief simple get keyboard character and compare
*
* Simple program of invoking syscall to retrieve a char and two integerd * numbers from keyboard, 
* and perform the desired operation 
*
* @author Sosal Pokhrel   ID:1001202713
*************************************************************************/

	.global main
	.func main

main:
	BL _scanf				@ branch to scanf prodecure with return
	MOV R9, R0				
	BL getchar
	MOV R10, R0
	BL _scanf
	MOV R8, R0
	MOV R1, R9
	MOV R2,	R10
	MOV R3, R8
	BL comparing
	MOV R12, R0
	BL printing
	B main

getchar:
	MOV R7, #3 				@ writing syscall, 4
	MOV R0, #0				@ output the stream to the monitor, 1
	MOV R2, #1				@ reading a single character
	LDR R1, =read_char		@ storing the character in data memory
	SWI 0					@ executing the system call
	LDR R0, [R1]			@ moveing the character to the return register
	AND R0, #0xFF			@ mask out all but the lowest 8 bits
	MOV PC, LR 				@ return




comparing:
	MOV R4, LR
	CMP R2, #'+'			@ comparing against the constant char '+'
	BLEQ adding				@ branch to make equal handler
	CMP R2, #'-'			@ comparing against the constatn char '-'
	BLEQ subtracting				@ branch to equal handler
	CMP R2, #'*'			@ compare against the constatn char '*'
	BLEQ multiplying				@ branch to equal handler
	CMP R2, #'M'			@ compare against the constatn char 'M'
	BLEQ maximize				@ branch to equal handler
	MOV PC, R4
	
	
_scanf:
	MOV R4, LR 				@ store LR since scanf call overwrites
	SUB SP, SP, #4			@ make romm on stack
	LDR R0, =format_str		@ R0 contains address of format string
	MOV R1, SP 				@ move SP to R1 to store entry on stack
	BL scanf 				@ call scanf
	LDR R0, [SP]  			@ load value at SP into R0
	ADD SP, SP, #4			@ restore the stack pointer
	MOV PC, R4				@ return



printing:
	MOV R4, LR 				@ store LR since printf call overwrites
	LDR R0, =print_str		@ R0 contains formatted string address
	MOV R1, R12				@ R8 contains printf argument (redundant line)
	BL printf 				@ call printf
	MOV PC, R4				@ return

adding: 
	ADD R0, R1, R3				
	MOV PC, LR

subtracting:
	SUB R0, R1, R3
	MOV PC, LR

multiplying:
	MUL R0, R1, R3
	MOV PC, LR

maximize:
	CMP R1, R3
	MOVGT R0, R1
	MOVLT R0, R3
	MOV PC, LR


.data
format_str:		.asciz		"%d"
read_char:		.ascii		" "
print_str:		.asciz		"%d\n"

