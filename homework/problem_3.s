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
    BEQ generatedone        @ exit loop if done
    LDR R1, =a              @ get address of a
    LSL R2, R0, #2          @ multiply index*4 to get array offset
    ADD R2, R1, R2          @ R2 now has the element address
    ADD R12, R3, R0
    STR R12, [R2]           @ write the value of R12 to a[i]
    ADD R11, R0, #1
    ADD R6, R3, R11
    MOV R8, #0
    SUB R6, R8, R6
    ADD R2, R2, #4
    STR R6, [R2]
    ADD R0, R0, #2          @ increment index
    B generate              @ branch to next loop iteration
generatedone:
    MOV R0, #0              @ initialze index variable
   @ MOV R6, #0
    @MOV R10, #0
    
    
_copy:
    CMP R0, #20           
    BEQ copyDone 
    LDR R1, =a  
    LSL R2, R0, #2     
    ADD R2, R1, R2     
    LDR R1, [R2]            @ load contents of a into R1
    LDR R3, =b              @ load b
    LSL R4, R0, #2         @ set the address
    ADD R4, R3, R4          @ add b address to R4
    MOV R5, R1
    ADD R0, R0, #1        @ increment the counter 
    STR R5, [R4]            @ store the contents of R5 into b
    B _copy           
    
copyDone:
    MOV R0, #0    
    MOV R10, #0
    
_sort:
    CMP R0, #20 
    BEQ sortDone 
    MOV R6, R0
    LDR R1, =b  
    LSL R2, R0, #2     
    ADD R2, R1, R2 
    LDR R1, [R2]            @ load contents of a into R1
    MOV R8, R1
    @ADD R6, R0, #1
    
_sorting:
    CMP R6, #20
    BEQ _sorted
    LDR R1, =b
    LSL R2, R6, #2     
    ADD R2, R1, R2 
    LDR R1, [R2]
    
    CMP R1, R5
    ADDEQ R6, R6, #1
    BEQ _sorting
    
    CMP R1, R8
    BLT _sorted
    @MOVLT R5, R8
    @MOVLT R8, R1
    @MOVLT R1, R5
    ADD R6, R6, #1
    B _sorting
    
_sorted:
    LDR R3, =b              @ load b
    LSL R4, R0, #2         @ set the address
    ADD R4, R3, R4          @ add b address to R4
    STR R8, [R2]
    STR R1, [R4]            @ store the contents of R5 into b
    MOV R5, R1
    ADD R0, R0, #1        @ increment the counter 
    B _sort           
    
sortDone:
    MOV R0, #0 
   
readLoop:
    CMP R0, #20             @ check to see if we are done iterating
    BEQ readLoopdone        @ exit loop if done
    LDR R1, =a              @ get address of a
    LSL R2, R0, #2          @ multiply index*4 to get array offset
    ADD R2, R1, R2          @ R2 now has the element address
    LDR R3, =b              @ load b
    LSL R4, R0, #2         @ set the address
    ADD R4, R3, R4 
    LDR R1, [R2]            @ read the array at address 
    LDR R3, [R4]
    PUSH {R0}               @ backup register before printf
    PUSH {R1}               @ backup register before printf
    PUSH {R2}   
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
printf_str:     .asciz      "array_a[%d] = %d, array_b = %d\n"
exit_str:       .ascii      "Terminating program.\n"
