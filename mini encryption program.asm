; Caeser Cipher

.MODEL SMALL

.STACK 100H

.DATA
    text DB 50 DUP('$')
    msg_prompt_text DB 'Enter Text: $'
    msg_prompt_shift DB 'Enter Shift: $'
    msg_result DB 'Caeser Cipher: $'
    
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
        
        ; Take input - Text
        PRINT msg_prompt_text
        MOV SI, 0
        
        INPUT:
            MOV AH, 01H 
            INT 21H

            ; Check for Enter key
            CMP AL, 13 
            JE NEXT

            ; Check for buffer overflow
            CMP SI, 98 
            JE NEXT

            ; Store the character
            MOV text[SI], AL 
            INC SI

            ; Continue input
            JMP INPUT
        
        NEXT:
            ; Take input - Shift
            ENDL
            PRINT msg_prompt_shift
            MOV AH, 01H
            INT 21H
            SUB AL, '0'

            ; Add null terminator to the string
            MOV text[SI], '$'
            DEC SI
        
        ; Encryption
        ENCRYPT:
            CMP text[SI], 32      ; Whitespace
            JE FLOW
            
            ADD text[SI], AL ; Cipher
            
            FLOW:
                DEC SI
                CMP SI, 0
                JGE ENCRYPT
        
        ; Display Output
        ENDL
        PRINT msg_result
        PRINT text
        
        ; Terminate program
        MOV AH, 4CH
        INT 21H
    MAIN ENDP
END MAIN
