; Program to print square alphabets pattern

.MODEL SMALL

.STACK 100H

.DATA
    letter DB 'A'   ; Alphabet to be printed
    size DW 12      ; Size of the patter

    ; Macro - Print character
    PRINT MACRO char
        MOV DL, char
        MOV AH, 02H
        INT 21H
    PRINT ENDM

    ; Macro - Line Break
    ENDL MACRO
        PRINT 0DH
        PRINT 0AH
    ENDL ENDM

.CODE
    MAIN PROC FAR
        MOV AX, @DATA
        MOV DS, AX
        
        ; Draw Patter
        MOV CX, size
        OUTER:
            MOV BX, 0
            INNER:
                ;PRINT ' '
                PRINT letter
                PRINT ' '
                INC BX
                CMP BX, size
                JL INNER
            ENDL
            INC letter
            LOOP OUTER
        
        MOV AH, 4CH
        INT 21H
    MAIN ENDP
END MAIN