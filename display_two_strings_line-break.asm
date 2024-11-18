; Program to print 2 strings in different lines

.MODEL SMALL

.STACK 100H

.DATA
    S1 DB '1st line$'
    S2 DB '2nd line$'
    
    ; Macro to print a string
    PRINT MACRO string
        MOV AH, 09H
        LEA DX, string
        INT 21H
    PRINT ENDM
    
    ; Macro for new line character i.e. line break
    ENDL MACRO
        ; Line-break
        MOV DL, 0DH
        MOV AH, 02H
        INT 21H
        ; Move the cursor to the starting point of (new) line
        MOV DL, 0AH
        MOV AH, 02H
        INT 21H
    ENDL ENDM

.CODE
    MAIN PROC FAR
        MOV AX, @DATA
        MOV DS, AX
        
        ; Display strings
        PRINT S1
        ENDL
        PRINT S2
        
        MOV AH, 4CH
        INT 21H
    MAIN ENDP
END MAIN