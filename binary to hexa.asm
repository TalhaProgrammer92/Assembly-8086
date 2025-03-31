; Program to take binary number from user and convert it to hexadecimal -- Fixed version

.MODEL SMALL
.STACK 100H
.DATA
    ;;;;;;;;;;;;;;;;;;;;;;;
    ; Memory Locations     
    ;;;;;;;;;;;;;;;;;;;;;;;
    
    ; Variables - Number System
    binary DB 16 dup('$')
    decimal DW 0
    hex_alpha DB 'ABCDEF$'
    
    ; To store power result i.e. n^p
    num DW ?
    power DW ?
    
    ; Messages
    input_msg DB 'Enter binary number (max: 16 bits): $'
    output_msg_dec DB 'Decimal number is $'
    output_msg_hex DB 'Hexadecimal number is $'
    
    ;;;;;;;;;;;;;
    ; Macros     
    ;;;;;;;;;;;;;
    
    ; Display String
    PRINTS MACRO STR
        MOV AH, 09H
        LEA DX, STR
        INT 21H
    PRINTS ENDM
    
    ; Display Character
    PRINTC MACRO
        MOV AH, 02H
        INT 21H
    PRINTC ENDM
    
    ; Line Break
    ENDL MACRO
        MOV DL, 0DH
        PRINTC 
        
        MOV DL, 0AH
        PRINTC 0AH
    ENDL ENDM
    
    ; Input character
    INPUT MACRO
        MOV AH, 01H
        INT 21H
    INPUT ENDM

.CODE           
    ;;;;;;;;;;;;;;;;;
    ; Procedures     
    ;;;;;;;;;;;;;;;;;
    
    ; Entry point
    MAIN PROC FAR
        ; Data -> DS Register
        MOV AX, @DATA
        MOV DS, AX
        
        ; Take input from user
        CALL TAKE_INPUT
        
        ; Conversion - Binary to Decimal
        CALL CONVERT_TO_DECIMAL
        
        ; Display - Decimal
        ENDL
        PRINTS output_msg_dec
        CALL DISPLAY_DECIMAL
        ENDL
        
        ; Display - Hexadecmal
        ENDL
        PRINTS output_msg_hex
        CALL CONVERT_TO_HEXADECIMAL
        
        ; Program Termination
        MOV AH, 4CH
        INT 21H
    MAIN ENDP
    
    ; Take input
    TAKE_INPUT PROC
        ; Display message
        PRINTS input_msg
        
        ; Loop - Take input
        MOV CX, 16
        MOV SI, 0
        TI_LOOP:
            ; Input
            TI_INPUT:
                ; Input character
                INPUT
                CMP AL, 13  ; Enter key
                JE TI_EXIT
            
                ; Validate
                CMP AL, '1'
                JE TI_VALID
                CMP AL, '0'
                JE TI_VALID
                JMP TI_INPUT
            
            ; If input is valid
            TI_VALID:
                MOV binary[SI], AL
                INC SI
                LOOP TI_LOOP
        
        TI_EXIT:
            ; Line break
            ENDL
        
            RET
    TAKE_INPUT ENDP
    
    ; Convert binary to decimal
    CONVERT_TO_DECIMAL PROC
        ; Initial values
        MOV power, 0     ; Start with 2^0
        DEC SI           ; Point to last entered digit
        
        ; Conversion loop
        CTD_LOOP:
            CMP SI, -1   ; Check if we've processed all digits
            JE CTD_EXIT
            
            ; Get current bit (0 or 1)
            MOV DL, binary[SI]
            SUB DL, '0'
            MOV DH, 0    ; Clear upper byte
            
            ; Calculate 2^power
            MOV CX, power
            MOV AX, 1    ; Initialize result to 1
            CMP CX, 0    ; If power is 0, skip loop
            JE SKIP_POWER
            
            ; Power calculation loop
            POWER_LOOP:
                SHL AX, 1       ; do a right shift with bit '1' i.e. 0010 (2) -> 0100 (4)
                LOOP POWER_LOOP
            
            SKIP_POWER:
            ; Multiply bit by power of 2
            MUL DX       ; AX = AX * DX (bit value)
            
            ; Add to total
            ADD decimal, AX
            
            ; Prepare for next digit
            DEC SI
            INC power
            JMP CTD_LOOP
        
        CTD_EXIT:
            RET
    CONVERT_TO_DECIMAL ENDP
    
    ; Convert decimal to hexadecimal
    CONVERT_TO_HEXADECIMAL PROC
        ; Storing important values to registers
        MOV AX, decimal
        MOV BX, 16
        MOV CX, 0       ; Counter for digits
    
        CTH_LOOP:
            CMP AX, 0
            JE CTH_PRINT
        
            ; Conversion
            MOV DX, 0
            DIV BX
        
            ; Check for > 9
            CMP DX, 9
            JG CTH_APLHA
        
            ; Normal digit (0-9)
            ADD DX, '0'
            JMP CTH_PUSH
        
            ; For > 9 values (A-F)
            CTH_APLHA:
                MOV SI, DX
                SUB SI, 10
                MOV DX, 0
                MOV DL, hex_alpha[SI]
        
            CTH_PUSH:
                PUSH DX     ; Store the digit
                INC CX      ; Increment digit count
                JMP CTH_LOOP
    
        CTH_PRINT:
            ; If number was 0
            CMP CX, 0
            JNE CTH_POP
            MOV DL, '0'
            PRINTC
            JMP CTH_EXIT
        
        ; Print digits in correct order
        CTH_POP:
            POP DX
            PRINTC
            LOOP CTH_POP
            
        CTH_EXIT:
            RET
    CONVERT_TO_HEXADECIMAL ENDP
    
    ; Display multidigit num (decimal)
    DISPLAY_DECIMAL PROC
        ; If decimal value is single digit
        CMP decimal, 9
        JLE DD_SINGLE
        
        ; Initial values
        MOV AX, decimal
        MOV BX, 10
        MOV CX, 0
        
        ; Push onto stack
        DD_PUSH:
            ; Loop control
            CMP AX, 0
            JE DD_POP
            
            ; Get remainder (Right Most Digit)
            MOV DX, 0      ; Clear DX for division
            DIV BX         ; AX = AX/BX, DX = remainder
            ADD DL, '0'    ; Convert to ASCII
            
            ; Push the remainder onto stack
            PUSH DX
            
            ; Flow
            INC CX
            JMP DD_PUSH
        
        ; Pop from stack
        DD_POP:
            ; Loop control
            CMP CX, 0
            JE DD_EXIT
            DEC CX
            
            ; Pop value (remainder) from stack
            POP DX
            
            ; Display the value
            MOV AH, 02H
            INT 21H
            
            ; Flow
            JMP DD_POP
        
        JMP DD_EXIT
        
        ; For single digit numbers
        DD_SINGLE:
            MOV DX, decimal
            ADD DX, '0'
            MOV AH, 02H
            INT 21H
        
        DD_EXIT:
            RET
    DISPLAY_DECIMAL ENDP
        
END MAIN