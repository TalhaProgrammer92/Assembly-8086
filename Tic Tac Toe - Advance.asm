; Advance Tic Tac Toe

.MODEL SMALL

.STACK 100H

.DATA
    ;;;;;;;;;;;;;
    ; Variables ;
    ;;;;;;;;;;;;;
    
    ; Messages
    prompt_input DB 'Enter cell number: $'              ; When taking input from player for the cell number of game board
    prompt_symbol Db 'Enter symbol: $'                  ; When taking input from player to specify its symbol
    prompt_game_mode DB '1-Multiplayer, 2-Computer: $'  ; When selecting game mode
    
    msg_welcome DB '*** Welcome to Tic Tac Toe - By Talha Ahmad ***$'   ; Welcome Screen
    
    msg_turn DB 'Turn of $'         ; When display turn of a player
    msg_winner DB 'Winner is $'     ; When display winner message
    msg_draw DB 'Game is Draw$'     ; When display draw messsage
    
    alert_invalid_cell DB 'Cell number must be between 1 and 9!$'                                   ; When player enter invalid cell number for game board
    alert_invalid_symbol DB 'You must select upper case alphabet between A and Z as symbol!$'       ; When player enter invalid symbol like 1 [
    alert_existed_symbol DB 'The symbol you selected has already been taken by your opponent!$'     ; When player enter symbol which is already taken
    
    ; Board
    board DB 9 dup('$')
    row_sep DB '---+---+---$'
    col_sep DB '|'
    
    ; In-game (Flags: 1-True, 0-False)
    game_over DB 0
    turn DB 0
    

.CODE
    MAIN PROC FAR
        ; Move data segment -> register
        MOV AX, @DATA
        MOV DS, AX
        
        ; Program Termination
        MOV AH, 4CH
        INT 21H
    MAIN ENDP
END MAIN
