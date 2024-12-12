; Tic Tac Game - Created By: Talha Ahmad (c)

; By Default: Player 1 -> O | Player 2 -> X

.MODEL SMALL

.STACK 100H

.DATA
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; Game Variables
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    ; Board
    board DB '123456789$'
    location DB ?
    
    ; In-game
    turn DB 0
    game_over_flag DB 0
    draw_flag DB 0
    symbol DB ?
    winner DB ?
    
    ; Prompts
    p1_prompt DB 'Turn of Player 1: $'
    p2_prompt DB 'Turn of Player 2: $'
    
    ; Messages on game over
    p1_won_msg DB 'Player 1 (O) won the game!$'
    p2_won_msg DB 'Player 2 (X) won the game!$'
    draw_msg DB 'Game is Draw!$'
    
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; Definition of Macro
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    ; Display a string
    PRINTS MACRO string
        MOV AH, 09H
        LEA DX, string
        INT 21H
    PRINTS ENDM
    
    ; Display a character
    PRINTC MACRO char
        MOV DL, char
        MOV AH, 02H
        INT 21H
    PRINTC ENDM
    
    ; Line Break
    ENDL MACRO
        PRINTC 0DH
        PRINTC 0AH
    ENDL ENDM
    
    ; Display game board
    DISPLAY MACRO
        MOV SI, 0
        DISP_LOOP:
            PRINTC ' '
            PRINTC board[SI]
            PRINTC ' '
            INC SI
            
            ; Line Break - Control
            CMP SI, 3
            JE BREAK_DL
            CMP SI, 6
            JE BREAK_DL
            JMP CONT_DL
            
            BREAK_DL:
                ENDL
            
            CONT_DL:
                CMP board[SI], '$'
                JNE DISP_LOOP
        ENDL
    DISPLAY ENDM
    
    ; Announce Winner / Draw
    ANNOUNCE MACRO
        
        ENDL
        
        ; Display the board
        MOV SI, 0
        BOARD_LOOP:
            PRINTC ' '
            PRINTC board[SI]
            PRINTC ' '
            INC SI
            
            ; Line Break - Control
            CMP SI, 3
            JE BREAK_BL
            CMP SI, 6
            JE BREAK_BL
            JMP CONT_BL
            
            BREAK_BL:
                ENDL
            
            CONT_BL:
                CMP board[SI], '$'
                JNE BOARD_LOOP
        ENDL
        
        ; Winner
        CMP draw_flag, 1
        JE DRAW_CASE
        CMP winner, 'O'
        JE P1_WON
        JMP P2_WON
        
        DRAW_CASE:
            PRINTS draw_msg
            JMP EXIT
        
        P1_WON:
            PRINTS p1_won_msg
            JMP EXIT
        P2_WON:
            PRINTS p2_won_msg
            JMP EXIT
    ANNOUNCE ENDM

.CODE
    MAIN PROC FAR
        MOV AX, @DATA
        MOV DS, AX
        
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        ; Main loop of the game
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        GAME_LOOP:
            
            ; Display Game Board
            ENDL
            DISPLAY

            ; Display player's turn prompt
            CMP turn, 0
            JE P1_DT
            JMP P2_DT
        
            P1_DT:
                PRINTS p1_prompt
                MOV symbol, 'O'
                INC turn               
                JMP INPUT
        
            P2_DT:
                PRINTS p2_prompt
                MOV symbol, 'X'
                DEC turn
            
            ; Get input from the player
            INPUT:
                MOV AH, 01H
                INT 21H
                MOV location, AL
                CMP location, '0'
                JE CHECK
                
            ; Place symbol
            PLACE:
                CMP location, '1'
                JE P_1
                CMP location, '2'
                JE P_2
                CMP location, '3'
                JE P_3
                CMP location, '4'
                JE P_4
                CMP location, '5'
                JE P_5
                CMP location, '6'
                JE P_6
                CMP location, '7'
                JE P_7
                CMP location, '8'
                JE P_8
                CMP location, '9'
                JE P_9
                JMP CHECK
                
                P_1:
                    MOV SI, 0
                    JMP P_CHK
                
                P_2:
                    MOV SI, 1
                    JMP P_CHK
                
                P_3:
                    MOV SI, 2
                    JMP P_CHK
                
                P_4:
                    MOV SI, 3
                    JMP P_CHK
                
                P_5:
                    MOV SI, 4
                    JMP P_CHK
                
                P_6:
                    MOV SI, 5
                    JMP P_CHK
                
                P_7:
                    MOV SI, 6
                    JMP P_CHK
                
                P_8:
                    MOV SI, 7
                    JMP P_CHK
                
                P_9:
                    MOV SI, 8
                    JMP P_CHK
                
                P_CHK:
                    MOV AL, location
                    CMP board[SI], AL
                    JE P_OK
                    JMP CHECK
                
                P_OK:
                    MOV AL, symbol
                    MOV board[SI], AL
            
            ; Check winner
            CHECK:
                ENDL
                
                ; Row Check
                MOV SI, 0
                ROW_LOOP:
                    MOV AL, board[SI]
                    CMP board[SI + 1], AL
                    JE RNEXT
                    JMP RCONT
                    
                    RNEXT:
                        CMP board[SI + 2], AL
                        MOV winner, AL
                        JE GAME_IS_OVER
                    
                    RCONT:
                        ADD SI, 3
                        CMP SI, 6
                        JLE ROW_LOOP

                ; Column Check
                MOV SI, 0
                COLUMN_LOOP:
                    MOV AL, board[SI]
                    CMP board[SI + 3], AL
                    JE CNEXT
                    JMP CCONT
                    
                    CNEXT:
                        CMP board[SI + 6], AL
                        MOV winner, AL
                        JE GAME_IS_OVER
                    
                    CCONT:
                        INC SI
                        CMP SI, 3
                        JLE COLUMN_LOOP

                ; Diagonol Check
                MOV SI, 4
                MOV AL, board[SI]
                LR_CHK:
                    CMP board[0], AL
                    JE LRNEXT
                    JMP RL_CHK
                    
                    LRNEXT:
                        CMP board[8], AL
                        MOV winner, AL
                        JE GAME_IS_OVER
                RL_CHK:
                    CMP board[2], AL
                    JE RLNEXT
                    JMP DRAW_CHK
                    
                    RLNEXT:
                        CMP board[6], AL
                        MOV winner, AL
                        JE GAME_IS_OVER
                        JMP DRAW_CHK
                    
                ; Draw Check
                DRAW_CHK:
                    MOV SI, 0
                    DCHK_LOOP:
                        CMP board[SI], 'O'
                        JNE DCHK_X
                        JMP DCHK_CONT
                        DCHK_X:
                            CMP board[SI], 'X'
                            JE DCHK_CONT
                            JMP GL_CONT
                        DCHK_CONT:
                            INC SI
                            CMP SI, 9
                            JL DCHK_LOOP
                    MOV draw_flag, 1
                    JMP GAME_IS_OVER
            
            ; Game Over - Flag -> True
            GAME_IS_OVER:
                MOV game_over_flag, 1
            
            ; Check if game is over
            GL_CONT:
                CMP game_over_flag, 1
                JNE GAME_LOOP
        
        ; Announce Winner / Draw
        ANNOUNCE
        
        ; Terminate the program
        EXIT:
            MOV AH, 4CH
            INT 21H
    MAIN ENDP
END MAIN
