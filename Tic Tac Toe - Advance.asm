; Advance Tic Tac Toe

.MODEL SMALL

.STACK 100H

.DATA
    ;;;;;;;;;;;;;
    ; Variables ;
    ;;;;;;;;;;;;;
    
    ; Messages
    prompt_input DB 'Enter cell number: $'              ; When taking input from player for the cell number of game board
    prompt_symbol DB 'Enter symbol: $'                  ; When taking input from player to specify its symbol
    prompt_game_mode DB '1-Multiplayer, 2-Computer: $'  ; When selecting game mode
    prompt_end_game DB '1-Replay, 2-Scores: $'          ; When game is over then ask player what to do
    
    msg_welcome DB '*** Welcome to Tic Tac Toe - By Talha Ahmad ***$'   ; Welcome Screen
    
    msg_turn DB 'Turn of $'         ; When display turn of a player
    msg_winner DB 'Winner is $'     ; When display winner message
    msg_draw DB 'Game is Draw$'     ; When display draw messsage
    
    alert_invalid_cell DB 'Cell number must be between 1 and 9!$'                                   ; When player enter invalid cell number for game board
    alert_invalid_symbol DB 'You must select upper case alphabet between A and Z as symbol!$'       ; When player enter invalid symbol like 1 [
    alert_existed_symbol DB 'The symbol you selected has already been taken by your opponent!$'     ; When player enter symbol which is already taken
    
    ; Board
    board DB 9 DUP('$')         ; Game Board
    row_sep DB '---+---+---$'   ; Row Separator
    col_sep DB '|'              ; Column Separator
    
    ; In-game (Flags: 1-True, 0-False)
    game_over DB 0  ; Game Over
    turn DW 0       ; Player's turn
    
    ; In-game (Variables)
    winner DB ?     ; Winner
    input DB ?      ; Player/User Input
    
    player_symbol DB 2 DUP('$') ; Player - Symbol
    
    ;;;;;;;;;;
    ; Macros ;
    ;;;;;;;;;;
    
    ; Display Character
    PRINTC MACRO chr
        MOV AH, 02H
        MOV DL, chr
        INT 21H
    PRINTC ENDM
    
    ; Display String
    PRINTS MACRO str
        MOV AH, 09H
        LEA DX, str
        INT 21H
    PRINTS ENDM
    
    ; Line Break
    LINE_BREAK MACRO
        PRINTC 0DH
        PRINTC 0AH
    LINE_BREAK ENDM
    
    ; Take Input (Number)
    INPUTN MACRO var
        MOV AH, 01H
        INT 21H
        
        DEC AL, '0'
    INPUTN ENDM
    
    ; Take Input (Character)
    INPUTC MACRO var
        MOV AH, 01H
        INT 21H
    INPUTC ENDM
    
    ; Update turn
    UPDATE_TURN MACRO
        XOR turn, 1
    UPDATE_TURN ENDM
    
    ; Clear Screen
    CLRSCR MACRO
        MOV AH, 00H
        MOV AL, 03H
        INT 10H
    CLRSCR ENDM
    
.CODE
    
    ;;;;;;;;;;;;;;
    ; Procedures ;
    ;;;;;;;;;;;;;;

    ; Entry Point
    MAIN PROC FAR
        ; Move data segment -> register
        MOV AX, @DATA
        MOV DS, AX               
        
        CALL START_GAME
        
        ; Program Termination
        MOV AH, 4CH
        INT 21H
    MAIN ENDP
    
    ; Start Game
    START_GAME PROC
        CALL WELCOME_SCREEN
        
        RET
    START_GAME ENDP
    
    ; Display - Welcome Screen
    WELCOME_SCREEN PROC
        ; Message
        PRINTS msg_welcome
        LINE_BREAK
        LINE_BREAK
        
        ; Input - Game Mode
        PRINTS prompt_game_mode
        INPUTN input
            
        ; Clear screen
        CLRSCR
            
        ; Switch Game Mode
        CMP input, 1    ; Multiplayer Mode
        JE MULTIPLAYER
            
        CMP input, 2    ; Computer Mode
        JE COMPUTER
            
        ; Exit
        JMP WS_EXIT
        
        ; Multiplayer Game
        MULTIPLAYER:
            CALL MULTIPLAYER_GAME
            JMP WS_EXIT
        
        ; Computer Game
        COMPUTER:
            CALL COMPUTER_GAME
        
        WS_EXIT:
            RET
    WELCOME_SCREEN ENDM
    
    ; Symbol Selection
    SYMBOL_SELECTION PROC
        MOV SI, 1
        SS_LOOP:
            ; Prompt
            PRINTS prompt_symbol
            INPUTC
            
            ; Store Input
            MOV player_symbol[SI], AL
            INC SI
            
            ; Line break
            LINE_BREAK
            
            ; Loop Control
            CMP SI, 0
            JLE SS_LOOP
        
        RET
    SYMBOL_SELECTION ENDP
    
    ; Multiplayer Game
    MULTIPLAYER_GAME PROC
        ; Select Symbol
        CALL SYMBOL_SELECTION
        CLRSCR
        
        
        
        RET
    MULTIPLAYER_GAME ENDP
    
    ; Computer Game
    COMPUTER_GAME PROC
        RET
    COMPUTER_GAME ENDP
    
END MAIN
