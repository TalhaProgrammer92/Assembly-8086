; Binary search in Assembly - Just for fun

.MODEL SMALL

.STACK 100H

.DATA
    array DB 1, 3, 5, 7, 9, 10, 11, 12, 15, 18
    target DB 11
    
    msg_found DB 'Number found!$'
    msg_nfound DB 'Number not found!$'
    
    left DB 0
    right DB 9
    mid DB ?
    
    num DB ?

    ; Print string
    PRINT MACRO str
        MOV AH, 09H
        LEA DX, str
        INT 21H
    PRINT ENDM
    
    ; Calculate mid
    CALC_MID MACRO
        ; Debug
        ;PRINTN left
        ;PRINTC '+'
        ;PRINTN right
        ;PRINTC ' '
        ;PRINTC '/'
        ;PRINTN 2
        ;PRINTC '='
        
        MOV AH, 0
        MOV AL, left
        ADD AL, right
        
        MOV BH, 0
        MOV BL, 2
        DIV BL
        
        MOV mid, AL
        
        ;PRINTN mid
        ;NEW_LINE
    CALC_MID ENDM
    
    ; Get number of mid
    GET_MID_NUM MACRO
        MOV BH, 0
        MOV BL, mid
        
        MOV SI, BX
        
        MOV AL, array[SI]
        MOV num, AL
    GET_MID_NUM ENDM
    
    ; Print number - Debugging purpose
    PRINTN MACRO num
        MOV DL, num
        ADD DL, '0'
        MOV AH, 02H
        INT 21H
    PRINTN ENDM
    
    ; Print character - Debugging purpose
    PRINTC MACRO chr
        MOV DL, chr
        MOV AH, 02H
        INT 21H
    PRINTC ENDM
    
    ; New line - Debugging purpose
    NEW_LINE MACRO
        PRINTC 0DH
        PRINTC 0AH
    NEW_LINE ENDM

.CODE
    MAIN PROC FAR
        MOV AX, @DATA
        MOV DS, AX
        
        ; Binary Search - Loop
        BS_LOOP:
            ; Calculate mid
            CALC_MID
            
            ; Get number
            GET_MID_NUM
            
            ; Compare the number
            MOV AL, target
            
            CMP AL, num     ; If array[mid] (num) == target
            JE NUM_FOUND
            
            CMP AL, num     ; If array[mid] (num) > target
            JL GO_LEFT      
            
            CMP AL, num     ; If array[mid] (num) < target
            JG GO_RIGHT
            
            ; Greater - case
            GO_LEFT:
                MOV AH, 0
                MOV AL, mid
                DEC AL
                MOV right, AL
                JMP BSLC
            
            ; Smaller - case
            GO_RIGHT:    
                MOV AH, 0
                MOV AL, mid
                INC AL
                MOV left, AL
            
            ;PRINTN num
            ;JMP EXIT
            
            ; Loop Control
            BSLC:
                MOV AH, 0
                MOV AL, left
                CMP AL, right
                JLE BS_LOOP
        
        ; Number not found - case
        PRINT msg_nfound
        JMP EXIT
        
        ; Number found - case
        NUM_FOUND:
            PRINT msg_found
        
        ; Program Termination
        EXIT:
            MOV AH, 4CH
            INT 21H
    MAIN ENDP
END MAIN