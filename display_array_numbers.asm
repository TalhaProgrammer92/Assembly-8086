; Program to display numbers in an array

.MODEL SMALL

.STACK 100H

.DATA
    array DW 1, 3, 5, 7, 9      ; The array
    size DW 5                   ; Size of the array

.CODE
    MAIN PROC FAR
        MOV AX, @DATA
        MOV DS, AX
        
        MOV SI, 0
        MOV CX, size
        
        DISP:
            ; Array element (number)
            MOV DX, array[SI]
            ADD DX, 48
            MOV AH, 02H
            INT 21H
            
            ; Whitespace
            MOV DL, ' '
            MOV AH, 02H
            INT 21H
            
            ADD SI, 2
            LOOP DISP

        MOV AH, 4CH
        INT 21H
    MAIN ENDP
END MAIN