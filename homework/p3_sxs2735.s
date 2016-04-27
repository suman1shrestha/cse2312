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
    BL _scanf
    MOV R9, R0
    MOV R3, R9
    MOV R0, #0              @ initialze index variable
    
generate:
    CMP R0, #20             @ check to see if we are done iterating
    BEQ generatedone           @ exit loop if done
    LDR R1, =a              @ get address of a
    LSL R2, R0, #2          @ multiply index*4 to get array offset
    ADD R2, R1, R2          @ R2 now has the element address
    ADD R5, R3, R0
    STR R5, [R2]              @ write the address of a[i] to a[i]
    ADD R4, R0, #1
    ADD R6, R3, R4
    MOV R8, #0
    SUB R6, R8, R6
    ADD R2, R2, #4
    STR R6, [R2]
    ADD R0, R0, #2          @ increment index
    B generate              @ branch to next loop iteration
generatedone:
    MOV R0, #0              @ initialze index variable
    
_sort:
    CMP R0, #20            @ condition to stop
    MOVEQ R0, #0            @ reset R0 back to zero after finding the first lowest integer
    LDR R1, =a_array            @ load a_array
    LSL R2, R0, #2            @ set the address
    ADD R2, R1, R2            @ add a_array address to R2
    LDR R1, [R2]            @ load contents of a_array into R1
    LDR R3, =b_array            @ load b_array
    LSL R4, R10, #2            @ set the address
    ADD R4, R3, R4            @ add b_array address to R4
    CMP R5, R1            @ compare R5 to R1
    MOVGT R5, R1            @ if R5 is greater than R1, move the contents of R1 into R5
    ADDGT R0, R0, #1            @ increment counter
    BGT _sort_ascending            @ re-enter the sort function
    CMP R5, R1            @ compare R5 to R1
    ADDLT R0, R0, #1            @ increment the counter if R5 is less than R1
    BLT _sort            @ re-enter the sort function
    CMP R10, #20            @ compare R10 with 20
    BEQ writedone_1            @ if R10 is equal to 20 exit the sort function
    ADD R10, R10, #1            @ increment R10 by one
    STR R5, [R4]            @ store the contents of R5 into b_array

readLoop:
    CMP R0, #20             @ check to see if we are done iterating
    BEQ readLoopdone           @ exit loop if done
    LDR R1, =a              @ get address of a
    LSL R2, R0, #2          @ multiply index*4 to get array offset
    ADD R2, R1, R2          @ R2 now has the element address
    LDR R1, [R2]            @ read the array at address 
    LDR R3, [R4]
    PUSH {R0}               @ backup register before printf
    PUSH {R1}               @ backup register before printf
    PUSH {R2}   
    PUSH {R3}		@ backup register before printf
    MOV R2, R1              @ move array value to R2 for printf
    MOV R1, R0              @ move array index to R1 for printf
    BL  _printf 
    POP {R3}		@ branch to print procedure with return
    POP {R2}                @ restore register
    POP {R1}                @ restore register
    POP {R0}                @ restore register
    ADD R0, R0, #1          @ increment index
    B   _sort            @ branch to next loop iteration
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
a:              .skip       400
format_str:		  .asciz		  "%d"
printf_str:     .asciz      "array_a[%d] = %d\n"
exit_str:       .ascii      "Terminating program.\n"
