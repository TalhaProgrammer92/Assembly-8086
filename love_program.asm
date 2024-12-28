; Program to draw a heart pattern

.MODEL SMALL

.STACK 100H

.DATA
    ;;;;;;;;;;;;;;;;;;;;
    ; Variables         
    ;;;;;;;;;;;;;;;;;;;;
    
    star DW 4       ; Count stars in a row
    space DW 2      ; Count spaces in a row
    
    ;;;;;;;;;;;;;;;;;;;;
    ; Macro
    ;;;;;;;;;;;;;;;;;;;;
    
    ; Display a character
    PRINT MACRO char
        MOV DL, char
        MOV AH, 02H
        INT 21H
    PRINT ENDM
    
    ; Line break
    ENDL MACRO
        PRINT 0DH
        PRINT 0AH
    ENDL ENDM
    
.CODE
    MAIN PROC FAR
        MOV AX, @DATA
        MOV DS, AX
        
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;
        ; Upper Part
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;
        MOV CX, 3
        UPPER_PART:
            ;;;;;;;;;;;;;;;;;;;;;;;
            ; Left Side
            ;;;;;;;;;;;;;;;;;;;;;;;
            
            ; Space 1
            LEFT_SPACE_1_U:
                MOV BX, 0
                LS1U_LOOP:
                    CMP BX, space
                    JL LS1U_PRINT
                    JMP LEFT_STAR_U
                    LS1U_PRINT:
                        PRINT ' '
                        INC BX
                        JMP LS1U_LOOP
            
            ; Star
            LEFT_STAR_U:
                MOV BX, 0
                LST1U_LOOP:
                    CMP BX, star
                    JL LST1U_PRINT
                    JMP LEFT_SPACE_2_U
                    LST1U_PRINT:
                        PRINT '*'
                        INC BX
                        JMP LST1U_LOOP
            
            ; Space 2
            LEFT_SPACE_2_U:
                MOV BX, 0
                LS2U_LOOP:
                    CMP BX, space
                    JLE LS2U_PRINT
                    JMP RIGHT_SPACE_U
                    LS2U_PRINT:
                        PRINT ' '
                        INC BX
                        JMP LS2U_LOOP

            ;;;;;;;;;;;;;;;;;;;;;;;
            ; Right Side
            ;;;;;;;;;;;;;;;;;;;;;;;
           
            ; Space
            RIGHT_SPACE_U:
                MOV BX, 0
                RSU_LOOP:
                    CMP BX, space
                    JL RSU_PRINT
                    JMP RIGHT_STAR_U
                    RSU_PRINT:
                        PRINT ' '
                        INC BX
                        JMP RSU_LOOP
            
            ; Star
            RIGHT_STAR_U:
                MOV BX, 0
                RSTU_LOOP:
                    CMP BX, star
                    JL RSTU_PRINT
                    JMP UPPER_NEXT
                    RSTU_PRINT:
                        PRINT '*'
                        INC BX
                        JMP RSTU_LOOP
            
            UPPER_NEXT:
                ENDL
                DEC space
                ADD star, 2
                LOOP UPPER_PART
        
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;
        ; Down Part
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;
        SUB star, 2
        INC space
        MOV CX, 9
        DOWN_PART:
            ;;;;;;;;;;;;;;;;;;;;;;;
            ; Left Side
            ;;;;;;;;;;;;;;;;;;;;;;;
            
            ; Space
            LEFT_SPACE_D:
                MOV BX, 0
                LSD_LOOP:
                    CMP BX, space
                    JL LSD_PRINT
                    JMP LEFT_STAR_D
                    LSD_PRINT:
                        PRINT ' '
                        INC BX
                        JMP LSD_LOOP
            
            ; Star
            LEFT_STAR_D:
                MOV BX, 0
                LSTD_LOOP:
                    CMP BX, star
                    JLE LSTD_PRINT
                    JMP RIGHT_STAR_D
                    LSTD_PRINT:
                        PRINT '*'
                        INC BX
                        JMP LSTD_LOOP
            
            ;;;;;;;;;;;;;;;;;;;;;;;
            ; Right Side
            ;;;;;;;;;;;;;;;;;;;;;;;
            
            ; Star
            RIGHT_STAR_D:
                MOV BX, 0
                RSTD_LOOP:
                    CMP BX, star
                    JL RSTD_PRINT
                    JMP RIGHT_SPACE_D
                    RSTD_PRINT:
                        PRINT '*'
                        INC BX
                        JMP RSTD_LOOP
            
            ; Space
            RIGHT_SPACE_D:
                MOV BX, 0
                RSD_LOOP:
                    CMP BX, space
                    JL RSD_PRINT
                    JMP DOWN_NEXT
                    RSD_PRINT:
                        PRINT ' '
                        INC BX
                        JMP RSD_LOOP
            
            DOWN_NEXT:
                ENDL
                INC space
                DEC star
                LOOP DOWN_PART
        
        MOV AH, 4CH
        INT 21H
    MAIN ENDP
END MAIN