; A complete program to sort an array containing single and multi digit numbers i.e. words

.MODEL SMALL

.STACK 100H

.DATA
    numbers DW 86, 42, 15, 77, 66, 25, 35, 92, 86, 73, 51, 12, 78, 20, 59, 5, 9, 4, 42, 13
    size EQU 20
    last_index DW ?
    temp DW ?
    
    msg_sorting DB 'Sorting the array...$'
    msg_result DB 'Sorted array: $'

    ; Macro - Display string
    PRINTS MACRO string
        MOV AH, 09H
        LEA DX, string
        INT 21H
    PRINTS ENDM
    
    ; Macro - Display character
    PRINTC MACRO character
        MOV DL, character
        MOV AH, 02H
        INT 21H
    PRINTC ENDM
    
    ; Macro - Line break
    ENDL MACRO
        PRINTC 0DH
        PRINTC 0AH
    ENDL ENDM

    ; Macro - Print number (word)
    PRINTN MACRO number
        CMP number, 9
        JLE NORMAL
        
        MOV AX, number      ; Moves value of 'number' to AX
        MOV BX, 10          ; To divide the AX with BX
        MOV CX, 0           ; Set up the loop count
        
        PUSHL:              ; Pushing onto stack
            CMP AX, 0
            JE POPL
            INC CX
            MOV DX, 0       ; Clear DX for unsigned division
            DIV BX          ; Divide by 10
            ADD DL, '0'     ; Convert remainder to ASCII digit
            PUSH DX
            JMP PUSHL
        
        POPL:               ; Print the digits
            CMP CX, 0
            JE CONT
            DEC CX
            POP DX
            MOV AH, 02h
            INT 21h
            JMP POPL
            JMP CONT
        
        NORMAL:
            MOV DX, number
            ADD DX, '0'
            MOV AH, 02H
            INT 21H
            JMP CONT
    PRINTN ENDM

.CODE
    MAIN PROC FAR
        MOV AX, @DATA
        MOV DS, AX
        
        ;;;;;;;;;;;;;;;;;;;;;;;;;;
        ; Display a message
        ;;;;;;;;;;;;;;;;;;;;;;;;;;
        PRINTS msg_sorting
        ENDL
        
        ;;;;;;;;;;;;;;;;;;;;;;
        ; Bubble sort
        ;;;;;;;;;;;;;;;;;;;;;;
         MOV CX, 0           ; Outer - counter
        
        ; Outer - loop
        OUTER:
            MOV SI, 0           ; Index of number
            MOV BX, 0           ; Inner - counter
            
            ; Inner - loop
            INNER:
                MOV DX, numbers[SI]             ; DX = number[SI]
                CMP DX, numbers[SI + 2]         ; Compare DX with number[SI + 2] | numbers[SI + 2] is the value located after numbers[SI]
                JLE SKIP                        ; IF DX <= numbers[SI + 2] THEN GOTO SKIP
                
                ; Swap
                MOV temp, DX                    ; temp = DX | DX is numbers[SI]
                
                MOV AX, numbers[SI + 2]         ; AX = numbers[SI + 2]
                MOV numbers[SI], AX             ; numbers[SI] = AX
                
                MOV AX, temp                    ; AX = temp
                MOV numbers[SI + 2], AX         ; numbers[SI + 2] = AX
                
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
        
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        ; Calculating last index
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        MOV last_index, 0
        MOV CX, size
        DEC CX
        COUNT:
            ADD last_index, 2
            LOOP COUNT
        
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        ; Display sorted array
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        PRINTS msg_result
        MOV SI, 0           ; SI = 0
        
        DISPLAY:
            PRINTN numbers[SI]
            
            CONT:
                PRINTC ' '
                ADD SI, 2           ; SI += 2
                CMP SI, last_index
                JLE DISPLAY
                
        
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        ; Program termination
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        EXIT:
            MOV AH, 4CH
            INT 21H
    MAIN ENDP
END MAIN