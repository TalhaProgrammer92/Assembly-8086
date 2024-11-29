; Program to convert given decimal number to binary

.MODEL SMALL

.STACK 100H

.DATA
    number DW 35    ; Decimal number - Limit 16 bit (0 to 65536)

.CODE
    MAIN PROC FAR
        MOV AX, @DATA
        MOV DS, AX

        ; Conversion
        MOV AX, number
        MOV BX, 2
        MOV CX, 0
        DIV_LOOP:
            INC CX
        
            MOV DX, 0
            DIV BX
        
            ADD DL, '0'     ; To ASCII
        
            PUSH DX

            CMP AX, 0
            JE DISP_LOOP
            JMP DIV_LOOP
        
        ; Display
        DISP_LOOP:
            POP DX
        
            MOV AH, 02H
            INT 21H
        
            LOOP DISP_LOOP

        ; Terminate the program
        MOV AH, 4CH
        INT 21H
    MAIN ENDP
END MAIN
