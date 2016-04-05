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
	MOV R1, #5
	MOV R2, #10
	BL _add					@ call _add
	B _exit					@ branch to exit procedure with no return

_prompt: 
	MOV R7, #4				@ write syscall, 4
	MOV R0, #1				

_compare:
	CMP R1, #'+'			@ compare against the constant char '+'
	BEQ _add				@ branch to equal handler
	CMP R1, #'-'			@ compare against the constatn char '-'
	BEQ _sub				@ branch to equal handler
	CMP R1, #'*'			@ compare against the constatn char '*'
	BEQ _mult				@ branch to equal handler
	CMP R1, #'M'			@ compare against the constatn char 'M'
	BEQ _max				@ branch to equal handler

_add: 
	ADD R0, R1, R2
	MOV PC, LR

_exit:
	MOV R7, #4				@ write syscall, 4
	MOV R0, #1				@ ouput stream to monitor, 1
	MOV R2, #21 			@ print string length
	LDR R1, =exit_str		@ string at label exit_str:
	SWI 0					@ execute syscall
	MOV R7, #1				@ termiante syscall, 1
	SWI 0					@ excute syscall

.data
num_str:		.ascii		"Enter the operand: " 19
prompt_str:		.ascii		"Enter the operation_code: " 26
