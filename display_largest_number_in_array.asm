; Program to largest number in an array

.MODEL SMALL

.STACK 100H

.DATA
    array DW 1, 8, 6, 5, 7      ; The array
    size DW 5                   ; Size of the array
    max DW ?

.CODE
    MAIN PROC FAR
        MOV AX, @DATA
        MOV DS, AX
        
        MOV SI, 0
        MOV DX, array[SI]
        MOV max, DX
        ADD SI, 2
        
        MOV CX, size
        DEC CX
        
        DISP:
            ; Array element (number)
            MOV DX, array[SI]
            CMP DX, max
            JG ASSIGN
            JMP SKIP
            
            ASSIGN:
                MOV max, DX
            
            SKIP:
                ADD SI, 2
                LOOP DISP
        
        ; Display the number
        MOV DX, max
        ADD DX, 48
        MOV AH, 02H
        INT 21H

        MOV AH, 4CH
        INT 21H
    MAIN ENDP
END MAIN