;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Program to print the following pattern ;
; **********                             ;
; *|======|*                             ;
; *|=~~~~=|*                             ;
; *|=|××|=|*                             ;
; *|=|××|=|*                             ;
; *|=<__>=|*                             ;
; *|======|*                             ;
; *|======|*                             ;
; **********                             ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.MODEL SMALL

.STACK 100H

.DATA
    ; Variables - Decoration for the pattern
    outline DB '*'
    wall_separator DB '|'
    wall_tile DB '='
    window_glass DB 'x'
    window_roof DB '~'
    window_bottom DB '_'
    window_corner_left DB '<'
    window_corner_right DB '>'
    char DB ?
    
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; MACROs - Terminal Manipulation ;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    ; Print a character in terminal
    PRINT MACRO chr
        MOV AH, 02H
        MOV DL, chr
        INT 21H
    PRINT ENDM
    
    ; Move the cursor to next line/row in terminal
    LINE_BREAK MACRO
        PRINT 0DH
        PRINT 0AH
    LINE_BREAK ENDM
    
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; MACROs - Pattern Printing ;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    ; Top/Bottom Lines [**********]
    PATTERN_LINE MACRO
        MOV CX, 10
        MOV AL, outline
        CALL PRINT_LINE
        
        LINE_BREAK
    PATTERN_LINE ENDM
    
    ; Border Printing - Left [*|]
    PATTERN_BORDER_LEFT MACRO
        PRINT outline
        PRINT wall_separator
    PATTERN_BORDER_LEFT ENDM
    
    ; Window Border Printing - Left [*|=]
    PATTERN_WINDOW_BORDER_LEFT MACRO
        PRINT outline
        PRINT wall_separator
        PRINT wall_tile
    PATTERN_BORDER_LEFT ENDM
    
    ; Border Printing - Right [|*]
    PATTERN_BORDER_RIGHT MACRO
        PRINT wall_separator
        PRINT outline
    PATTERN_BORDER_RIGHT ENDM
    
    ; Window Border Printing - Right [=|*]
    PATTERN_WINDOW_BORDER_RIGHT MACRO
        PRINT wall_tile
        PRINT wall_separator
        PRINT outline
    PATTERN_WINDOW_BORDER_RIGHT ENDM
    
    ; Normal Line [*|======|*]
    PATTERN_NORMAL_LINE MACRO
        ; Border - Left
        PATTERN_BORDER_LEFT
        
        ; Wall Line
        MOV CX, 6
        MOV AL, wall_tile
        CALL PRINT_LINE
        
        ; Border - Right
        PATTERN_BORDER_RIGHT
        
        LINE_BREAK
    PATTERN_NORMAL_LINE ENDM
    
    ; Window Roof Line [*|=~~~~=|*]
    PATTERN_WINDOW_ROOF_LINE MACRO
        ; Window Border - Left
        PATTERN_WINDOW_BORDER_LEFT
        
        ; Window - Roof
        MOV CX, 4
        MOV AL, window_roof
        CALL PRINT_LINE
                 
        ; Window Border - Right   
        PATTERN_WINDOW_BORDER_RIGHT
        
        LINE_BREAK
    PATTERN_WINDOW_ROOF_LINE ENDM
    
    ; Window Body Line [*|=|××|=|*]
    PATTERN_WINDOW_BODY_LINE MACRO
        ; Window Border - Left
        PATTERN_WINDOW_BORDER_LEFT
        
        ; Window - Body
        PRINT wall_separator
        
        MOV CX, 2
        MOV AL, window_glass
        CALL PRINT_LINE
        
        PRINT wall_separator
                 
        ; Window Border - Right   
        PATTERN_WINDOW_BORDER_RIGHT
        
        LINE_BREAK
    PATTERN_WINDOW_BODY_LINE ENDM
    
    ; Window Bottom Line [*|=<__>=|*]
    PATTERN_WINDOW_BOTTOM_LINE MACRO
        ; Window Border - Left
        PATTERN_WINDOW_BORDER_LEFT
        
        ; Window - Roof
        PRINT window_corner_left
        
        MOV CX, 2
        MOV AL, window_bottom
        CALL PRINT_LINE         
        
        PRINT window_corner_right
                 
        ; Window Border - Right   
        PATTERN_WINDOW_BORDER_RIGHT
        
        LINE_BREAK
    PATTERN_WINDOW_BOTTOM_LINE ENDM
    
.CODE
    ; Entry Point
    MAIN PROC FAR
        ; Moving data to DS register
        MOV AX, @DATA
        MOV DS, AX
        
        ; Pattern printing
        CALL DRAW_PATTERN
        
        ; Program Termination
        MOV AH, 4CH
        INT 21H
    MAIN ENDP
    
    ; Procedure - Entry point for the pattern printing
    DRAW_PATTERN PROC
        ; Top - Line
        PATTERN_LINE
        
        ; Top - Normal Line
        PATTERN_NORMAL_LINE
        
        ; Top - Window (Roof)
        PATTERN_WINDOW_ROOF_LINE
        
        ; Body - Window
        PATTERN_WINDOW_BODY_LINE
        PATTERN_WINDOW_BODY_LINE
        
        ; Bottom - Window
        PATTERN_WINDOW_BOTTOM_LINE
        
        ; Bottom - Normal Lines
        PATTERN_NORMAL_LINE
        PATTERN_NORMAL_LINE
        
        ; Bottom - Line
        PATTERN_LINE
        
        RET
    DRAW_PATTERN ENDP
    
    ; Procedure - Print a line of length N (CX), characters (AL)
    PRINT_LINE PROC
        MOV char, AL
        PL_LOOP:
            PRINT char
            LOOP PL_LOOP
        RET
    PRINT_LINE ENDP

END MAIN
