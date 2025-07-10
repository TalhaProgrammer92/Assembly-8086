; Loading screen animation - Just for Fun

.MODEL SMALL         

.STACK 100H

.DATA
    front DB '#'
    back DB '-'
    size DB 20
    process DB 1
    
    REVERSE MACRO
        MOV AH, 02H
        MOV DL, 13
        INT 21H
    REVERSE ENDM

.CODE
    MAIN PROC FAR
        MOV AX, @DATA
        MOV DS, AX
        
        CALL LOADING
        
        MOV AH, 4CH
        INT 21H
    MAIN ENDP

    ; Size - CL | Char - DL
    DISPLAY PROC
        MOV CH, 0
        DLOOP:
            MOV AH, 02H
            INT 21H
            LOOP DLOOP

        RET
    DISPLAY ENDP

    LOADING PROC
        MOV CL, size
        MOV DL, back
        CALL DISPLAY
        
        BAR_LOOP:
            REVERSE
            
            MOV CL, process
            MOV DL, front
            CALL DISPLAY
            
            CALL SLEEP
            
            ; Loop Control
            INC process
            MOV AL, process
            CMP AL, size
            JLE BAR_LOOP
        
        RET
    LOADING ENDP

    SLEEP PROC
        MOV CX, 30     ; Delay value
        DELAY:
            LOOP DELAY
        
        RET
    SLEEP ENDP
END MAIN
    