; Program to print a string in reverse order

.MODEL SMALL

.STACK 100H

.DATA
    msg DB 'Hello World$'   ; String
    length EQU $-msg        ; Length of the string 'msg'
    
    ; Macro to print a character
    PRINT MACRO chr
        MOV AH, 02H
        MOV DL, chr
        INT 21H
    PRINT ENDM

.CODE
    MAIN PROC FAR
        MOV AX, @DATA
        MOV DS, AX
        
        ; Process
        MOV SI, length
        SUB SI, 2
        AGAIN:
            PRINT msg[SI]
            DEC SI
            CMP SI, 0
            JGE AGAIN       ; Is SI >= 0?
        
        ; Terminate the program
        MOV AH, 4CH
        INT 21H
        
    MAIN ENDP
END MAIN
