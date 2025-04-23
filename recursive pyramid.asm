; Pyramid Pattern - No loops

;     *
;    ***
;   *****
;  *******
; *********

.MODEL SMALL

.STACK 100H

.DATA
    symbol DB '*'
    
    size DB 5
    row DB 1
    empty DB ?
    
    temp_empty DB ?
    temp_row DB ?

    PRINT MACRO chr
        MOV AH, 02H
        MOV DL, chr
        INT 21H
    PRINT ENDM
    
    NEW_LINE MACRO
        PRINT 0DH
        PRINT 0AH
    NEW_LINE ENDM
    
    UPDATE MACRO
        DEC empty
        ADD row, 2
    UPDATE ENDM
    
    STORE MACRO
        MOV AL, empty
        MOV temp_empty, AL
        
        MOV AL, row
        MOV temp_row, AL
    STORE ENDM
    
.CODE
    MAIN PROC FAR
        MOV AX, @DATA
        MOV DS, AX
        
        ; Calculate initial whitespaces (empty) value
        MOV AL, size
        DEC AL
        MOV empty, AL
        
        ; Draw the Pyramid Pattern
        CALL PYRAMID
        
        MOV AH, 4CH
        INT 21H
    MAIN ENDP
    
    ; Draw empty space
    WHITESPACE PROC
        CMP temp_empty, 1   ; Prevent infinite loop on value less than 1 i.e. 0
        JL W_EXIT
        
        PRINT ' '
        
        CMP temp_empty, 1
        JE W_EXIT
        
        DEC temp_empty
        CALL WHITESPACE
        
        W_EXIT:
            RET
    WHITESPACE ENDP
    
    ; Draw line of symbols
    LINE PROC
        PRINT symbol
        
        CMP temp_row, 1
        JE L_EXIT
        
        DEC temp_row
        CALL LINE
        
        L_EXIT:
            RET
    LINE ENDP
    
    ; Main pattern
    PYRAMID PROC
        STORE
        
        CALL WHITESPACE
        CALL LINE
        
        NEW_LINE
        
        CMP size, 1
        JE P_EXIT
        
        DEC size
        UPDATE
        CALL PYRAMID
        
        P_EXIT:
            RET
    PYRAMID ENDP
    
END MAIN
