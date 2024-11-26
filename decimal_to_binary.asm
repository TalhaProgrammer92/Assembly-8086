; Program to convert decimal to binary - number system

.MODEL SMALL

.STACK 100H

.DATA
    prompt_input DB 'Enter a decimal number>> $'
    prompt_output DB 'Binary number>> $'
    bit DB ?
    
    ; Macro - Print a string
    PRINT MACRO message
        MOV AH, 09H
        LEA DX, message
        INT 21H
    PRINT ENDM
    
    ; Macro - Line break
    ENDL MACRO
        MOV DL, 0DH
        MOV AH, 02H
        INT 21H
        MOV DL, 0AH
        MOV AH, 02H
        INT 21H
    ENDL ENDM
    
    ; Macro - Input number (single digit)
    INPUT MACRO
        MOV AH, 01H
        INT 21H
        SUB AL, 48      ; Converting ASCII code to actual single digit number (e.g, 50 - 48 => 2). As the input character is stored in AL.
        MOV AH, 0       ; Thus, AX = 0c, where c is the input character i.e. c = c - 48, c is ASCII value
        ENDL
    INPUT ENDM
    
    ; Macro - Convert the number to binary
    CONVERT MACRO
        ; Assigning some necessary values
        MOV BX, 2       ; To divide the number by 2
        MOV DX, 0       ; Requirment because the DIV instruction always store remainder in DX
        MOV CX, 0       ; Initially set to 0 in order to increment durin conversion because when we pop from stack its value would be useful
        
        ; Perform conversion operation - Push all remainders onto stack
        CLOOP:
            DIV BX          ; BX - Divisor | AX - Dividend
            PUSH DX         ; Pushing the value stored in DX which is basically remainder we got after perform division
            INC CX          ; CX (value)++
            CMP AX, 0       ; AX != 0 | AX - Quotient
            JNE CLOOP       ; --^ (True case)
        
        ; Display a message
        PRINT prompt_output
        
        ; Pop and display number on stack
        DLOOP:
            POP DX          ; Pop each value from stack from CX (value) index
            ADD DX, 48      ; Adding 48 to the value in DX. For example 1 + 48 => 47 (1 in ASCII)
            MOV AH, 02H
            INT 21H
            LOOP DLOOP
    CONVERT ENDM

.CODE
    MAIN PROC FAR
        MOV AX, @DATA
        MOV DS, AX
        
        ; Get the number from user
        PRINT prompt_input
        INPUT
        
        ; Convert the decimal number to binary number and display that converted number
        CONVERT
        
        ; Terminate the program
        MOV AH, 4CH
        INT 21H
    MAIN ENDP
END MAIN