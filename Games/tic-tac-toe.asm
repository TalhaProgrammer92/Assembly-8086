;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; (c) Talha Ahmad - All Rights are Reserved 2026             ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; <-----> ^ c--->  <----->   ^    c--->  <-----> c---c c---> ;
;    |    | |         |     / \   |         |    |   | |__   ;
;    |    | |         |    /---\  |         |    |   | |     ;
;    v    v c--->     v   /     \ c--->     v    c---c c---> ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   
INCLUDE 'io.inc'

.MODEL SMALL

.STACK 100h

.DATA
    ;;;;;;;;;;;;
    ; Messages ;
    ;;;;;;;;;;;;
    msg_welcome DB 'Welcome to Tic Tac Toe!$'
    msg_about DB 'Created by Talha Ahmad on Thursday 29th October, 2026.$'
    msg_hold DB 'Press any key to continue...$'
    msg_replay DB 'Do you want to play again (Y/N)? $'
    msg_ply_sym_input DB 'Enter symbol for the player: $'
    
    alert_sym_already_taken DB 'The symbol you have selected is already taken!$'
    
    ;;;;;;;;;;;;;;;;;;
    ; Game Variables ;
    ;;;;;;;;;;;;;;;;;;
    
    ; Players
    players DB ?, ?
    
    ; Board
    board DB 9 DUP('$')
    
    ; Flags | 0-False, 1-True
    game_over DB ?
    is_bard_filled DB ?
    
    ; Storage
    var DB ?
    
    ;;;;;;;;;;
    ; Macros ;
    ;;;;;;;;;;
    
    ; Welcome screen
    WELCOME Macro
        PRINTSL msg_welcome
        PRINTSL msg_about
        LINE_BREAK
        
        PRINTS msg_hold
        INPUT
        
        CLRSCR
    WELCOME ENDM

.CODE
    ;;;;;;;;;;;;;;;;;;;;
    ; Main Entry Point ;
    ;;;;;;;;;;;;;;;;;;;;
    
    MAIN PROC FAR
        MOV AX, @DATA
        MOV DS, AX
        
        ;WELCOME
        ;CALL CLEAR_BOARD
        ;CALL DISPLAY_BOARD
        
        CALL TAKE_PLAYERS_SYMBOL
        
        MOV AH, 4ch
        INT 21h
    MAIN ENDP
    
    ;;;;;;;;;;;;;;;;;;;;;;
    ; Procedures - Board ;
    ;;;;;;;;;;;;;;;;;;;;;;
    
    ; Clear the board
    CLEAR_BOARD PROC
        MOV SI, 0
        MOV AL, '1'
        CB_LOOP:
            MOV board[SI], AL
            
            INC AL
            
            INC SI
            CMP SI, 9
            
            JB CB_LOOP
        
        RET
    CLEAR_BOARD ENDP
    
    ; Display Board
    DISPLAY_BOARD PROC
        MOV SI, 0
        DB_LOOP:
            PRINTC board[SI]
            PRINTC ' '
            
            CMP SI, 2
            JE DBL_LB
            CMP SI, 5
            JE DBL_LB
            CMP SI, 8
            JE DBL_LB
            JMP DBL_FLOW
            
            DBL_LB:
                LINE_BREAK
            
            DBL_FLOW:
                INC SI
                CMP SI, 9
                JB DB_LOOP
        
        RET
    DISPLAY_BOARD ENDP
    
    ;;;;;;;;;;;;;;;;;;;;;;;
    ; Procedures - Player ;
    ;;;;;;;;;;;;;;;;;;;;;;;
    
    ; Take players' input for symbols
    TAKE_PLAYERS_SYMBOL PROC
        MOV SI, 0
        TPS_LOOP:
            LINE_BREAK
            PRINTS msg_ply_sym_input
            INPUT
            MOV var, AL
            
            CMP SI, 0
            JE TPSL_FLOW
            
            ; Comparison
            MOV AL, players[0]
            CMP AL, var
            JNE TPSL_FLOW
            
            LINE_BREAK
            PRINTS alert_sym_already_taken
            JMP TPS_LOOP
            
            ; Assignment
            TPSL_FLOW:
                MOV AL, var
                MOV players[SI], AL
                INC SI
            
            ; Control Flow
            CMP SI, 2
            JB TPS_LOOP
        
        RET
    TAKE_PLAYERS_SYMBOL ENDP
    
END MAIN
