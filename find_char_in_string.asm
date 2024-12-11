; Program to check whether a character is in a string or not

.MODEL SMALL

.STACK 100H

.DATA
    exist DB 'Found!$'          ; Message to display when character is found
    nexist DB 'Not Found!$'     ; Message to display when character is not found
    
    str DB 'Talha Ahmad$'       ; The string to scan for the character
    find DB 'h'                 ; The character to search in
    
    length EQU $-str            ; The length of the string

.CODE
    MAIN PROC FAR
        MOV AX, @DATA
        MOV DS, AX
        MOV ES, AX      ; Requirement of SCANSB
        
        
        MOV CX, length  ; Assigning CX to (length) of the (str)
        CLD             ; Clear direction flag
        
        MOV AL, find            ; Assigning AL to the character we've to (find)
        MOV DI, OFFSET str      ; Assigning DI to the address of the (Str)
        
        REPNE SCASB     ; Repeat till the end point of the (str). SCASB (Scan String Byte) is used to scan a string for a character
        JE YES          ; If zero flag is 1
        JMP NO          ; If zero flag is 0
        
        YES:
            ; Display (exist) string
            MOV AH, 09H
            LEA DX, exist
            INT 21H
            JMP EXIT
        
        NO:
            ; Display (nexit) string
            MOV AH, 09H
            LEA DX, nexist
            INT 21H
        
        EXIT:
            ; Terminate the program
            MOV AH, 4CH
            INT 21H
    MAIN ENDP
END MAIN