      .global main 
      .func main

main:
  @BL _prompt                  @branch to _prompt with return                 
  BL _scanf                   @branch to _scanf with return
  MOV R10, R0                  @move return value R0 to R6
  MOV R8, R0
  BL _scanf
  MOV R5, R0
  MOV R9, R0
  MOV R1, R8
  MOV R2, R9
  BL _fact                  @branch to _prompt with return
  MOV R1, R0
  MOV R2, R10
  MOV R3, R5
  BL _printf
  B main
  
_exit:
  MOV R7, #4
  MOV R0, #1
  MOV R2, #21
  LDR R1, = exit_str
  SWI 0
  MOV R7, #1
  SWI 0

_prompt:               
  PUSH {R1}
  PUSH {R2}
  PUSH {R7}
  MOV R7, #4                  @write syscall, 4            
  MOV R0, #1                  @output stream to monitor, 1
  MOV R2, #37                 @print string length
  LDR R1, =prompt_str     
  SWI 0                       @execute syscall    
  POP {R7}
  POP {R2}
  POP {R1}
  MOV PC, LR                  @return  

_printf:
  PUSH {LR}
  LDR R0, =printf_str
  BL printf
  POP {PC}
  
_scanf:
  PUSH {LR}
  SUB SP, SP, #4
  LDR R0, =format_str
  MOV R1, SP
  BL scanf
  LDR R0, [SP]
  ADD SP, SP, #4
 POP {PC}
  
_fact:
  PUSH {LR}
  CMP R1, #0
  MOVEQ R0, #1
  POPEQ {PC}
  
  CMP R1, #0
  MOVLT R0, #1
  POPLT {PC}
  
  CMP R2, #0
  MOVEQ R0, #0
  POPEQ {PC}
  
  PUSH {R1}
  PUSH {R2}
  SUB R1, R2, #1
  BL _fact
  MOV R6, R0
  POP {R2}
  POP {R1}
  
  PUSH {R1}
  PUSH {R2}
  PUSH {R6}
  SUB R1, R1, R2
  BL _fact
  POP {R6}
  POP {R2}
  POP {R1}
  ADD R6, R6, R0
  MOV R0, R6
  POP {PC}
   
.data
number:					.word 	  0
format_str:             .asciz    "%d"
prompt_str:             .ascii    "Enter a number and press result key: "
printf_str:             .asciz    "Therefore, %d with %d and %d\n"
exit_str:				.ascii 	  "Terminating program.\n"
