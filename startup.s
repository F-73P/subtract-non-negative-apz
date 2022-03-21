           AREA STACK,NOINIT,READWRITE,ALIGN=3

Stack_Size EQU 0x00000401
               
__stack_limit
Stack_Mem SPACE Stack_Size
__initial_sp

; Vector Table Mapped to Address 0 at Reset
           AREA RESET,DATA,READONLY
			   
           EXPORT __Vectors
           EXPORT __Vectors_End
           EXPORT __Vectors_Size
	 
__Vectors DCD __initial_sp ; Top of Stack
          DCD Reset_Handler ; Reset Handler
       
__Vectors_End

__Vectors_Size EQU __Vectors_End - __Vectors
	
            AREA |.text|, CODE, READONLY
Reset_Handler   PROC
            EXPORT Reset_Handler [Weak]
            IMPORT __main
            LDR R0, =__main
            BX  R0
            ENDP
				
            EXPORT __stack_limit
            EXPORT __initial_sp

            END