      .global main 
      .func main

main:
  @BL _prompt                  @branch to _prompt with return                 
  BL _scanf                   @branch to _scanf with return
  MOV R10, R0                  @move return value R0 to R6
  MOV R11, R0
  BL _scanf
  MOV R5, R0
  MOV R9, R0
  MOV R1, R10
  MOV R2, R5
  BL _fact                  @branch to _prompt with return
  MOV R1, R0
  MOV R2, R11
  MOV R3, R9
  BL _printf
  B main
  

_printf:
  PUSH {LR}
  LDR R0, =printf_str
  BL printf
  POP {PC}
  
_scanf:
  MOV R4, LR
  SUB SP, SP, #4
  LDR R0, =format_str
  MOV R1, SP
  BL scanf
  LDR R0, [SP]
  ADD SP, SP, #4
  MOV PC, R4
  
_fact:
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
	BL _fact			@ compute count_partitions(n,m-1)
	MOV R11, R0				@ store the result in R11
	POP {R2}				@ restore the input argument, m
	POP {R1}				@ restore the input argument, n
	PUSH {R1}				@ backup the input argument, n
	PUSH {R2}				@ backup the input argument, m
	PUSH {R11}				@ backup the result from count_partitions(n,m-1)
	SUB R1, R1, R2				@ (n-m) into R1
	BL _fact			@ compute count_partitions(n-m,m)
	POP {R11}				@ restore the result from count_partitions(n,m-1)
	POP {R2}				@ restore the input argument, m
	POP {R1}				@ restore the input argument, n
	ADD R11, R11, R0			@ compute count_partitions(n-m,m) + count_partitions(n,m-1)
	MOV R0, R11				@ move the return result to R0
	POP {PC}				@ restore the stack pointer and return
   
.data
format_str:             .asciz    "%d"
@prompt_str:             .ascii    "Enter a number and press result key: "
printf_str:             .asciz    "Therefore, %d with %d and %d\n"
@exit_str:				.ascii 	  "Terminating program.\n"
