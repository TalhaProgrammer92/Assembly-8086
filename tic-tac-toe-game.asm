.MODEL SMALL

.STACK 100H

.DATA
    ;;;;;;;;;;;;;;;
    ; PLAYER DATA ;
    ;;;;;;;;;;;;;;;
    
    symbols DB 2 DUP('$')       ; Store custom symbol of the player
    score DW 0, 0               ; Store score of the player. Range of Word is from 0 to 65,535
    name1 DB 16 DUP('$')        ; Store the name of player 1
    name2 DB 16 DUP('$')        ; Store the name of player 2
    
    ;;;;;;;;;;;;;
    ; GAME DATA ;
    ;;;;;;;;;;;;;
    
    game_over_flag DB 0         ; Check if game is over | 0 - False | 1 - True
    draw_flag DB 0              ; Check if game is draw | 0 - False | 1 - True
    winner DB ?                 ; Check who is winner if game is not draw | 0 - Player 1 | 1 - Player 2
    turn DW 0                   ; Turn of a player | 0 - Player 1 | 1 - Player 2
    
    ;;;;;;;;;;;;;;
    ; BOARD DATA ;
    ;;;;;;;;;;;;;;
    
    board DB 9 DUP('$')
    separator_line DB '+---+---+---+$'
    separator_cell DB '|'
    
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; MACRO - Display a Character ;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    PRINTC MACRO chr
        MOV AH, 02H
        MOV DL, chr
        INT 21H
    PRINTC ENDM
    
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; MACRO - Display a String ;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    PRINTS MACRO str
        MOV AH, 09H
        LEA DX, str
        INT 21H
    PRINTS ENDM
    
    ;;;;;;;;;;;;;;;;;;;;;;;;
    ; MACRO - Clear Screen ;
    ;;;;;;;;;;;;;;;;;;;;;;;;
    
    CLRSCR MACRO
        MOV AH, 00H
        MOV AL, 03H
        INT 10H
    CLRSCR ENDM
    
    ;;;;;;;;;;;;;;;;;;;;;;
    ; MACRO - Line Break ;
    ;;;;;;;;;;;;;;;;;;;;;;
    
    LINE_BREAK MACRO
        PRINTC 0DH
        PRINTC 0AH
    LINE_BREAK ENDM

.CODE
    ;;;;;;;;;;;;;;;
    ; ENTRY POINT ;
    ;;;;;;;;;;;;;;;
    
    MAIN PROC FAR
        ; Moving data from data segment to the data segment register
        MOV AX, @DATA
        MOV DS, AX
        
        CALL CLEAR_BOARD
        CALL DISPLAY_BOARD
        
        ; Program termination
        MOV AH, 4CH
        INT 21H
    MAIN ENDP
    
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; PROCEDURE - Clear the board ;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
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
    
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; PROCEDURE - Display the Board ;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    DISPLAY_BOARD PROC
        ; Top - Border
        PRINTS separator_line
        LINE_BREAK
        PRINTC separator_cell
        
        MOV SI, 0
        DB_LOOP:
            ; Adds separator pipe before first cell on each row
            CMP SI, 3
            JE DBSP
            CMP SI, 6 
            JE DBSP
            JMP DB_CELL
            
            DBSP:
                PRINTC separator_cell
            
            ; Cell
            DB_CELL:   
                PRINTC ' '
                PRINTC board[SI]
                PRINTC ' '
            
            ; Cell - Separator Pipe
            PRINTC separator_cell
            
            ; For each row separator
            CMP SI, 2   ; Row-0
            JE DBLB
            CMP SI, 5   ; Row-1
            JE DBLB
            CMP SI, 8   ; Row-2
            JE DBLB
            
            JMP DB_FLOW
            
            DBLB:
                LINE_BREAK
                PRINTS separator_line
                LINE_BREAK
            
            DB_FLOW:
                INC SI
                CMP SI, 9
                JB DB_LOOP
        
        RET
    DISPLAY_BOARD ENDP

END MAIN
