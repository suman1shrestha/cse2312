      .global main 
      .func main

main:
  BL _prompt                  @branch to _prompt with return                 
  BL _scanf                   @branch to _scanf with return
  MOV R4, R0                  @move return value R0 to R6
  MOV R1, R0
  BL _fact                  @branch to _prompt with return
  MOV R1, R4
  MOV R2, R0
  BL _printf
  B _exit
  
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
  MOV R4, LR
  PUSH {LR}
  LDR R0, =printf_str
  MOV R1, #100
  MOV R2, #200
  BL printf
  POP {PC}
  MOV PC, R4
  
_scanf:
  MOV R4, LR
  SUB SP, SP, #4
  PUSH {LR}
  PUSH {R1}
  LDR R0, =format_str
  MOV R1, SP
  BL scanf
  LDR R0, [SP]
  ADD SP, SP, #4
  POP {R1}
  POP {PC}
  MOV PC, R4
  
_fact:
  PUSH {LR}
  CMP R1,#1
  MOVEQ R0, #1
  POPEQ {PC}
  
  CMP R1, #1
  MOVLT R0, #1
  
  CMP R2, #1
  MOVEQ R0, #1
  POPEQ {PC}
  
  PUSH {R1}
  
  MOV R0, R2
  MOV R2, R1
  SUB R1, R2, #1
  MOV R2, R0
  BL _fact
  
  POP {R1}
  
  SUB R2, R2, #1
  BL _fact
  MOV R10, R0
  POP {R0}
  ADD R0, R0, R8
  POP {PC}
   
.data
number:					.word 	  0
format_str:             .asciz    "%d"
prompt_str:             .ascii    "Enter a number and press result key: "
printf_str:             .asciz    "Therefore, the result is: %d\n"
exit_str:				.ascii 	  "Terminating program.\n"