; Programt to check whether an input character is vowel or consonant

.MODEL SMALL

.STACK 100H

.DATA
    msg DB 'Enter a character>> $'
    vowel DB 'It is vowel$'
    consonant DB 'It is consonant$'
    char DB ?
    
    ; Macro to show the message
    SHOW MACRO message
        MOV AH, 09H
        LEA DX, message
        INT 21H
    SHOW ENDM
    
    ; Macro to input the character
    GET MACRO
        MOV AH, 01H
        INT 21H
        MOV char, AL
    GET ENDM
    
    ; Macro for line break
    ENDL MACRO
        MOV DL, 0DH
        MOV AH, 02H
        INT 21H
        MOV DL, 0AH
        MOV AH, 02H
        INT 21H
    ENDL ENDM
    
    ; Macro to terminate the program
    TERMINATE MACRO
        MOV AH, 04H
        INT 21H
    TERMINATE ENDM
    
    ; Macro to check whether it is vowel or consonant
    RESULT MACRO
        ENDL
        
        ; Compare
        CMP char, 'a'   ; Compare char with 'a'
        JE VWL          ; As: if char = 'a' then jump [label]
        CMP char, 'A'
        JE VWL
        CMP char, 'e'
        JE VWL
        CMP char, 'E'
        JE VWL
        CMP char, 'i'
        JE VWL
        CMP char, 'I'
        JE VWL
        CMP char, 'o'
        JE VWL
        CMP char, 'O'
        JE VWL
        CMP char, 'U'
        JE VWL
        CMP char, 'u'
        JE VWL          ; True-case
        JMP CNT         ; False-case, As: jump [label]
        
        ; Block
        VWL:
            SHOW vowel
            TERMINATE
        CNT:
            SHOW consonant
    RESULT ENDM

.CODE
    MAIN PROC FAR
        MOV AX, @DATA
        MOV DS, AX
        
        ; Operation
        SHOW msg
        GET
        RESULT
        
        ; Termination
        TERMINATE
    MAIN ENDP
END MAIN
