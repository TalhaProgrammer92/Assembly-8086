; PROGRAM TO PRINT COLORED CAHRACTER IN THE TERMINAL

.MODEL SMALL

.STACK 100H

.DATA
    CHR DB 'T'  ; THE CHARACTER TO PRINT

.CODE

MAIN PROC FAR
    MOV AX, @DATA
    MOV DS, AX

    ; PRINT COLORED TEXT
    MOV AH, 09H
    MOV AL, CHR   ; CHARACTER TO PRINT
    MOV BH, 00H   ; PAGE NUMBER
    MOV BL, 42H   ; COLOR ATTRIBUTE (FG: Red, BG: Green)
    MOV CX, 1     ; NUMBER OF TIMES TO PRINT CHARACTER
    INT 10H

    ; EXIT PROGRAM
    MOV AX, 4CH
    INT 21H
MAIN ENDP

END MAIN

;;;;;;;;;;;;;;; Color Codes ;;;;;;;;;;;;;;;

; Background Colors (0-7)

; 0: Black
; 1: Blue
; 2: Green
; 3: Cyan
; 4: Red
; 5: Magenta
; 6: Brown
; 7: Light Gray


; Foreground Colors (0-15)

; 0: Black
; 1: Blue
; 2: Green
; 3: Cyan
; 4: Red
; 5: Magenta
; 6: Brown
; 7: Light Gray
; 8: Dark Gray
; 9: Light Blue
; A: Light Green
: B: Light Cyan
; C: Light Red
; D: Light Magenta
; E: Yellow
; F: White

; # Example: 1Eh: Yellow on Blue
