;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                              ;
; @@@@@@@@@@@@@@@@@@@@@  MULTIPLAYER CHESS GAME - 8086  @@@@@@@@@@@@@@@@@@@@@@ ;
;                                                                              ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                              ;
;  Developer   : Talha Ahmad                                                   ;
;  Platform    : emu8086                                                       ;
;  Language    : Assembly Language (8086)                                      ;
;                                                                              ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                              ;
;  Game Features:                                                              ;
;  ----------------                                                            ;
;  • Complete Multiplayer Chess Game                                           ;
;  • Full Chess Rules Implementation                                           ;
;  • Legal Piece Movement Validation                                           ;
;  • Check Detection                                                           ;
;  • Checkmate Detection                                                       ;
;  • Stalemate Detection                                                       ;
;  • Turn-Based Gameplay                                                       ;
;  • Text / Graphic Board Rendering                                            ;
;  • Player vs Player Mode (No AI)                                             ;
;                                                                              ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                              ;
;  Purpose of the Project:                                                     ;
;  ------------------------                                                    ;
;  This project is developed to explore low-level programming concepts         ;
;  using Assembly8086 and emu8086. The goal is to implement a fully            ;
;  functional chess game while improving understanding of memory,              ;
;  registers, procedures, game logic, and graphics handling in assembly.       ;
;                                                                              ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                              ;
;  Fun Message:                                                                ;
;  ------------                                                                ;
;  "In high-level languages you play the game...                               ;
;   In Assembly, you fight the hardware too."                                  ;
;                                                                              ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


.MODEL SMALL
.STACK 100h

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                               DATA SOURCE                                    ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.DATA
    ; <----- Messages -----> ;
    welcome_msg DB 'Welcome to my Chess Game!$'
    game_over_msg DB 'Game is Over!$'
    
    continue_msg DB 'Press any key to continue...$'
    turn_msg DB 'The turn of Player $'
    
    ; <----- Board -----> ;
    board DB 64 DUP('$')
    
    selected_piece DB ?
    board_index DB ?
    
    white_pawn DB 'P'
    white_knight DB 'N'
    white_bishop DB 'B'
    white_rook DB 'R'
    white_queen DB 'Q'
    white_king DB 'K'
    
    black_pawn DB 'p'
    black_knight DB 'n'
    black_bishop DB 'b'
    black_rook DB 'r'
    black_queen DB 'q'
    black_king DB 'k'
    
    ; [0] - Row | [1] - Column
    current_position DB ?, ?
    target_position DB ?, ?
    absolute_position DB ?, ?
    
    ; <----- Game -----> ;
    turn DB 0
    
    ; 0-False | 1-True
    game_over_flag DB 0 ; To check if the game is over or not
    check_flag DB 0     ; To chcck if king is in check or not
    checkmate_flag DB 0 ; To check if there's a checkmate
    stalemate_flag DB 0 ; To check if there's a stalemate
    promotion_flag DB 0 ; To check if pawn can be promoted
    enpassant_flag DB 0 ; To check if enpassant can happen by pawn
    castling_flag DB 0  ; To check if castling can happen by king and rook

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;                                 MACROS                                   ;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    ; <----- To print a character -----> ;
    PRINTC MACRO chr
        MOV AH, 02h
        MOV DL, chr
        INT 21h
    PRINTC ENDM
    
    ; <----- To print a string -----> ;
    PRINTS MACRO str
        MOV AH, 09h
        LEA DX, str
        INT 21h
    PRINTS ENDM
    
    ; <----- To do a line break -----> ;
    LINE_BREAK MACRO
        PRINTC 0Dh
        PRINTC 0Ah
    LINE_BREAK ENDM
    
    ; <----- To clear the terminal -----> ;
    CLRSCR MACRO
        MOV AH, 00h
        MOV AL, 03h
        INT 10h
    CLRSCR ENDM

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                               CODE SOURCE                                    ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.CODE
    ; <----- Program's entry point -----> ;
    MAIN PROC
        ; Moving data to the data segment register
        MOV AX, @DATA
        MOV DS, AX
        
        ; Testing...
        CALL CLEAR_BOARD
        CALL PLACE_PIECES
        
        ; Terminating the program
        MOV AH, 4ch
        INT 21h
    MAIN ENDP
    
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;                           BOARD PROCEDURES                               ;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    ; <----- Clear the game board -----> ;
    CLEAR_BOARD PROC
        MOV SI, 0
        CB_LOOP:
            MOV board[SI], '-'
            INC SI
            CMP SI, 64
            JB CB_LOOP
        
        RET
    CLEAR_BOARD ENDP
    
    ; <----- Place all pieces on the board -----> ;
    PLACE_PIECES PROC
        ;;;;;;;;;; WHITE PIECES ;;;;;;;;;;
        
        ; Pawns
        MOV SI, 8
        MOV CX, 8
        MOV AL, white_pawn
        PPWP_LOOP:
            MOV board[SI], AL
            INC SI
            LOOP PPWP_LOOP 
        
        ; Knights
        MOV AL, white_knight
        MOV board[1], AL
        MOV board[6], AL
        
        ; Bishops
        MOV AL, white_bishop
        MOV board[2], AL
        MOV board[5], AL
        
        ; Rooks
        MOV AL, white_rook
        MOV board[0], AL
        MOV board[7], AL
        
        ; Queen
        MOV AL, white_queen
        MOV board[3], AL
        
        ; King
        MOV AL, white_king
        MOV board[4], AL
        
        ;;;;;;;;;; BLACK PIECES ;;;;;;;;;;
        
        ; Pawns
        MOV SI, 48
        MOV CX, 8
        MOV AL, black_pawn
        PPBP_LOOP:
            MOV board[SI], AL
            INC SI
            LOOP PPBP_LOOP 
        
        ; Knights
        MOV AL, black_knight
        MOV board[57], AL
        MOV board[62], AL
        
        ; Bishops
        MOV AL, black_bishop
        MOV board[58], AL
        MOV board[61], AL
        
        ; Rooks
        MOV AL, black_rook
        MOV board[56], AL
        MOV board[63], AL
        
        ; Queen
        MOV AL, black_queen
        MOV board[59], AL
        
        ; King
        MOV AL, white_king
        MOV board[60], AL
        
        RET
    PLACE_PIECES ENDP

END MAIN