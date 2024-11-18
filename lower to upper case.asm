; Program to take a lower case letter from user and convert it into upper case letter
; ASCII Code: a-97, A-65
; To convert lower case alphabet to upper case alphabet we have to subtract 32 from the ASCII code of the letter
; NOTE: To convert upper to lower case you should add 32 instead of subtracting
.MODEL SMALL

.STACK 100H

.DATA
    MSG DB 'Enter a letter (Capslock must be off)>> $'
    RES DB 0DH, 0AH, 'Result>> $'
    LETTER DB ?

.CODE
    MAIN PROC FAR
        MOV AX, @DATA
        MOV DS, AX
        
        ; TODO: Get letter from user
        
        MOV AH, 09H
        LEA DX, MSG
        INT 21H
        
        MOV AH, 01H
        INT 21H
        MOV LETTER, AL
        
        ; TODO: Convert the lower case letter to upper case letter
        
        SUB LETTER, 32
        
        ; TODO: Display the converted letter
        
        MOV AH, 09H
        LEA DX, RES
        INT 21H
        
        MOV AH, 02H
        MOV DL, LETTER
        INT 21H
        
        ; TODO: Program Termination
        MOV AH, 4CH
        INT 21H
        
        MAIN ENDP
    END MAIN