@ author: Apekchya Shrestha @ UTA id: 1001202364 @ Program 1

.global main
.func main

main:
    BL _scanf	             @ branch to scanf with return
    MOV R10, R0	             @ move return value to R10
    BL _getchar	             @ get character from the user
    MOV R8, R0               @ move return value to R8
    BL _scanf	             @ branch to scanf with return 
    MOV R9, R0	             @ move return value to R9
    MOV R1, R10              @ move the content from R10 to R1
    MOV R2, R8	             @ move the content from R8 to R2
    MOV R3 ,R9 	             @ move the content from R9 to R3
    BL _compare	             @ branch to compare
    MOV R3, R0	             @ move content from R0 to R3
    BL _printf	             @ branch to printf
    B main

_scanf:
    MOV R7, LR              @ move LR to R7
    SUB SP, SP, #4          @ make room on the stack
    LDR R0, =format_str		@ R0 has the address of format string
    MOV R1, SP              @ move the content of SP to R1
    BL scanf                @ call scanf
    LDR R0, [SP]            @ load the content of SP in R0
    ADD SP, SP, #4          @restore stack pointer
    MOV PC, R7              @ return

_getchar:
    MOV R4, #3              @ write syscall, 3
    MOV R0, #0              @ input stream from the monitor, 0
    MOV R2, #1              @ read a single character
    LDR R1, =read_char      @ store the character in the data memory..
    SWI 0                   @ execute the system call
    LDR R0, [R1]            @ move the character to the return...
    AND R0, #0xFF           @ mask out all but the lowest 8 bi..
    MOV PC, LR              @ return

_compare:
    MOV  R7, LR		@ store LR since printf call overwrites
	CMP  R2, #'+'	@ compare with "+" 
	BLEQ _add		@ branch and link if equal to "+"
	CMP  R2, #'-'	@ compare with "-"
    BLEQ _subt		@ branch and link if equal to "-"
	CMP  R2, #'*'	@ compare with "*" 
    BLEQ _multp		@ branch and link if equal to "*"
	CMP  R2, #'M'	@ compare with "M" char
    BLEQ _max		@ branch and link if equal to "M"
	MOV  PC, R7  	@ return
    
_printf:
    MOV R7, LR              @ store LR since printf call overwrites
    LDR R0, =printf_str     @ R0 contains formatted string address
	MOV R1, R5              @ R1 contains printf argument (redundant li$
    BL  printf              @ call printf
    MOV PC, R7              @ return     


_add:
    ADD R0, R1, R3	@ store the sum of R1 and R3 in R0
    MOV PC, LR		@ return

_subt:
    SUB R0, R1, R3	@ store the difference in R0
    MOV PC, LR		@ return

_multp:
    MUL R0, R1, R3	@ store the product of R1 and R3 in R0
    MOV PC, LR		@ return

_max:
    CMP   R1, R3    @ compare R1 and R3
    MOVGT R0, R1	@ move R1 to R0 if it is greater
    MOVLT R0, R3 	@ move R3 to R0 if it is less
    MOV   PC, LR	@ return


.data
format_num: .asciz        "%d"
read_char:      .ascii    "  "
printf_str:     .asciz    "%d\n"
