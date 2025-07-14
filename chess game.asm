; Multiplayer Chess Game - Created by: Talha Ahmad (c)

.MODEL SMALL

.STACK 100H

.DATA
    ;;;;;;;;;;;;;;;;;
    ; Game Data     
    ;;;;;;;;;;;;;;;;;
    
    ; Game Board
    board DB 64 DUP('$')
    
    ; Positions
    position DB ?, ?        ; Current (selected) piece position
    destination DB ?, ?     ; Current (selected) piece destination
    resultant DB ?, ?       ; Resultant position derived on basis of current position and destination
    
    ; Players Score - P1, P2
    player_score DB 0, 0
    
    ; In-game flags - 0: False | 1: True - P1, P2
    checkmate_flag DB 0, 0  ; Is checkmate
    stalemate_flag DB 0, 0  ; Is stalemate  
    castle_flag DB 0, 0     ; Can Castle
    enpassant_flag DB 0, 0  ; Can Enpassant
    promotion_flag DB 0, 0  ; Can pawn be promoted
    
    ; Pieces - P1 (White), P2 (Black)
    pawn DB 'p', 'P'    ; Pawn - Advances forward one or two squares (one after the initial move), captures diagonally forward one square, and promotes upon reaching the eighth rank.
    rook DB 'r', 'R'    ; Rook - Moves horizontally or vertically any number of squares.
    knight DB 'n', 'N'  ; Knight - Moves in an "L" shape (two squares in one direction, then one square perpendicularly), uniquely able to jump over other pieces.
    bishop DB 'b', 'B'  ; Bishop - Moves diagonally any number of squares, remaining on squares of the same color.
    queen DB 'q', 'Q'   ; Queen - Moves any number of squares horizontally, vertically, or diagonally, combining the powers of the Rook and Bishop.
    king DB 'k', 'K'    ; King - Moves one square in any direction, and its capture signifies the end of the game (checkmate).
    
    ; Game Control
    game_over DB 0  ; Keep track if game is over
    turn DW 0       ; Keep track of turn
    moves DB 0, 0   ; Keep track of number of moves made by players
    
    ;;;;;;;;;;;;;;;
    ; Messages     
    ;;;;;;;;;;;;;;;
    
    ; Misc
    msg_loading DB 'Loading...$'
    
    ;;;;;;;;;;;;;;;;;;;;;;;
    ; Macros - Display
    ;;;;;;;;;;;;;;;;;;;;;;;
    
    ; Print a character
    PRINTC MACRO chr
        MOV AH, 02H
        MOV DL, chr
        INT 21H
    PRINTC ENDM
    
    ; Print a string
    PRINTS MACRO str
        MOV AH, 09H
        LEA DX, str
        INT 21H
    PRINTS ENDM
    
    ; Line break
    LINE_BREAK MACRO
        PRINTC 0DH
        PRINTC 0AH
    LINE_BREAK ENDM
    
    ; Clear Screen
    CLRSCR MACRO
        MOV AH, 00H
        MOV AL, 03H
        INT 10H
    CLRSCR ENDM

.CODE
    ; Entry Point
    MAIN PROC FAR
        ; Move all data to data segment register
        MOV AX, @DATA
        MOV DS, AX
        
        ; Testing
        PRINTS msg_loading
        
        CALL CLEAN_BOARD
        CLRSCR
        
        CALL DISPLAY_BOARD
        
        ; Terminate program execution
        MOV AH, 4CH
        INT 21H
    MAIN ENDP
    
    ;;;;;;;;;;;;;;;;;;;;;;;
    ; Board Procedures     
    ;;;;;;;;;;;;;;;;;;;;;;;
    
    ; Clean the board
    CLEAN_BOARD PROC
        MOV SI, 0
        CB_LOOP:
            ; Move a symbol to board at SI
            MOV board[SI], '.'
            
            ; Loop Control
            INC SI
            CMP SI, 64
            JB CB_LOOP
        
        RET
    CLEAN_BOARD ENDP
    
    ; Display Board
    DISPLAY_BOARD PROC
        MOV SI, 0
        DB_LOOP:
            ; Print the character of board at SI
            PRINTC board[SI]
            
            ; Check for line break at SI: 7, 15, 23, 31, 39, 47, 55, 63
            CMP SI, 7
            JE DB_LINE_BREAK
            
            CMP SI, 15
            JE DB_LINE_BREAK
            
            CMP SI, 23
            JE DB_LINE_BREAK
            
            CMP SI, 31
            JE DB_LINE_BREAK
            
            CMP SI, 39
            JE DB_LINE_BREAK
            
            CMP SI, 47
            JE DB_LINE_BREAK
            
            CMP SI, 55
            JE DB_LINE_BREAK
            
            CMP SI, 63
            JE DB_LINE_BREAK
            
            JMP DB_CONTROL
            
            ; Line Break to make board visually better
            DB_LINE_BREAK:
                LINE_BREAK
            
            ; Loop Control
            DB_CONTROL:
                INC SI
                CMP SI, 64
                JB DB_LOOP
        
        RET
    DISPLAY_BOARD ENDP

END MAIN
