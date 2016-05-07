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
    MOV R0, #0
    MOV R3, #0
    BL _generate
    MOV R8, R0
    LDR R0, =printf_str
    MOV R1, R8
    BL _printMyArray
    MOV R1, R0
    BL _printAdd
    BL _getMax
    MOV R1, R0
    BL _printAdd
    BL _getSum
    MOV R1, R0
    BL _printAdd
    BL _exit


_generate:
    PUSH {LR}
    
    MOV R4, #0         @ i = 0
    writeloop:
    CMP R4, #10        @ if (i <10)
    POPEQ {PC}         @ if R3 = 10, leave
    LDR R6, =a_array   @address of a_array
    LSL R7, R4, #2
    ADD R7, R6, R7
    BL _scanf          @ get user input
    MOV R5, R0         @ puts user input to R8
    STR R5, [R7]       @ a_array[i] = R8
    ADD R4, R4, #1     @ i++;
    
    B writeloop
    

#27
_exit:  
    MOV R7, #4              @ write syscall, 4
    MOV R0, #1              @ output stream to monitor, 1
    MOV R2, #21             @ print string length
    LDR R1, =exit_str       @ string at label exit_str:
    SWI 0                   @ execute syscall
    MOV R7, #1              @ terminate syscall, 1
    SWI 0                   @ execute syscall


#38
#47
_printf:
    PUSH {LR}               @ store LR since printf call overwrites
    LDR R0, =printf_str     @ R0 contains formatted string address
    MOV R1, R1              @ (used to be R3 instead)R1 contains printf argument (redundant line)
    MOV R2, R2
    MOV R3, R3
    BL printf               @ call printf
    POP {PC}                @ return
#54
_printAdd:
    PUSH {LR}               @ store LR since printf call overwrites
    LDR R0, =printf_Add     @ R0 contains formatted string address
    MOV R1, R1              @
    BL printf               @ call printf
    POP {PC}                @ return



#80
_printMyArray:
    PUSH {LR}
    BL _getMax
    MOV R8, R0
    MOV R0, #0              @ i = 0

    readloop:
    CMP R0, #10             @ check to see if we are done iterating
    MOVEQ R0, R8
    POPEQ {PC}              @ exit loop if done
    LDR R1, =a_array        @ get address of a
    LSL R2, R0, #2          @ multiply index*4 to get array offset
    ADD R2, R1, R2          @ R2 now has the element address
    LDR R1, [R2]            @ read the array at address
    PUSH {R0}               @ backup register before printf
    PUSH {R1}               @ backup register before printf
    PUSH {R2}               @ backup register before printf
    MOV R2, R1              @ move array value to R2 for printf
    MOV R1, R0              @ move array index to R1 for printf
    CMP R2, R8              @ sum+= a_array[i]
    MOVLT R8, R2
    BL  _printf             @ branch to print procedure with return
    POP {R2}                @ restore register
    POP {R1}                @ restore register
    POP {R0}                @ restore register
    ADD R0, R0, #1          @ increment index
    B   readloop            @ branch to next loop iteration
    
_getMax:
    PUSH {LR}
    MOV R0, #0              @ i = 0
    MOV R9, #0              @ max = 0

    maxloop:
    CMP R0, #10             @ check to see if we are done iterating
    MOVEQ R0, R9
    POPEQ {PC}              @ exit loop if done
    LDR R1, =a_array        @ get address of a
    LSL R2, R0, #2          @ multiply index*4 to get array offset
    ADD R2, R1, R2          @ R2 now has the element address
    LDR R1, [R2]            @ read the array at address
    CMP R1, R9              @ sum+= a_array[i]
    MOVGT R9, R1
    ADD R0, R0, #1          @ increment index
    B   maxloop             @ branch to next loop iteration

_getSum:
    PUSH {LR}
    MOV R0, #0              @ i = 0
    MOV R9, #0              @ max = 0

    minloop:
    CMP R0, #10             @ check to see if we are done iterating
    MOVEQ R0, R9
    POPEQ {PC}              @ exit loop if done
    LDR R1, =a_array        @ get address of a
    LSL R2, R0, #2          @ multiply index*4 to get array offset
    ADD R2, R1, R2          @ R2 now has the element address
    LDR R1, [R2]            @ read the array at address
    ADD R9, R9, R1          @ sum+= a_array[i]
    ADD R0, R0, #1          @ increment index
    B   minloop             @ branch to next loop iteration

_scanf:
    PUSH {LR}               @ store LR since scanf call overwrites
    SUB SP, SP, #4          @ make room on stack
    LDR R0, =format_str     @ R0 contains address of format string
    MOV R1, SP              @ move SP to R1 to store entry on stack
    BL scanf                @ call scanf
    LDR R0, [SP]            @ load value at SP into R0
    ADD SP, SP, #4          @ restore the stack pointer
    POP {PC}




.data

.balign 4
a_array:              .skip     40
printf_str:     .asciz    "a_array[%d] = %d\n"
printf_Add:     .asciz    "sum = %d\n"
format_str:     .asciz    "%d"
prompt_str:      .ascii   "Enter the @ character: "
exit_str:       .ascii    "Terminate program.\n"
