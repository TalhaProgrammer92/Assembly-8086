; Program to print a string in reverse order

.MODEL SMALL

.STACK 100H

.DATA
    msg DB 'Hello World$'   ; String
    length equ $-msg        ; Length of the string 'msg'

.CODE
    MAIN PROC FAR
        MOV AX, @DATA
        MOV DS, AX
        
        ; Process
        MOV SI, length
        SUB SI, 2
        AGAIN:
            MOV AH, 02H
            MOV DL, msg[SI]
            INT 21H
            DEC SI
            MOV AX, SI
            MOV DX, 0
            CMP AX, DX
            JGE AGAIN
        
        ; Exit
        MOV AH, 4CH
        INT 21H
        
    MAIN ENDP
END MAIN