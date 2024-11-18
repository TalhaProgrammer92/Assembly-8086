; Assembly program to check whether a number is even or odd

.MODEL SMALL

.STACK 100H

.DATA
    NUM DW 75
    EVEN DB 'The number is even$'
    ODD DB 'The number is odd$'
    
    PRINT MACRO MSG
        MOV AH, 09H
        LEA DX, MSG
        INT 21H
    PRINT ENDM
    
    CHECK MACRO N
        MOV AX, N
        MOV BX, 2
        DIV BX
        INT 21H
    CHECK ENDM

.CODE
    MAIN PROC FAR
        MOV AX, @DATA
        MOV DS, AX
        
        ; Check the number
        CHECK NUM
        
        ; Show whether it is even or odd
        CMP DX, 0
        PRINT EVEN
        PRINT ODD
        
        ; Terminate
        MOV AH, 4CH
        INT 21H
    MAIN ENDP
END MAIN