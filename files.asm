; Program to handle files - Always stored at "C:\emu8086\MyBuild"

.MODEL SMALL

.STACK 100H

.DATA
    fname DB 'hello.txt', 0         ; 0 is must with file name
    fhandle DW ?
    prompt DB 'Enter data>> $'      ; Text to show in terminal
    buffer DB 11 DUP<'$'>           ; For the file to write data/text
    noc DW 11
    
    ; Macro to display a string
    MSG MACRO
        MOV AH, 09H
        LEA DX, prompt
        INT 21H
    MSG ENDM
    
    ; Macro to input a character
    CHRINPUT MACRO
        MOV AH, 01H
        INT 21H
    CHRINPUT ENDM
    
    ; Macro to input a string i.e. sequence of characters
    INPUT MACRO
        MOV SI, 0       ; Index of buffer
        MOV CX, 0
        
        AGAIN:          ; Loop - Enter characters / string
            CHRINPUT
            CMP AL, 13      ; Check if enter key is pressed
            JE STOP
            MOV buffer[SI], AL
            INC SI
            INC CX
            JMP AGAIN
        STOP:
            ;MSG 'Done!$'
    INPUT ENDM
    
    ; Macro to create a file
    CREATE MACRO
        MOV AH, 3CH
        LEA DX, fname
        MOV CL, 0
        INT 21H
        ;JC if_error
        MOV fhandle, AX
    CREATE ENDM
    
    ; Macro to open an existing file
    OPEN MACRO mode
        MOV AH, 3DH
        MOV AL, mode    ; 0-Read, 1-Write, 2-Both
        LEA DX, fname
        INT 21H
        ;JC if_error
        MOV fhandle, AX
    OPEN ENDM
    
    ; Macro to write into an opened file
    WRITE MACRO
        ; Get the data from user
        MSG
        INPUT
        
        ; Write
        MOV AH, 40H
        MOV BX, fhandle
        LEA DX, buffer
        MOV CX, noc         ; No need for now as text has already been input by the user
        INT 21H
        ;JC if_error
    WRITE ENDM
    
    ; Macro to read data from a file
    READ MACRO
        MOV AH, 3FH
        LEA DX, buffer
        MOV CX, noc
        MOV BX, fhandle
        INT 21H
        ;JC if_error
    READ ENDM
    
    ; Macro to exit/close a file
    EXIT MACRO
        MOV AH, 3EH
        MOV BX, fhandle
        INT 21H
        ;JC if_error
    EXIT ENDM

.CODE
    MAIN PROC FAR
        MOV AX, @DATA
        MOV DS, AX
        
        ; Create a new file
        ;CREATE fname, fhandle
        
        ; Open a file
        OPEN 2
        
        ; Write into a file
        WRITE
        
        ; Read from a file
        READ
        
        ; Close the file
        EXIT
        
        ; Terminate the program
        MOV AH, 4CH
        INT 21H
        
        MAIN ENDP
    END MAIN