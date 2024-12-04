.MODEL SMALL

.STACK 100H

.DATA
    ;;;;;;;;;;;;;;;;;        
    ; Variables
    ;;;;;;;;;;;;;;;;;

    ; This program counts the number of words in the following given string
    str DB 'Assembly language is a low-level programming language that provides a symbolic representation of machine code instructions. It offers programmers direct control over hardware, making it ideal for tasks requiring optimal performance or specific hardware interactions. While assembly language is more complex and time-consuming to write compared to high-level languages, it enables fine-grained optimization and is essential for tasks like system programming, device drivers, and embedded systems.$'
    
    msgc DB 'Counting...$'      ; Message to display before start counting
    msgs DB 'Words Count: $'    ; Message to display before showing the number of words
    words DW 0                  ; To keep track of (count) total number of words in the given string
    
    ;;;;;;;;;;;;;;;;;        
    ; Macroes
    ;;;;;;;;;;;;;;;;;
    
    ; Macro - Print string
    PRINT MACRO statement
        MOV AH, 09H             ; AH = 09h
        LEA DX, statement       ; DX = &statement
        INT 21H                 ; Interupt DOS
    PRINT ENDM
    
    ; Macro - Line break
    ENDL MACRO
        ; New line
        MOV DL, 0DH     ; DL = 0dh
        MOV AH, 02H     ; AH = 02h
        INT 21H         ; Interupt DOS
        
        ; Goto starting point
        MOV DL, 0AH     ; DL = 0ah
        MOV AH, 02H     ; AH = 02h
        INT 21H         ; Interupt DOS
    ENDL ENDM

.CODE
    MAIN PROC FAR
        MOV AX, @DATA   ; AX = &DATA
        MOV DS, AX      ; DS = AX
        
        ;;;;;;;;;;;;;;;;;;;;;;;;;        
        ; Count words
        ;;;;;;;;;;;;;;;;;;;;;;;;;
        
        ; Print 'msgc' to the console
        PRINT msgc
        ENDL
        
        MOV SI, 0   ; Source Index: 0
        ; True case (2)
        COUNT:
            CMP str[SI], ' '    ; Compare str[SI] with ' '
            JNE SKIP            ; if str[SI] != ' ' ____(1)
            INC words           ; word++ - False case (1)
            
            ; True case (1)
            SKIP:
               INC SI               ; SI++
               CMP str[SI], '$'     ; Compare str[SI] with '$'
               JNE COUNT            ; if str[SI] != '$' ____(2)
        
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        ; Display - False case (2)           
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        
        PRINT msgs      ; Print 'msgc' to the console
        INC words       ; words++
        MOV AX, words   ; AX = words - D
        MOV BX, 10      ; BX = 10 - N
        MOV CX, 0       ; CX = 0
        
        ; Push digits onto the stack
        PUSHL:
            CMP AX, 0       ; Compare AX with 0
            JE POPL         ; if AX = 0 ____(3)
                            
            ; False case (3)
            INC CX          ; CX++
            MOV DX, 0       ; DX = 0 - For unsigned division
            DIV BX          ; AX/BX
            ADD DL, '0'     ; DL + '0' - DL is remainder
            PUSH DX         ; DX >> Stack
            JMP PUSHL       ; Goto PUSHL

        ; Pop digits from the stack - True case (3)
        POPL:
            CMP CX, 0       ; Compare CX with 0
            JE EXIT         ; if CX = 0 ____(4)
            
            ; False case (4)
            DEC CX          ; CX--
            POP DX          ; DX << Stack
            MOV AH, 02H     ; AH = 02h
            INT 21H         ; Interupt DOS
            JMP POPL        ; Goto POPL
        
        ; Program Termination - True case (4)
        EXIT:
            MOV AH, 4CH     ; AH = 4ch
            INT 21H         ; Interupt DOS
    MAIN ENDP
END MAIN
