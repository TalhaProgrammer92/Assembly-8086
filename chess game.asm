; Multiplay Chess Game - Created by: Talha Ahmad (c)

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
    game_over DB 0
    turn DW 0
    moves DB 0, 0

.CODE
    MAIN PROC FAR
        MOV AX, @DATA
        MOV DS, AX
        
        MOV AH, 4CH
        INT 21H
    MAIN ENDP
END MAIN
