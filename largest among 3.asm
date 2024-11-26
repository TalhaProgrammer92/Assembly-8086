; Program to find largest number among three numbers

.MODEL SMALL

.STACK 100H

.DATA
    A DW 5
    B DW 7
    C DW 4
    
    MSG1 DB 'A is largest$'
    MSG2 DB 'B is largest$'
    MSG3 DB 'C is largest$'
    
    ; Macro - Print string
    PRINT MACRO str
        MOV AH, 09H
        LEA DX, str
        INT 21H
    PRINT ENDM

.CODE
    MAIN PROC FAR
        MOV AX, @DATA
        MOV DS, AX

        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        ; Compare numbers               
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

        ; Compare (A)
        MOV AX, A
        CMP AX, B
        JG CMPA     ; A > B (True case)
        JMP BCMPB   ; (False case)

        CMPA:   ; Compare A with C
            CMP AX, C
            JG PRTA
            JMP BCMPB

        PRTA:   ; Print A
            PRINT MSG1
            JMP EXIT

        ; Compare (B)
        BCMPB:  ; Block Compare B
            MOV AX, B
            CMP AX, A
            JG CMPB     ; (True case) B > A
            JMP BCMPC   ; (False case)

        CMPB:   ; Compare B with C
            CMP AX, C
            JG PRTB
            JMP CMPC

        PRTB:   ; Print B
            PRINT MSG2
            JMP EXIT

        ; Compare (C)
        BCMPC:  ; Block compare C
            MOV AX, C
            CMP AX, A
            JG CMPC
            JMP EXIT

        CMPC:   ; Compare C with B
            CMP AX, B
            JG PRTC
            JMP EXIT

        PRTC:   ; Compare C
            PRINT MSG3
            JMP EXIT

        ; Program termination
        EXIT:
            MOV AH, 4CH
            INT 21H

    MAIN ENDP
END MAIN