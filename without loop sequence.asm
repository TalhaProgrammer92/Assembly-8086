; Pattern without loop - Talha Ahmad (c)

.MODEL SMALL

.STACK 100H

.DATA
    num DW 9
    
    PRINT MACRO
        ; Number
        MOV AH, 02H
        MOV DX, num
        ADD DX, '0'
        INT 21H
        
        ; New Line
        MOV AH, 02H
        MOV DL, 0DH
        INT 21H
        
        MOV AH, 02H
        MOV DL, 0AH
        INT 21H
    PRINT ENDM
    
.CODE
    MAIN PROC FAR
        ; Move data -> data segment register
        MOV AX, @DATA
        MOV DS, AX
        
        CALL PATTERN
        
        ; Program Termination
        EXIT:
            MOV AH, 4CH
            INT 21H
    MAIN ENDP
    
    PATTERN PROC
        PRINT
        
        CMP num, 0
        JE P_EXIT
        
        DEC NUM
        CALL PATTERN
        
        P_EXIT:
            RET
    PATTERN ENDP
    
END MAIN