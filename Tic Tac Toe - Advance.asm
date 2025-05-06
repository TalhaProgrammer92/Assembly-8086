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
    alert_invalid_symbol DB 'You must select upper case alphabet between A and Z as symbol!$'       ; When player enter invalid symbol like 1, [
    alert_existed_symbol DB 'The symbol you selected has already been taken by your opponent!$'     ; When player enter symbol which is already taken
    
    ; Board
    board DB 9 DUP('$')         ; Game Board
    row_sep DB '---+---+---$'   ; Row Separator
    col_sep DB '|'              ; Column Separator
    
    ; In-game (Flags: 1-True, 0-False)
    game_over DB 0  ; Game Over
    turn DB 0       ; Player's turn
    valid DB ?      ; Check validity
    
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
    
    ; Hold Screen
    HOLD MACRO
        MOV AH, 08H
        INT 21H
    HOLD ENDM
    
    ; Line Break
    LINE_BREAK MACRO
        PRINTC 0DH
        PRINTC 0AH
    LINE_BREAK ENDM
    
    ; Take Input (Number)
    INPUTN MACRO var
        MOV AH, 01H
        INT 21H
        
        SUB AL, '0'
        MOV var, AL
    INPUTN ENDM
    
    ; Take Input (Character)
    INPUTC MACRO var
        MOV AH, 01H
        INT 21H
        MOV var, AL
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
        
        ;CALL START_GAME
        CALL RESET_BOARD
        CALL DISPLAY_BOARD
        
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
        CALL WELCOME_SCREEN
        
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
        ; Symbol Input - player 1
        SS_PR1:
            ; Prompt
            PRINTS prompt_symbol
            INPUTC player_symbol[0]
            
            CALL CHECK_UPPER_CHAR       ; Check if symbol is upper-case
            CMP valid, 0
            JE SS_INVALID1
            JMP SS_PR2
            
            SS_INVALID1:
                LINE_BREAK
                PRINTS alert_invalid_symbol
                LINE_BREAK
                
                JMP SS_PR1
        
        ; Symbol Input - player 2
        SS_PR2:
        
            ; Line break
            LINE_BREAK
            
            ; Prompt
            PRINTS prompt_symbol
            INPUTC player_symbol[1]
            
            CMP AL, player_symbol[0]    ; If symbols of player 1 & 2 are same
            JE SS_SAME
            
            CALL CHECK_UPPER_CHAR       ; Check if symbol is upper-case
            CMP valid, 0
            JE SS_INVALID2
            
            JMP SS_EXIT
            
            SS_SAME:
                LINE_BREAK
                PRINTS alert_existed_symbol
                LINE_BREAK
                
                JMP SS_PR2
            
            SS_INVALID2:
                LINE_BREAK
                PRINTS alert_invalid_symbol
                LINE_BREAK
                
                JMP SS_PR2
        
        SS_EXIT:
            RET
    SYMBOL_SELECTION ENDP
    
    ; Check if a charater (AL) is in upper-case
    CHECK_UPPER_CHAR PROC
        MOV valid, 0
        
        CMP AL, 'A'
        JAE CUC_NEXT
        JMP CUC_EXIT
        
        CUC_NEXT:
            CMP AL, 'Z'
            JBE CUC_CONFIRM
            JMP CUC_EXIT
        
        CUC_CONFIRM:
            MOV valid, 1
        
        CUC_EXIT:
            RET
    CHECK_UPPER_CHAR ENDP
    
    ; Reset Board - Contains bug
    RESET_BOARD PROC
        MOV SI, 0
        MOV AL, '0'
        RB_LOOP:
            MOV board[SI], AL
            
            INC AL
            
            INC SI
            CMP SI, 9
            JL RB_LOOP
        
        RET
    RESET_BOARD ENDP
    
    ; Display Board
    DISPLAY_BOARD PROC
        MOV SI, 0
        MOV CL, 0
        DB_OUTER:
            MOV BL, 0
            DB_INNER:
                PRINTC ' '
                PRINTC board[SI]
                PRINTC ' '
                
                CMP BL, 2
                JB DBI_CS
                JMP DBI_CONTROL
                
                DBI_CS:
                    PRINTC col_sep
                
                DBI_CONTROL:
                    INC BL
                    CMP BL, 3
                    JB DB_INNER
           
           LINE_BREAK
           CMP CL, 2
           JB DBO_RS
           JMP DBO_CONTROL
           
           DBO_RS:
                PRINTS row_sep
                LINE_BREAK
           
           DBO_CONTROL:
                INC CL
                CMP CL, 3
                JB DB_OUTER
                
        RET
    DISPLAY_BOARD ENDP
    
    ; Multiplayer Game
    MULTIPLAYER_GAME PROC
        ; Select Symbol
        CALL SYMBOL_SELECTION
        CLRSCR
        
        ; Reset Board
        CALL RESET_BOARD
        CALL DISPLAY_BOARD
        
        RET
    MULTIPLAYER_GAME ENDP
    
    ; Computer Game
    COMPUTER_GAME PROC
        ; Select Symbol
        CALL SYMBOL_SELECTION
        CLRSCR
        
        RET
    COMPUTER_GAME ENDP
    
END MAIN
