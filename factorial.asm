; Program to calculate factorial of a number

.MODEL SMALL
.STACK 100H

.DATA
    fact DW 1
    num DW 5      
    msg1 DB 'Calculating the factorial...$'
    msg2 DB 'The factorial is $'
    
    ; Macro - Display string
    PRINTS MACRO string
        MOV AH, 09H
        LEA DX, string
        INT 21H
    PRINTS ENDM
    
    ; Macro - Line Break
    ENDL MACRO
        MOV AH, 02H
        MOV DL, 0DH
        INT 21H
        
        MOV AH, 02H
        MOV DL, 0AH
        INT 21H
    ENDL ENDM
    
    ; Macro - Display a word (number)
    PRINTN MACRO number
        MOV AX, number      ; Moves the number to AX
        MOV BX, 10          ; To divide the AX with BX
        MOV CX, 0           ; Loop counter
        
        PUSHL:
            CMP AX, 0
            JE POPL
            INC CX
            MOV DX, 0       ; Clear DX for unsigned division
            DIV BX          ; Divide by 10 (BX)
            ADD DL, '0'     ; Convert remainder to ASCII digit
            PUSH DX
            JMP PUSHL
        
        ; Printing the digits ;
        POPL:
            CMP CX, 0
            JE EXIT
            DEC CX
            POP DX
            MOV AH, 02h
            INT 21h
            JMP POPL
    PRINTN ENDM
    
.CODE
    MAIN PROC FAR
        MOV AX, @DATA
        MOV DS, AX
        
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        ; Calculation of the factorial            
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        PRINTS msg1
        ENDL
        
        ; Check if the number is less than 2
        MOV AX, num
        CMP AX, 2
        JL DISPLAY
        
        MOV CX, num
        CALC_LOOP:
            MOV AX, num
            SUB AX, CX
            INC AX
            MOV BX, fact
            MUL BX
            MOV fact, AX            
            LOOP CALC_LOOP
        
        
        DISPLAY:
            PRINTS msg2
            PRINTN fact
        
        
        ;;;;;;;;;;;;;;;;;;;;;;
        ; Termination
        ;;;;;;;;;;;;;;;;;;;;;;
        EXIT:
            MOV AH, 4CH
            INT 21H
    MAIN ENDP
END MAIN