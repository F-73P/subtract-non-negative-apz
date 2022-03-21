;v1.00

;subtract non-negative arbitrary-precision integers and save result to minuend  
;input: R0 = number of digits of minuend u, R1 = address of least significant digit of minuend u
;input: R2 = number of digits of subtrahend v, R3 = address of least significant digit of subtrahend v

;return value: R0 = number of digits of difference (1,2,...,number of digits of minuend)

            AREA subtract_apz_area,CODE,READONLY             
            EXPORT subtract_apz 

            ENTRY
subtract_apz   
            PUSH {R4,R5,R6,R7}
            
            CMP R0,R2
            BHI section_3
            BNE section_4            

            MOV R4,R0 ;otherwise minuend and subtrahend have the same number of digits, so compare starting from MS limb
			SUB R4,R4,#1			
			MOV R6,R1
			ADD R6,R6,R4,LSL#2 ;R6 = address of MS digit of minuend
			
			MOV R4,R2
			SUB R4,R4,#1			
			MOV R7,R3
			ADD R7,R7,R4,LSL#2 ;R7 = address of MS digit of minuend	
             
loop_4      CBZ R0,exit_2    
            LDR R4,[R6],#-4
            LDR R5,[R7],#-4
            CMP R4,R5
            BHI section_5
            BNE section_6    ;not equal implies digit of minuend is less than digit of subtrahend 
            SUB R0,R0,#1
            B loop_4
            
            ;;;;;;;;;;;;;;;;;;if u=v set minuend = 0,R0 = digits of difference = 1 and exit             
exit_2      MOV R0,#0     
            STR R0,[R1]
            MOV R0,#1
            
            POP {R4,R5,R6,R7}            
            BX lr
            ;;;;;;;;;;;;;;;;;;
            
            ;;;;;;;;;;;;;;;;;;minuend is greater than the subtrahend    
section_5   MOV R2,R0        ;reduce number of digits since leading digits of minuend and subtrahend = 0
            
section_3   MOV R7,R2
            LDR R4,[R1] ;R4 = least significant digit of minuend
            LDR R5,[R3],#4 ;R5 = least significant digit of subtrahend
            
            SUBS R4,R4,R5
            STR R4,[R1],#4
            SUB R2,R2,#1
loop_1      CBZ R2,section_1            
    
            LDR R4,[R1] ;R4 = next digit of minuend
            LDR R5,[R3],#4 ;R5 = next digit of subtrahend
            
            SBCS R4,R4,R5
            STR R4,[R1],#4
            SUB R2,R2,#1            
            B loop_1
            
section_1   SUB R2,R0,R7
loop_2      CBZ R2,section_2
            LDR R4,[R1]
            SBCS R4,R4,#0
            STR R4,[R1],#4
            SUB R2,R2,#1
            B loop_2
            
section_2   SUB R1,R1,#4     ;determine number of leading 0's in apz1
loop_3      LDR R4,[R1],#-4
            CBNZ R4,exit
            SUB R0,R0,#1
            B loop_3
       
exit        POP {R4,R5,R6,R7}
            BX lr
            
            ;;;;;;;;;;;;;;;;;;minuend is less than the subtrahend            
section_6   MOV R2,R0        ;reduce number of digits since leading digits of minuend and subtrahend = 0 
            
section_4   MOV R7,R0
            LDR R4,[R1] ;R4 = least significant digit of minuend
            LDR R5,[R3],#4 ;R5 = least significant digit of subtrahend
            
            SUBS R4,R5,R4 ;subtrahend - minuend since subtrahend > minuend
            STR R4,[R1],#4
            SUB R0,R0,#1
loop_1_2    CBZ R0,section_1_2            
    
            LDR R4,[R1] ;R4 = next digit of minuend
            LDR R5,[R3],#4 ;R5 = next digit of subtrahend
            
            SBCS R4,R5,R4 ;subtrahend - minuend since subtrahend > minuend
            STR R4,[R1],#4
            SUB R0,R0,#1            
            B loop_1_2
            
section_1_2 SUB R0,R2,R7
loop_2_2    CBZ R0,section_2_2
            LDR R4,[R3],#4
            SBCS R4,R4,#0
            STR R4,[R1],#4
            SUB R0,R0,#1
            B loop_2_2
            
section_2_2 SUB R1,R1,#4     ;determine number of leading 0's in apz1
loop_3_2    LDR R4,[R1],#-4
            CBNZ R4,exit_3
            SUB R2,R2,#1
            B loop_3_2
       
exit_3      LDR R1,=0x80000000     
            ORR R0,R2,R1     ;MSB of R0 set to indicate difference is negative      
            POP {R4,R5,R6,R7}
            BX lr            
            
            END