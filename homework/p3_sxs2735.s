/******************************************************************************
* @file p3_sxs2735.s
* @brief simple get keyboard input of one integer number and populate a fixed-size
* integer array
*
* Simple program of invoking syscall to retrieve one integer number n
* from keyboard, and populate a fixed-size integer array, then sort the array
* and then print them
*
* @author Suman Shrestha
*******************************************************************************/

	.global main
	.func main
	
main:
    BL _scanf		    @ branch to scanf procedure with return, n
    MOV R9, R0		    @ move return value R0 to temporary register R9
    MOV R3, R9		    @ move return value R0 to argument register R3
    MOV R0, #0              @ initialze index variable, i
    
generate:
    CMP R0, #20             @ check to see if we are done iterating
    BEQ generatedone        @ branch to generatedone procedure
    LDR R1, =a              @ get address of a
    LSL R2, R0, #2          @ multiply index*4 to get array offset
    ADD R2, R1, R2          @ R2 now has the element address
    ADD R12, R3, R0	    @ compute (n+i) and store in R12
    STR R12, [R2]           @ write the value of R12 to a[i]
    ADD R11, R0, #1	    @ compute (i+1) and store in R11
    ADD R6, R3, R11         @ computer (n+i+1) and store the vaue in R6
    MOV R8, #0		    @ store the value 0 into R8
    SUB R6, R8, R6	    @ compute 0-(n+i+1) and store into R6
    ADD R2, R2, #4	    @ R2 now has the address (i+1)
    STR R6, [R2]	    @ store the value of R6 to a[i+1]
    ADD R0, R0, #2          @ increment index, i=i+2
    B generate              @ branch to next loop iteration
    
generatedone:
    MOV R0, #0              @ initialze index variable
    
_copy:
    CMP R0, #20             @ check to see if we are done iterating
    BEQ copyDone            @ branch to copyDone procedure
    LDR R1, =a  	    @ get address of a
    LSL R2, R0, #2          @ multiply index*4 to get array offset
    ADD R2, R1, R2          @ R2 now has the element address
    LDR R1, [R2]            @ load contents of a into R1
    LDR R3, =b              @ get address of b
    LSL R4, R0, #2          @ multiply index*4 to get array offset
    ADD R4, R3, R4          @ R4 now has the element address
    ADD R0, R0, #1          @ increment the counter 
    STR R1, [R4]            @ store the contents of R1 into b
    B _copy           	    @ branch to next loop iteration
    
copyDone:
    MOV R0, #0    	    @ initialze index variable, i
    
_sort:
    CMP R0, #20  	    @ check to see if we are done iterating	
    BEQ sortDone 	    @ branch to sortDone procedure
    MOV R6, R0		    @ initialze index variable, j = i
    LDR R1, =b  	    @ get address of b
    LSL R2, R0, #2          @ multiply index*4 to get array offset
    ADD R2, R1, R2 	    @ R2 now has the element address
    LDR R1, [R2]            @ load contents of b into R1
    MOV R8, R1		    @ get the value of b[i] to R8
    
_sorting:
    CMP R6, #20		    @ check to see if we are done iterating inner loop with variable j
    BEQ _sorted		    @ branch to sorted procedure
    LDR R1, =b		    @ get address of b
    LSL R2, R6, #2          @ multiply index*4 to get array offset
    ADD R2, R1, R2 	    @ R2 now has the element address, b[j]
    LDR R1, [R2]	    @ load contents of b[j] into R1
    CMP R1, R8		    @ compare the value at b[j] with b[i]
    BLT _swap		    @ branch to swap procedure if b[j] is smaller
    ADD R6, R6, #1	    @ increment the counter, j=j+1
    B _sorting		    @ branch to sorting procedure
    
_swap:
    LDR R3, =b              @ get address of b
    LSL R4, R0, #2          @ multiply index*4 to get array offset
    ADD R4, R3, R4          @ R4 now has the element address, b[i]
    STR R8, [R2]	    @ Store the value at b[j] into b[i]
    STR R1, [R4]            @ Store the value at b[i] into b[j]
    B _sort
    
_sorted:
    ADD R0, R0, #1          @ increment the counter, i=i+1
    B _sort                 @ branch to sort procedure
    
sortDone:
    MOV R0, #0 		    @ initialze index variable
   
readLoop:
    CMP R0, #20             @ check to see if we are done iterating
    BEQ readLoopdone        @ exit loop if done
    LDR R1, =a              @ get address of a
    LSL R2, R0, #2          @ multiply index*4 to get array offset
    ADD R2, R1, R2          @ R2 now has the element address
    LDR R3, =b              @ load b
    LSL R4, R0, #2          @ set the address
    ADD R4, R3, R4 	    @ R4 now has the element address for b
    LDR R1, [R2]            @ read the value of array a at address 
    LDR R3, [R4]	    @ read the value of array b at address 
    PUSH {R0}               @ backup register before printf
    PUSH {R1}               @ backup register before printf
    PUSH {R2}   	    @ backup register before printf
    PUSH {R3}		    @ backup register before printf
    MOV R2, R1              @ move array value to R2 for printf
    MOV R1, R0              @ move array index to R1 for printf
    
    BL  _printf 
    POP {R3}		    @ branch to print procedure with return
    POP {R2}                @ restore register
    POP {R1}                @ restore register
    POP {R0}                @ restore register
    ADD R0, R0, #1          @ increment index
    B   readLoop            @ branch to next loop iteration
readLoopdone:
    B _exit                 @ exit if done
    
_scanf:
    PUSH {LR} 		    @ store LR since scanf call overwrites
    SUB SP, SP, #4	    @ make romm on stack
    LDR R0, =format_str	    @ R0 contains address of format string
    MOV R1, SP 	            @ move SP to R1 to store entry on stack
    BL scanf 		    @ call scanf
    LDR R0, [SP]            @ load value at SP into R0
    ADD SP, SP, #4	    @ restore the stack pointer
    POP {PC}		    @ return
	
_exit:  
    MOV R7, #4              @ write syscall, 4
    MOV R0, #1              @ output stream to monitor, 1
    MOV R2, #21             @ print string length
    LDR R1, =exit_str       @ string at label exit_str:
    SWI 0                   @ execute syscall
    MOV R7, #1              @ terminate syscall, 1
    SWI 0                   @ execute syscall
       
_printf:
    PUSH {LR}               @ store the return address
    LDR R0, =printf_str     @ R0 contains formatted string address
    BL printf               @ call printf
    POP {PC}                @ restore the stack pointer and return
   
.data

.balign 4
a:              .skip       80
b:	.skip		    80
format_str:		    .asciz		  "%d"
printf_str:     .asciz      "array_a[%d] = %4d,\t array_b = %d\n"
exit_str:       .ascii      "Terminating program.\n"
