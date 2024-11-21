; Program to print house pattern - I created this program just for fun

.MODEL SMALL

.STACK 100H

.DATA
    row DW 17
    gap DW 6
    roofFill DW 9
    countGap DW ?
    countRFill DW ?

    ; Macro to print the character
    PRINTC MACRO char
        MOV AH, 02H
        MOV DL, char
        INT 21H
    PRINTC ENDM

    ; Macro for line break
    ENDL MACRO
        MOV DL, 0DH
        MOV AH, 02H
        INT 21H
        MOV DL, 0AH
        MOV AH, 02H
        INT 21H
    ENDL ENDM

    ; Macro to update variables
    UPDATE MACRO
        DEC gap
        ADD row, 2
    UPDATE ENDM

    ; Macro to print gaps/whitespaces in roof-fill
    PRINTGRF MACRO
        MOV countGap, 1
        GRF:
            PRINTC ' '
            INC countGap
            MOV AX, countGap
            CMP AX, gap
            JLE GRF
    PRINTGRF ENDM

    ; Macro to fill roof-fill
    PRINTFRF MACRO
        MOV countRFill, 1
        FRF:
            MOV AX, countRFill
            CMP AX, roofFill
            JE FRFW
            JMP FRFN
            FRFW:
                PRINTC 'V'
                JMP FRFF
            FRFN:
                PRINTC 'V'
                PRINTC ' '
                JMP FRFF
            FRFF:
                INC countRFill
                MOV AX, countRFill
                CMP AX, roofFill
                JLE FRF
    PRINTFRF ENDM

    ; Macro to print ':' in a row
    PRINTBP1 MACRO
        MOV countRFill, 1
        PBP1:
            PRINTC ':'
            INC countRFill
            MOV AX, countRFill
            CMP AX, row
            JLE PBP1
    PRINTBP1 ENDM

    ; Macro to print ':' & 'I' in a row
    PRINTBP2 MACRO
        MOV countRFill, 1
        PBP2:
            MOV AX, countRFill
            ; 30 - 5 -> 25 | 25 / 2 -> 12.5 ~ 13 | 12 + 5 -> 17
            CMP AX, 13
            JL COLON
            CMP AX, 17
            JG COLON
            JMP DOOR
            
            DOOR:
                PRINTC 'I'
                JMP PBP2FLOW
            
            COLON:
                PRINTC ':'
            
            PBP2FLOW:
                INC countRFill
                MOV AX, countRFill
                CMP AX, row
                JLE PBP2
    PRINTBP2 ENDM

.CODE
    MAIN PROC FAR
        MOV AX, @DATA
        MOV DS, AX

        ; Roof - Top
        MOV CX, gap
        RTOPW:          ; Print whitespaces
            PRINTC ' '
            LOOP RTOPW
        MOV CX, row
        RTOPB:          ; Print '=' on roof-top
            PRINTC '='
            LOOP RTOPB
        ENDL
        UPDATE

        ; Roof - Fill
        MOV CX, 5
        RFILL:
            ; Gap
            PRINTGRF
            PRINTC ')'
            PRINTFRF
            PRINTC '('
            ENDL
            INC roofFill
            UPDATE
            LOOP RFILL

        ; Roof - Bottom
        MOV CX, row
        RBOTTOM:
            PRINTC '~'
            LOOP RBOTTOM
        ENDL

        ; Body - P1 ':' - wall only
        MOV CX, 3
        BP1:
            PRINTBP1
            ENDL
            LOOP BP1

        ; Body - P2 ':' + 'I' - wall and door
        MOV CX, 4
        BP2:
            PRINTBP2
            ENDL
            LOOP BP2

        ; Terminate the program
        MOV AH, 4CH
        INT 21H
    MAIN ENDP
END MAIN