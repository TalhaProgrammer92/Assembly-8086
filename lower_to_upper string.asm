; Program to convert lower case strong to upper case string

.MODEL SMALL

.STACK 100H

.DATA
    str DB 'talha$'   ; string str = "hello world"; (C++)

.CODE 
    MAIN PROC FAR
        MOV AX, @DATA
        MOV DS, AX
        
        ; Convert & Display
        MOV SI, 0           ; Source Index
        AGAIN:
            MOV DL, str[SI]     ; char DL = str[SI]; (C++)
            SUB DL, 32
            MOV AH, 02H     ; cout << 'h';
            INT 21H
               
            INC SI      ; SI++  (0 -> 1 -> 2 ...)
            CMP str[SI], '$'
            JNE AGAIN   ; STR[SI] != '$' (True)

        ; Terminate the program
        MOV AH, 4CH
        INT 21H
    MAIN ENDP
END MAIN
