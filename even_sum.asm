; Program to calculate and display the sum of 1st 50 even numbers

.MODEL SMALL

.STACK 100H

.DATA
    LIMIT DW 50         ; The number of even numbers you want to add
    SUM DW 0            ; The sum of even numbers
    
    ; Messages
    MSG_CAL DB 'Calculating sum...$'
    MSG_RES DB 'The sum is $'
    
    ; Macro - Print a string
    PRINT MACRO STR
        MOV AH, 09H
        LEA DX, STR
        INT 21H
    PRINT ENDM
    
    ; Macro - Line break
    ENDL MACRO
        MOV AH, 02H
        MOV DL, 0DH
        INT 21H
        
        MOV AH, 02H
        MOV DL, 0AH
        INT 21H
    ENDL ENDM

.CODE
    MAIN PROC FAR
        MOV AX, @DATA
        MOV DS, AX
        
        ; Calculation
        PRINT MSG_CAL
        ENDL
        MOV CX, LIMIT
        MOV AX, 0
        CALCULATE:
            ADD SUM, AX
            ADD AX, 2
            LOOP CALCULATE
        
        ; Display Result
        PRINT MSG_RES
        MOV AX, SUM
        MOV BX, 10
        MOV CX, 0
        PUSHL:
            CMP AX, 0
            JE POPL
            INC CX
            MOV DX, 0
            DIV BX
            ADD DL, '0'
            PUSH DX
            JMP PUSHL
        POPL:
            POP DX
            MOV AH, 02H
            INT 21H
            LOOP POPL
        
        ; Terminate the program
        MOV AH, 4CH
        INT 21H
    MAIN ENDP
END MAIN