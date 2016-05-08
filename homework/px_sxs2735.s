/******************************************************************************
* @file px_sxs2735.s
* @brief simple get keyboard input of one integer number and populate a fixed-size
* integer array and perform operations
*
* Simple program of invoking syscall to retrieve one integer number n
* from keyboard, and populate a fixed-size integer array, then find the * sum, maximum and minimum number in the array.
* and then print them
*
* @author Suman Shrestha
*******************************************************************************/

.global main 
.func main

main:
    MOV R4, #0
    BL _writeArray

_writeArray:
    CMP R4, #10        @ if (i <10)
    BEQ writedone
    LDR R6, =a         @address of a_array
    LSL R7, R4, #2
    ADD R7, R6, R7
    BL _scanf          @ get user input
    MOV R5, R0         @ puts user input to R8
    STR R5, [R7]       @ a_array[i] = R8
    ADD R4, R4, #1     @ i++;
    B _writeArray
    
writedone:
    MOV R0, #0              @ i = 0
    
readloop:
    CMP R0, #10             @ check to see if we are done iterating
    BEQ readDone
    LDR R1, =a              @ get address of a
    LSL R2, R0, #2          @ multiply index*4 to get array offset
    ADD R2, R1, R2          @ R2 now has the element address
    LDR R1, [R2]            @ read the array at address
    PUSH {R0}               @ backup register before printf
    PUSH {R1}               @ backup register before printf
    PUSH {R2}               @ backup register before printf
    MOV R2, R1              @ move array value to R2 for printf
    MOV R1, R0              @ move array index to R1 for printf
    BL  _printf             @ branch to print procedure with return
    POP {R2}                @ restore register
    POP {R1}                @ restore register
    POP {R0}                @ restore register
    ADD R0, R0, #1          @ increment index
    B   readloop            @ branch to next loop iteration

readDone:
    MOV R0, #0		        @ re-initialize index variable
    LDR R1, =a      	    @ get the address of array
    LSL R2, R0, #2		    @ multiply index*4 to get array offset
    ADD R2, R1, R2	    	@ R2 now has the element address
    LDR R8, [R2]	    	@ store the first element in R3
    ADD R0, R0, #1	    	@ increase the index
    B   _getMin	        	@ branch to procedure _findMin to find minimum
	
_getMin:
    CMP R0, #10             @ check to see if we are done iterating
    BEQ minDone
    LDR R1, =a              @ get address of a
    LSL R2, R0, #2          @ multiply index*4 to get array offset
    ADD R2, R1, R2          @ R2 now has the element address
    LDR R1, [R2]            @ read the array at address
    CMP R1, R8              @ sum+= a_array[i]
    MOVLT R8, R1
    ADD R0, R0, #1          @ increment index
    B  _getMin              @ branch to next loop iteration

minDone:
    MOV R0, #0		        @ re-initialize index variable
    LDR R1, =a      	    @ get the address of array
    LSL R2, R0, #2		    @ multiply index*4 to get array offset
    ADD R2, R1, R2	    	@ R2 now has the element address
    LDR R9, [R2]	    	@ store the first element in R3
    ADD R0, R0, #1	    	@ increase the index
    B   _getMax	         	@ branch to procedure _findMin to find minimum
   
    
_getMax:
    CMP R0, #10             @ check to see if we are done iterating
    BEQ maxDone
    LDR R1, =a              @ get address of a
    LSL R2, R0, #2          @ multiply index*4 to get array offset
    ADD R2, R1, R2          @ R2 now has the element address
    LDR R1, [R2]            @ read the array at address
    CMP R1, R9              @ sum+= a_array[i]
    MOVGT R9, R1
    ADD R0, R0, #1          @ increment index
    B   _getMax             @ branch to next loop iteration
    
maxDone:
    MOV R0, #0		        @ re-initialize index variable
    LDR R1, =a      	    @ get the address of array
    LSL R2, R0, #2		    @ multiply index*4 to get array offset
    ADD R2, R1, R2	    	@ R2 now has the element address
    LDR R10, [R2]	    	@ store the first element in R3
    ADD R0, R0, #1	    	@ increase the index
    B   _getSum	         	@ branch to procedure _findMin to find minimum
	
_getSum:
    CMP R0, #10             @ check to see if we are done iterating
    BEQ sumDone
    LDR R1, =a              @ get address of a
    LSL R2, R0, #2          @ multiply index*4 to get array offset
    ADD R2, R1, R2          @ R2 now has the element address
    LDR R1, [R2]            @ read the array at address
    ADD R10, R10, R1        @ sum+= a_array[i]
    ADD R0, R0, #1          @ increment index
    B  _getSum              @ branch to next loop iteration

sumDone:
    MOV R1, R8
    MOV R2, R9
    MOV R3, R10
    BL _printResults
    B _exit

_scanf:
    PUSH {LR}               @ store LR since scanf call overwrites
    SUB SP, SP, #4          @ make room on stack
    LDR R0, =format_str     @ R0 contains address of format string
    MOV R1, SP              @ move SP to R1 to store entry on stack
    BL scanf                @ call scanf
    LDR R0, [SP]            @ load value at SP into R0
    ADD SP, SP, #4          @ restore the stack pointer
    POP {PC}

_exit:  
    MOV R7, #4              @ write syscall, 4
    MOV R0, #1              @ output stream to monitor, 1
    MOV R2, #21             @ print string length
    LDR R1, =exit_str       @ string at label exit_str:
    SWI 0                   @ execute syscall
    MOV R7, #1              @ terminate syscall, 1
    SWI 0                   @ execute syscall

_printf:
    PUSH {LR}               @ store LR since printf call overwrites
    LDR R0, =printf_str     @ R0 contains formatted string address
    BL printf               @ call printf
    POP {PC}                @ return

_printResults:
    PUSH {LR}               @ store LR since printf call overwrites
    LDR R0, =results        @ R0 contains formatted string address
    BL printf               @ call printf
    POP {PC}                @ return

.data

.balign 4
a:              .skip     40
printf_str:     .asciz    "array_a[%d] = %d\n"
format_str:     .asciz    "%d"
results: 	.ascii    "Minimum = %d\nMaximum = %d\nSum = %d\n"
exit_str:       .ascii    "Terminating program.\n"
