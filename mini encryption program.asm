; Caeser Cipher

.MODEL SMALL

.STACK 100H

.DATA
    msg DB 'The quick brown fox jumps over a lazy dog$'

.CODE
    MAIN PROC FAR
        MOV AX, @DATA
        MOV DS, AX
        
        MOV SI, 0
        ENCRYPTION:
            MOV DL, msg[SI]
            ADD DL, 3
            MOV AH, 02H
            INT 21H
            INC SI
            CMP msg[SI], '$'
            JNE ENCRYPTION
        
        MOV AH, 4CH
        INT 21H
    MAIN ENDP
END MAIN