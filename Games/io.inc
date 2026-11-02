; Print a single character on the console
PRINTC MACRO chr
    MOV AH, 02h
    MOV DL, chr
    INT 21h
PRINTC ENDM

; Add a line break
LINE_BREAK MACRO
    PRINTC 0Dh
    PRINTC 0Ah
LINE_BREAK ENDM

; Print a string on the console          
PRINTS MACRO str
    MOV AH, 09h
    LEA DX, str
    INT 21h
PRINTS ENDM

; Print a string on the console with line break
PRINTSL MACRO str
    PRINTS str
    LINE_BREAK
PRINTSL ENDM

; Take input -> stores in AL
INPUT MACRO
    MOV AH, 01h
    INT 21h
INPUT ENDM

; Clear Console
CLRSCR MACRO
    MOV AH, 00h
    MOV AL, 02h
    INT 10h
CLRSCR ENDM
