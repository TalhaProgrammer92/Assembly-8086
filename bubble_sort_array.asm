; Program to sort an array using bubble sort in ascending order and then display the sorted array

.MODEL SMALL

.STACK 100H

.DATA
    array DW 4, 2, 5, 1, 3, 8, 9, 7, 6      ; The array
    size DW 9                               ; The size of the array
    temp DW ?                               ; To temporary store a number

.CODE
    MAIN PROC FAR
        MOV AX, @DATA
        MOV DS, AX

        ;;;;;;;;;;;;;;;;;;;;;;;
        ; Sorting              
        ;;;;;;;;;;;;;;;;;;;;;;;
        MOV CX, 0           ; Outer - counter
        
        ; Outer - loop
        OUTER:
            MOV SI, 0           ; Index of array
            MOV BX, 0           ; Inner - counter
            
            ; Inner - loop
            INNER:
                MOV DX, array[SI]               ; DX = array[SI]
                CMP DX, array[SI + 2]           ; Compare DX with array[SI + 2] | array[SI + 2] is the value located after array[SI]
                JLE SKIP                        ; IF DX <= array[SI + 2] THEN GOTO SKIP
                
                ; Swap
                MOV temp, DX                    ; temp = DX | DX is array[SI]
                
                MOV AX, array[SI + 2]           ; AX = array[SI + 2]
                MOV array[SI], AX               ; array[SI] = AX
                
                MOV AX, temp                    ; AX = temp
                MOV array[SI + 2], AX           ; array[SI + 2] = AX
                
                SKIP:
                    ; Control - Inner
                    ADD SI, 2                   ; SI += 2   | SI is the index of the given array
                    INC BX                      ; BX++      | BX is the inner loop counter
                    MOV DX, size                ; DX = size | size is the total size of the given array
                    SUB DX, CX                  ; DX -= CX  | CX is the outer loop counter
                    DEC DX                      ; DX--
                    CMP BX, DX                  ; Compare BX with DX
                    JL INNER                    ; IF BX < DX THEN GOTO INNER
        
            ; Control - Outer
            INC CX              ; CX is the outer loop counter
            MOV DX, size        ; DX = size
            DEC DX              ; DX--
            CMP CX, DX          ; Compare CX with DX
            JL OUTER            ; IF CX < DX THEN GOTO INNER
        
        ;;;;;;;;;;;;;;;;;;;;;;;
        ; Display              
        ;;;;;;;;;;;;;;;;;;;;;;;
        MOV CX, size        ; CX = size
        MOV SI, 0           ; SI = 0
        
        DISPLAY:
            MOV DX, array[SI]   ; DX = array[SI]
            ADD DX, 48          ; DX += 48 | We add 48 because in ASCII 48 is 0
            MOV AH, 02H         ; AH = 02H | To display the character stored in DX
            INT 21H             ; DOS interupt
            
            MOV DL, ' '         ; DL = ' '
            MOV AH, 02H
            INT 21H
            
            ADD SI, 2           ; SI += 2
            LOOP DISPLAY        ; Loop the DISPLAY untill CX becomes 0
        
        ;;;;;;;;;;;;;;;;;;;;;;;
        ; Termination              
        ;;;;;;;;;;;;;;;;;;;;;;;
        MOV AH, 4CH         ; AH = 4CH | To terminate the program execution
        INT 21H
    MAIN ENDP
END MAIN