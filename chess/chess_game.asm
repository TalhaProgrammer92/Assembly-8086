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
        PRINTC 0Ah
        PRINTC 0Dh
    LINE_BREAK ENDM

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                               CODE SOURCE                                    ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.CODE
    ; <----- Program's entry point -----> ;
    MAIN PROC FAR
        ; Moving data from data source to the data segment register
        MOV AX, @DATA
        MOV DS, AX
        
        ; Display a welcome message
        PRINTS welcome_msg
        
        ; Terminating the program
        MOV AH, 4ch
        INT 21h
    MAIN ENDP

END MAIN