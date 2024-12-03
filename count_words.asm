INCLUDE 'EMU8086.INC'

.MODEL SMALL
.STACK 100H
.DATA
    str DB 'The quick brown fox jumps over a lazy dog. My name is Talha Ahmad. I love to code. This program counts number of words. Coding is fun.$'
    words DW 0      ; Expected: 27
    
    ; Macro - Line break
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
        MOV AX, @DATA
        MOV DS, AX
                
        ; Count words
        PRINT 'Counting...'
        ENDL
        MOV SI, 0
        COUNT:
             CMP str[SI], ' '
             JNE SKIP
             CMP str[SI], '.'
             JE SKIP
             INC words
             
             SKIP:
                INC SI
                CMP str[SI], '$'
                JNE COUNT
        
        ; Display
        PRINT 'Words count: '
        INC words
        MOV AX, words
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
            CMP CX, 0
            JE EXIT
            DEC CX
            POP DX
            MOV AH, 02H
            INT 21H
            JMP POPL
        
        ; Program Termination
        EXIT:
            MOV AH, 4CH
            INT 21H
    MAIN ENDP
END MAIN