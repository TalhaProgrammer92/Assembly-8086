; ==========================================================
; Program to print the pattern:
; *
; **
; ***
; ****
; *****
; ==========================================================

.MODEL SMALL

.STACK 100H

.DATA
    count DW 1
    char DB '*'
    limit DW 5      ; You can change its value this is exactly the size of pattern
    
    ; Macro to print the character
    PRINTC MACRO
        MOV AH, 02H
        MOV DL, char
        INT 21H
    PRINTC ENDM
    
    ; Macro to print a series of characters
    PRINTS MACRO size
        MOV CX, size
        AGAIN:
            PRINTC
            LOOP AGAIN
    PRINTS ENDM
    
    ; Macro for line break
    ENDL MACRO
        MOV DL, 0DH
        MOV AH, 02H
        INT 21H
        MOV DL, 0AH
        MOV AH, 02H
        INT 21H
    ENDL ENDM

.CODE
    MAIN PROC FAR
        MOV AX, @DATA
        MOV DS, AX
        
        ; Print the pattern
        PATTERN:
            PRINTS count
            ENDL
            INC count
            MOV AX, count
            MOV BX, limit
            CMP AX, BX
            JLE PATTERN
            JMP TERMINATE
        
        ; Terminate
        TERMINATE:
            MOV AH, 4CH
            INT 21H
    MAIN ENDP
END MAIN
