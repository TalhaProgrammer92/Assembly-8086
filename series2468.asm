; Assembly program to print the seires: 2 4 6 8 (16-bit)

.MODEL SMALL

.STACK 100H

.DATA
    NUM DB 2
    
    NEWLINE MACRO
        MOV DL, 0DH
        MOV AH, 02H
        INT 21H
        
        MOV DL, 0AH
        MOV AH, 02H
        INT 21H
    NEWLINE ENDM

.CODE
    MAIN PROC FAR
        MOV AX, @DATA
        MOV DS, AX
        
        ; Loop
        MOV CX, 5
        AGAIN:
            MOV DL, NUM
            ADD DL, 48
            MOV AH, 02H
            INT 21H
            
            NEWLINE
            
            ADD NUM, 2
            
            LOOP AGAIN
        
        ; Terminate the program
        MOV AH, 4CH
        INT 21H
    
        MAIN ENDP
    END MAIN
