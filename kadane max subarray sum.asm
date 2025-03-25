; Find out the maximum subarray sum of {3, -4, 5, 4, -1, 7, -8} by using Kadane's Algorithm

.MODEL SMALL

.STACK 100H

.DATA
    ; Array
    array DB 3, -4, 5, 4, -1, 7, -8
    size DW 7
    
    ; To store sum values
    current DB 0    ; Current sum
    result DB -128   ; Maximum sum (initialized to smallest possible signed byte)
    element DB ?    ; Current array element
    large DB ?      ; Store the largest number
    
    ; Store temporarily value
    temp1 DB ?
    temp2 DB ?
    
    ; Messages
    msg_process DB 'Finding the sum...$'
    msg_result DB 'The maximum subarray sum is $'
    
    ; Macro - Line break
    LINE_BREAK MACRO
        MOV DL, 0DH
        MOV AH, 02H
        INT 21H
        
        MOV DL, 0AH
        MOV AH, 02H
        INT 21H
    LINE_BREAK ENDM
    
    ; Macro - Display String
    PRINT MACRO str
        MOV AH, 09H
        LEA DX, str
        INT 21H
    PRINT ENDM

.CODE
    ; Main procedure
    MAIN PROC FAR
        MOV AX, @DATA
        MOV DS, AX
        
        ; Display process message
        PRINT msg_process
        LINE_BREAK
        
        ; Finding the max subarray sum
        MOV SI, 0
        MOV CX, size
        KADANE:
            ; Current Sum (Largest)
            MOV AL, array[SI]   ; Current array element
            MOV element, AL
            
            MOV AL, current     ; Current += element
            ADD AL, element
            MOV current, AL
            
            MOV AL, current     ; Assign temp1
            MOV temp1, AL
            
            MOV AL, element     ; Assign temp2
            MOV temp2, AL
            
            CALL MAX            ; Find the largest one
            
            MOV AL, large       ; Get largest
            MOV current, AL
            
            ; Maximum subarray sum
            MOV AL, result      ; Assign temp1
            MOV temp1, AL
            
            MOV AL, current     ; Assign temp2
            MOV temp2, AL
            
            CALL MAX            ; Find the largest one
            
            MOV AL, large       ; Get largest
            MOV result, AL     ; Fixed: Changed 'max' to 'result'
            
            ; Condition
            CMP current, 0
            JGE FLOW
            
            MOV current, 0      ; Assign current sum with 0
            
            FLOW:
                INC SI
                LOOP KADANE
        
        ; Display result message
        PRINT msg_result
        
        ; Display maximum subarray sum (Using stack due to multi-digit result)
        MOV AL, result  ; Sign extend to 16 bits
        MOV AH, 0
        CMP AX, 0
        JGE POSITIVE
        ; Handle negative numbers
        MOV DL, '-'
        MOV AH, 02H
        INT 21H
        NEG AX
        POSITIVE:
        MOV BX, 10
        MOV CX, 0
        
        PUSH_LOOP:
            CMP AX, 0       ; Check if AX is 0
            JE POP_LOOP
            
            INC CX          ; Increase CX by 1
            
            MOV DX, 0       ; Clear for unsigned division
            DIV BX          ; AX mod BX
            
            ADD DL, '0'     ; Convert to ASCII
            
            PUSH DX         ; Push the digit to stack
            JMP PUSH_LOOP   ; Loop pushing
        
        POP_LOOP:
            CMP CX, 0       ; Check if CX is 0
            JE EXIT
            
            DEC CX
            
            POP DX
            
            MOV AH, 02H
            INT 21H
            
            JMP POP_LOOP
        
        EXIT:
            MOV AH, 4CH
            INT 21H
    MAIN ENDP
    
    ; Find maximum number (signed comparison)
    MAX PROC
        ; Load the data to registers
        MOV AL, temp1
        MOV BL, temp2
        
        ; Compare (signed)
        CMP AL, BL
        JGE ASSIGN_LARGE
        MOV large, BL
        RET
        
        ASSIGN_LARGE:
            MOV large, AL
        RET
    MAX ENDP
        
END MAIN