/******************************************************************************
* @file count_partitions.s
* @brief simple get keyboard input of two integers and count the partitions
*
* Simple program of invoking syscall to retrieve two integer numbers n and m 
* from keyboard, and count the number of integer partitions of a positive 
* integer n with parts up to m
*
* @author Suman Shrestha
*******************************************************************************/

	.global main
	.func main

main:
	BL _scanf				@ branch to scanf prodecure with return
	MOV R9, R0				@ move return value R0 to argument register R9
	MOV R5, R0				@ store n in R5
	BL _scanf              			@ branch to scanf prodecure with return
	MOV R10, R0            			@ move return value R0 to argument register R10
	MOV R6, R0				@ store n in R6
	MOV R1, R9             			@ move return value R9 to argument register R1
	MOV R2, R10            			@ move return value R10 to argument register R2
	BL count_partitions            		@ branch to count_partitions prodecure with return
	MOV R1, R0				@ pass result to printf procedure
	MOV R2, R5				@ pass n to printf procedure
	MOV R3, R6             			@ pass m to printf procedure
	BL _printf             			@ branch to printf prodecure with return
	B main                 			@ branch to main prodecure with no return

count_partitions:
	PUSH {LR}				@ store the return address
	CMP R1, #0				@ if (n == 0)
	MOVEQ R0, #1				@ R0 = 1
	POPEQ {PC}				@ return R0

	CMP R1, #0				@ else if (n<0)
	MOVLT R0, #0				@ R0 = 0
	POPLT {PC}				@ return R0

	CMP R2, #0				@ else if (m == 0)
	MOVEQ R0, #0				@ R0 = 0
	POPEQ {PC}				@ return R0
	
	@ For Recursion
	PUSH {R1}				@ backup input argument value, n
	PUSH {R2}				@ backup input argument value, m
	SUB R2, R2, #1				@ (m-1) into R2
	BL count_partitions			@ compute count_partitions(n,m-1)
	MOV R11, R0				@ store the result in R11
	POP {R2}				@ restore the input argument, m
	POP {R1}				@ restore the input argument, n
	PUSH {R1}				@ backup the input argument, n
	PUSH {R2}				@ backup the input argument, m
	PUSH {R11}				@ backup the result from count_partitions(n,m-1)
	SUB R1, R1, R2				@ (n-m) into R1
	BL count_partitions			@ compute count_partitions(n-m,m)
	POP {R11}				@ restore the result from count_partitions(n,m-1)
	POP {R2}				@ restore the input argument, m
	POP {R1}				@ restore the input argument, n
	ADD R11, R11, R0			@ compute count_partitions(n-m,m) + count_partitions(n,m-1)
	MOV R0, R11				@ move the return result to R0
	POP {PC}				@ restore the stack pointer and return

_scanf:
	MOV R4, LR 				@ store LR since scanf call overwrites
	SUB SP, SP, #4				@ make romm on stack
	LDR R0, =format_str			@ R0 contains address of format string
	MOV R1, SP 				@ move SP to R1 to store entry on stack
	BL scanf 				@ call scanf
	LDR R0, [SP]  				@ load value at SP into R0
	ADD SP, SP, #4				@ restore the stack pointer
	MOV PC, R4				@ return

_printf:
	PUSH {LR} 				@ store LR since printf call overwrites
	LDR R0, =print_str			@ R0 contains formatted string address
	@MOV R1, R8				@ R8 contains printf argument (redundant line)
	BL printf 				@ call printf
	POP {PC}				@ return


.data
format_str:		.asciz		"%d"
print_str:		.asciz		"There are %d partitions of %d using integers up to %d\n"

