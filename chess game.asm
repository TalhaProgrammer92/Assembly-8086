; Multiplayer Chess Game - Created by: Talha Ahmad (c)

.MODEL SMALL

.STACK 100H

.DATA
    ;;;;;;;;;;;;;;;;;
    ; Game Data     
    ;;;;;;;;;;;;;;;;;
    
    ; Game Board
    board DB 64 DUP('$')
    labels_alpha DB 'abcdefgh$'
    labels_num DB '12345678$'
    
    ; Positions
    position DB ?, ?        ; Current (selected) piece position
    destination DB ?, ?     ; Current (selected) piece destination
    resultant DB ?, ?       ; Resultant position derived on basis of current position and destination
    
    ; Players - P1, P2
    player_score DB 0, 0
    player_name DB 'White$', 'Black$'
    
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
    
    ; Misc
    index DW ?  ; Hold index of an array/string if registers are full
    
    ;;;;;;;;;;;;;;;
    ; Messages     
    ;;;;;;;;;;;;;;;
    
    ; Misc
    msg_loading DB 'Loading...$'
    
    msg_turn DB 'Turn of $'
    
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
    
    ; Display player's turn
    DISPLAY_TURN MACRO
        LINE_BREAK
        
        PRINTS msg_turn
        
        MOV SI, turn
        PRINTS player_name[SI]
        
        PRINTC '!'
        
        LINE_BREAK
    DISPLAT_TURN ENDM
    
    ;;;;;;;;;;;;;;;;;;;;;
    ; Macros - Piece
    ;;;;;;;;;;;;;;;;;;;;;
    
    ; Place piece - piece [Byte] | cell [Address]
    PLACE_PIECE MACRO piece, cell
        MOV AL, piece
        MOV cell, AL
    PLACE_PIECE ENDM
    
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; Macros - Game Control     
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    ; Update game stat
    UPDATE_GAME_STAT MACRO
        XOR turn, 1
        INC moves
    UPDATE_GAME_STAT ENDM

.CODE
    ; Entry Point
    MAIN PROC FAR
        ; Move all data to data segment register
        MOV AX, @DATA
        MOV DS, AX
        
        ; Testing
        PRINTS msg_loading
        
        CALL CLEAN_BOARD
        CALL PLACE_PIECES_INIT
        
        CLRSCR
        
        CALL DISPLAY_BOARD
        
        DISPLAY_TURN
        
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
        ; Labels - a to h
        PRINTC ' '
        PRINTC ' '
        MOV SI, 0
        DB_LABELS_LOOP:
            ; Display labels
            PRINTC labels_alpha[SI]
            PRINTC ' '
            
            ; Control Loop
            INC SI
            CMP SI, 8
            JB DB_LABELS_LOOP
        
        ; Break the line
        LINE_BREAK
        
        ; Grid
        MOV SI, 0
        MOV index, 0
        DB_LOOP:
            ; Check if SI at start of row
            MOV BX, SI
            DEC BX
            AND BX, 07H
            CMP BX, 07H
            JNE DB_CELL
            
            ; Print the number label at index
            MOV BX, index
            PRINTC labels_num[BX]
            PRINTC ' '
            INC index
        
            ; Print the character of board at SI
            DB_CELL:
                PRINTC board[SI]
                PRINTC ' '  ; Gap b/w each cell
            
            ; Check for line break at SI: 7, 15, 23, 31, 39, 47, 55, 63
            MOV BX, SI
            AND BX, 07H      ; check lower 3 bits '111'
            CMP BX, 07H
            JE DB_LINE_BREAK
            
            JMP DB_CONTROL  ; If no line break require
            
            ; Line Break to make board visually better
            DB_LINE_BREAK:
                LINE_BREAK
            
            ; Loop Control
            DB_CONTROL:
                INC SI
                
                CMP SI, 64  ; '64' is total grid area (no. of cells)
                JB DB_LOOP
        
        RET
    DISPLAY_BOARD ENDP
    
    ;;;;;;;;;;;;;;;;;;;;;;;
    ; Piece Procedures     
    ;;;;;;;;;;;;;;;;;;;;;;;
    
    ; Place all pieces to initial positions on board
    PLACE_PIECES_INIT PROC
        ; Pawn
        MOV SI, 0
        PPI_PAWN:
            ; White
            MOV BX, SI
            ADD BX, 48  ; Start from 7th row
            PLACE_PIECE pawn[0], board[BX]
            
            ; Black
            MOV BX, SI
            ADD BX, 8   ; Start from 2nd row
            PLACE_PIECE pawn[1], board[BX]
            
            ; Loop Control
            INC SI
            CMP SI, 8
            JB PPI_PAWN
        
        ; Rook - White
        PLACE_PIECE rook[0], board[56]
        PLACE_PIECE rook[0], board[63]
        
        ; Rood - Black
        PLACE_PIECE rook[1], board[0]
        PLACE_PIECE rook[1], board[7]
        
        
        ; Knight - White
        PLACE_PIECE knight[0], board[57]
        PLACE_PIECE knight[0], board[62]
        
        ; Knight - Black
        PLACE_PIECE knight[1], board[1]
        PLACE_PIECE knight[1], board[6]
        
        
        ; Bishop - White
        PLACE_PIECE bishop[0], board[58]
        PLACE_PIECE bishop[0], board[61]
        
        ; Bishop - Black
        PLACE_PIECE bishop[1], board[2]
        PLACE_PIECE bishop[1], board[5]
        
        
        ; Queen - White
        PLACE_PIECE queen[0], board[59]
        
        ; Queen - Black
        PLACE_PIECE queen[1], board[3]
                                     
                                     
        ; King - White
        PLACE_PIECE king[0], board[60]
        
        ; King - Black
        PLACE_PIECE king[1], board[4]
        
        RET
    PLACE_PIECES_INIT ENDP

END MAIN
