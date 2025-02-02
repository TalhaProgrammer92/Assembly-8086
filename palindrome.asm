; Program to check whether a given string is palindrome or not

.MODEL SMALL

.STACK 100H

.DATA
    res1 DB ' is Palindrome$'
    res0 DB ' is not Palindrome$'
    str DB 'dennis sinned$'
    size DW 13
    temp DB ?
    
    ; Macro - print String
    PRINT MACRO string
        MOV AH, 09H
        MOV DX, OFFSET string
        INT 21H
    PRINT ENDM

.CODE
    MAIN PROC FAR
        MOV AX, @DATA
        MOV DS, AX
        
        ; Display the string
        PRINT str
        
        ; Check Loop
        MOV CX, size
        MOV BX, 0
        CHECK:
            ; From Right Side (gnirtS)
            MOV SI, CX
            DEC SI
            MOV AL, str[SI]
            
            ; Skip whitespace
            CMP AL, ' '
            JE FLOW
            
            ; Store the character in temp variable for later comparison
            MOV temp, AL
            
            ; From Left Side (String)
            MOV SI, BX
            MOV AL, str[SI]
            CMP AL, temp
            JNE NOT_PAL
            
            ; Flow
            FLOW:
                INC BX
                LOOP CHECK
        
        ; Palindrome Case
        PRINT res1
        JMP EXIT
        
        ; Non-Palindrome Case
        NOT_PAL:
            PRINT res0
        
        ; Program Termination
        EXIT:
            MOV AH, 4CH
            INT 21H
    MAIN ENDP
END MAIN