; Selection Sort - Algorithm (Just for Fun)

.MODEL SMALL

.STACK 100H

.DATA
    ; Variables/Arrays
    array DB 7, 2, 4, 3, 9, 8, 6, 5, 1, 0
    size DW 10
    
    small DW ?
    temp DW ?
    num DB ?
    
    msg_sorting DB 'Sorting...$'
    msg_array DB 'Array: $'
    
    ;;;;;;;;;;;;;
    ; Macros     
    ;;;;;;;;;;;;;
    
    ; Print string
    PRINTS MACRO str
        MOV AH, 09H
        LEA DX, str
        INT 21H
    PRINTS ENDM
    
    ; Print number
    PRINTN MACRO num
        MOV AH, 02H
        MOV DL, num
        ADD DL, '0'
        INT 21H
    PRINTN ENDM

    ; Print character
    PRINTC MACRO chr
        MOV AH, 02H
        MOV DL, chr
        INT 21H
    PRINTC ENDM
    
    ; New line - line break
    NEW_LINE MACRO
        PRINTC 0DH
        PRINTC 0AH
    NEW_LINE ENDM
    
    ; Swap two numbers
    SWAP MACRO num1, num2
        MOV AH, 0
        
        MOV AL, num1
        MOV num, AL
        
        MOV AL, num2
        MOV num1, AL
        
        MOV AL, num
        MOV num2, AL
    SWAP ENDM

.CODE
    ;;;;;;;;;;;;;;;;;
    ; Procedures     
    ;;;;;;;;;;;;;;;;;
    
    ; Entry Point
    MAIN PROC FAR
        ; Move data to data segment register
        MOV AX, @DATA
        MOV DS, AX
        
        ; Print (unsorted) array
        CALL PRINT_ARRAY
        
        ; Sorting the array
        CALL SORT       
        
        ; Print (sorted) array
        CALL PRINT_ARRAY
        
        ; Terminate the program execution
        MOV AH, 4CH
        INT 21H
    MAIN ENDP
    
    ; Print the array
    PRINT_ARRAY PROC
        PRINTS msg_array
        
        MOV SI, 0
        PA_LOOP:
            ; Print number
            PRINTN array[SI]
            
            ; Print gap
            PRINTC ' '
            
            ; Loop Control
            INC SI
            CMP SI, size
            JB PA_LOOP
        
        NEW_LINE
        
        RET
    PRINT_ARRAY ENDP
    
    ; Sorting the array
    SORT PROC
        ; Display message
        PRINTS msg_sorting
        NEW_LINE
        
        ; Traverse the array
        MOV SI, 0
        SORT_OUTER:
            ; Set small index
            MOV small, SI
            
            ; Preserve SI
            MOV temp, SI
            
            ; Find the smallest element's index
            MOV BX, SI
            INC BX
            SORT_INNER:
                MOV SI, small   ; Get smallest element's index

                ; Check if array[SI] >= array[BX]
                MOV AH, 0
                MOV AL, array[SI]
                CMP AL, array[BX]
                JL SI_CONTROL
                
                ; Update the small index
                MOV small, BX
                
                ; Loop Control - Inner
                SI_CONTROL:
                
                INC BX
                CMP BX, size
                JL SORT_INNER
            
            ; Reterieve the preserved SI
            MOV SI, temp
            
            ; Get smallest element index
            MOV BX, small
                                        
            ; Swap the elements         
            SWAP array[SI], array[BX]
                 
            ; Loop Control - Outer   
            INC SI
            MOV AX, size
            DEC AX
            CMP SI, AX
            JL SORT_OUTER
        
        RET
    SORT ENDP
    
END MAIN
    
