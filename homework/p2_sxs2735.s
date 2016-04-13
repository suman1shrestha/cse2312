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
	BL _scanf              			@ branch to scanf prodecure with return
	MOV R11, R0            			@ move return value R0 to argument register R11
	MOV R1, R9             			@ move return value R9 to argument register R1
	MOV R2, R11            			@ move return value R11 to argument register R3
	BL count_partitions            			@ branch to compare prodecure with return
	MOV R8, R0             			@ move return value R0 to argument register R8
	BL _printf             			@ branch to printf prodecure with return
	B main                 			@ branch to main prodecure with no return

count_partitions:
	PUSH{LR}
	CMP R1, #0
	MOVEQ R0, #1
	POPEQ {PC}

	PUSH {R1}
	CMP R1, #0
	MOVLT R0, #0
	POPLT {PC}

	PUSH {R2}
	CMP R2, #0
	MOVEQ R0, #0
	POPEQ {PC}

	PUSH {LR}
	PUSH {R1}
	PUSH {R2}
	MOV R0, R2
	MOV R2, R1
	SUB R1, R0, #1
	BL count_partitions
	MOV R11, R0
	POP {R1}
	POP {R2}
	SUB R1, R1, R2
	BL count_partitions
	MOV R12, R0
	ADD R0, R11, R12
	POP {PC}

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
	MOV R4, LR 				@ store LR since printf call overwrites
	LDR R0, =print_str			@ R0 contains formatted string address
	MOV R1, R8				@ R8 contains printf argument (redundant line)
	BL printf 				@ call printf
	MOV PC, R4				@ return


.data
format_str:		.asciz		"%d"
print_str:		.asciz		"There are %d partitions of %d using integers up to %d\n"

