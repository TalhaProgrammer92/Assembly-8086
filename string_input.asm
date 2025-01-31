; Program to get string from user

.MODEL SMALL

.STACK 100H

.DATA
    msg1 DB 'Enter Text>> $'
    msg2 DB 'You Entered: $'
    text DB 100 dup('$') 

    ; Line break
    ENDL MACRO
        MOV AH, 02H
        MOV DL, 0DH
        INT 21H
        MOV AH, 02H
        MOV DL, 0AH
        INT 21H
    ENDL ENDM

    ; Print the string
    PRINT MACRO str
        MOV AH, 09H
        LEA DX, str
        INT 21H
    PRINT ENDM

.CODE
    MAIN PROC FAR
        MOV AX, @DATA
        MOV DS, AX

        ; Get Input
        PRINT msg1
        MOV SI, 0

    INPUT:
        MOV AH, 01H 
        INT 21H

        ; Check for Enter key
        CMP AL, 13 
        JE OUTPUT

        ; Check for buffer overflow
        CMP SI, 98 
        JE OUTPUT

        ; Store the character
        MOV text[SI], AL 
        INC SI

        ; Continue input
        JMP INPUT

    OUTPUT:
        ; Add null terminator to the string
        MOV text[SI], '$' 
        
        ; Display the string
        ENDL
        PRINT msg2
        PRINT text

        ; Program Termination
        MOV AH, 4CH
        INT 21H
    MAIN ENDP
END MAIN