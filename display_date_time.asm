; Program to display current date and time

.MODEL SMALL

.STACK 100H

.DATA
    ; Variables
    MSGD DB 'Current Date is: $'
    MSGT DB 'Current Time is: $'
    YEAR DW ?
    MONTH DB ?
    DAY DB ?
    HOUR DB ?
    MINUTE DB ?
    SECOND DB ?
    
    ; Macro - Display a character
    PRINTC MACRO CHARACTER
        MOV AH, 02H
        MOV DL, CHARACTER
        INT 21H
    PRINTC ENDM
    
    ; Macro - Display a string
    PRINTS MACRO STRING
        MOV AH, 09H
        MOV DX, OFFSET STRING
        INT 21H
    PRINTS ENDM
    
    ; Macro - Desplay number
    PRINTN MACRO NUMBER
        PUSH AX
        PUSH BX
        PUSH CX
        PUSH DX
        
        MOV CX, 10
        MOV BX, 0
        
        .CONVERT_DIGIT:
            XOR DX, DX
            DIV CX
            ADD DL, '0'
            PUSH DX
            INC BX
            TEST AX, AX
            JNZ .CONVERT_DIGIT
        
        .PRINIT_DIGIT:
            POP DX
            MOV AH, 02H
            INT 21H
            DEC BX
            JNZ .PRINT_DIGIT
            
        POP DX
        POP CX
        POP BX
        POP AX
    PRINTN ENDM
    
    ; Macro - For line break
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
        ; Get data from data segment
        MOV AX, @DATA
        MOV DS, AX
        
        ; Get current date
        MOV AH, 2AH
        INT 21H
        
        ; Store the date in variables
        MOV CX, YEAR
        MOV DH, MONTH
        MOV DL, DAY
        
        ; Display the date
        PRINTS MSGD
        PRINTN YEAR
        PRINTC ':'
        PRINTN MONTH
        PRINTC ':'
        PRINTN DAY
        PRINTC ':'
        ENDL
        
        ; Get current time
        MOV AH, 2CH
        INT 21H
        
        ; Store the time in variables
        MOV HOUR, CH
        MOV MINUTE, CL
        MOV SECOND, DH
        
        ;Display the time
        PRINTS MSGT
        PRINTN HOUR
        PRINTC ':'
        PRINTN MONTH
        PRINTC ':'
        PRINTN SECOND
        ENDL
        
        ; Terminate the program
        MOV AX, 4C00H
        INT 21H
        MAIN ENDP
    END MAIN