; Program to count and display number of characters in a string

.MODEL SMALL
.STACK 100H
.DATA
    str DB 'This is a string$'
    length DW 0
.CODE
    MAIN PROC FAR
        MOV AX, @DATA
        MOV DS, AX
        
        ; Count
        MOV SI, 0
        AGAIN:
            INC length
            INC SI
            CMP str[SI], '$'
            JNE AGAIN
        
        ; Display
        MOV AX, length      ; Moves value of 'length' to AX
        MOV BX, 10          ; To divide the AX with BX
        MOV CX, 0           ; Set up the loop count
        
        PUSHL:              ; Pushing onto stack
            CMP AX, 0
            JE POPL
            INC CX
            MOV DX, 0       ; Clear DX for unsigned division
            DIV BX          ; Divide by 10
            ADD DL, '0'     ; Convert remainder to ASCII digit
            PUSH DX
            JMP PUSHL
        POPL:               ; Print the digits
            CMP CX, 0
            JE EXIT
            DEC CX
            POP DX
            MOV AH, 02h
            INT 21h
            JMP POPL
        
        EXIT:
            MOV AH, 4CH
            INT 21H
    MAIN ENDP
END MAIN