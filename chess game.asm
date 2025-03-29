; Chess 2d Game - Copyright (c) Talha Ahmad

.MODEL SMALL

.STACK 100H

.DATA
    ;;;;;;;;;;;;;;;;;;;;
    ; Game Vairables    
    ;;;;;;;;;;;;;;;;;;;;
    
    ; Board variables
    board DB 'R', 'N', 'B', 'Q', 'K', 'B', 'N', 'R', 'P', 'P', 'P', 'P', 'P', 'P', 'P', 'P', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.','.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', 'p', 'p', 'p', 'p', 'p', 'p', 'p', 'p', 'r', 'n', 'b', 'q', 'k', 'b', 'n', 'r'
    size DB 64
    row_size DB 8
    
    ; To check initial position of pawns
    upper_pawn_initial_positions DB 8, 9, 10, 11, 12, 13, 14, 15
    lower_pawn_initial_positions DB 48, 49, 50, 51, 52, 53, 54, 55
    
    ; To simplify Game Logic & Increase performance => 0 (Player 1) : 1 (Player 2)
    king_count DB 1, 1
    queen_count DB 1, 1
    bishop_count DB 2, 2
    knight_count DB 2, 2
    rook_count DB 2, 2
    pawn_count DB 8, 8
    
    ; Prompts / Messages
    prompt_input_index DB 'Enter index: $'
    prompt_pawn_promotion DB '1-Q, 2-R, 3-B, 4-N to promote pawn: $'
    
    display_turn DB 'Turn of Player $'
    
    display_piece_selection_msg DB 'Position of the piece you want to select (Row, Column)!$'
    display_piece_destination_msg DB 'Select the destination!$'
    
    display_piece_selection DB 'Select Piece!$'
    display_no_piece_found DB 'No piece found at your selected position!!$'
    display_not_movable DB 'The selected piece is not movable!!$'
    display_incorrect_value DB 'The value you entered is incorrect. It must be between 1 and 8!!$'
    
    display_destination_selection DB 'Select destination of your selected piece!$'
    display_invalid_destination DB 'Illegal destination/move! Please select correct one$'
    
    display_check DB 'It is a Check!$'
    display_checkmate DB 'It is a Checkmate!$'
    
    display_winner DB 'Winner is Player $'
    
    ; Game Status Flags
    game_over DB 0
    turn DB 0
    can_castle DB 0
    is_valid DB ?
    
    player_check DB 0, 0
    
    player_won DB 0, 0
    
    ; In-game Variables
    moves_count DB 0
    
    index DB ?  ; Store index w.r.t position/destination
    
    piece_position DB ?, ?      ; 0: Row, 1: Column
    piece_position_temp DB ?, ? ; 0: Row, 1: Column
    piece_destination DB ?, ?   ; 0: Row, 1: Column
    piece DB ?                  ; Current piece symbol
    piece_temp DB ?             ; Temporary piece symbol
    
    pawn_promotion DB ?
    
    ;;;;;;;;;;;
    ; Macro    
    ;;;;;;;;;;;
    
    ; Display a Character
    PRINTC MACRO chr
        MOV DL, chr
        MOV AH, 02H
        INT 21H
    PRINTC ENDM
    
    ; Display a String
    PRINTS MACRO str
        MOV AH, 09H
        LEA DX, str
        INT 21H
    PRINTS ENDM
    
    ; Take input single digit number
    INPUTN MACRO num
        MOV AH, 01H
        INT 21H
        SUB AL, '0'     ; Convert ASCII digit to actual digit | For example; '1' (ASCII) -> 1 (Decimal)
        MOV num, AL
    INPUTN ENDM
    
    ; Line Break
    LINE_BREAK MACRO
        PRINTC 0DH
        PRINTC 0AH
    LINE_BREAK ENDM
    
    ; Get piece based on index
    GET_PIECE MACRO
        MOV AL, index
        MOV AH, 0
        MOV SI, AX
        MOV AL, board[SI]
        MOV piece, AL
    GET_PIECE ENDM
    
    ; Shift actual piece position to a temporary position for decision making
    SHIFT_POSITION MACRO
        ; Row
        MOV AL, piece_position[0]
        MOV piece_position_temp[0], AL
        
        ; Column
        MOV AL, piece_position[1]
        MOV piece_position_temp[1], AL
    SHIFT_POSITION ENDM
        
    ; Clear Console Screen
    CLRSCR MACRO
        MOV AH, 00H
        MOV AL, 03H
        INT 10H
    CLRSCR ENDM
    
.CODE
    ;;;;;;;;;;;;;;;;
    ; Procedures    
    ;;;;;;;;;;;;;;;;
    
    ; Main - Entry point
    MAIN PROC FAR
        ; Move data to Data Segment register
        MOV AX, @DATA
        MOV DS, AX
        
        ;;;;;;;;;;;;;;;;;;;;
        ; Main Game-Loop    
        ;;;;;;;;;;;;;;;;;;;;
        GAME_LOOP:
            ; Clear the Console Screen
            CLRSCR
            
            ; Display board
            CALL DISPLAY_BOARD
            
            ; Display player's turn
            CALL DISPLAY_TURN_MSG
            
            ; Take positions from user
            INNPUT_POSITION_LOOP:
                CALL INPUT_POSITIONS
             
                ; Calculate index according to user input (piece position) 
                MOV AL, piece_position[0]
                MOV BL, piece_position[1]
                CALL CALCULATE_INDEX
                
                ; Get the selected piece
                GET_PIECE
                
                ; Check piece existance
                CALL CHECK_PIECE_EXIST
                
                ; If not valid
                CMP is_valid, 0
                JE IPL_NOT_VALID
                
                ; if valid
                GET_PIECE
                JMP MOVABLE_VALIDITY_CHECK
                
                IPL_NOT_VALID:
                    PRINTS display_no_piece_found
                    LINE_BREAK
                    JMP INNPUT_POSITION_LOOP
            
            ; Check if piece movable
            MOVABLE_VALIDITY_CHECK:
                ; debugging purpose
                LINE_BREAK
                PRINTC piece
             
            ; Update turn
            CALL UPDATE_TURN
             
        ; Program Termination
        EXIT:
        MOV AH, 4CH
        INT 21H
    MAIN ENDP
    
    ; Display Game Board
    DISPLAY_BOARD PROC
        ; Numbers Strip - Columns
        PRINTC ' '
        PRINTC ' '
        MOV CX, 8
        MOV BL, '1'
        DISPB_NSC:
            MOV DL, BL
            MOV AH, 02H
            INT 21H
            INC BL
            PRINTC ' '
            LOOP DISPB_NSC
        LINE_BREAK
        
        ; Number Strip + Board
        MOV BL, '1'
        MOV SI, 0
        DISPB_NSR:
            ; Numbers Stip - Rows
            MOV DL, BL
            MOV AH, 02H
            INT 21H
            PRINTC ' '
            
            ; count board columns
            MOV BH, 0
            
            ; Display main board
            DISPB_LOOP:
                ; Display board character
                PRINTC board[SI]
                PRINTC ' '
                
                ; Increment board columns counter
                INC BH
                
                ; Increment cell-index
                INC SI
                
                ; Loop Control - Display board
                CMP BH, 8
                JL DISPB_LOOP
            
            ; Loop Control - Numbers Strip Rows
            LINE_BREAK
            INC BL
            CMP BL, '8'
            JLE DISPB_NSR
       
       RET
    DISPLAY_BOARD ENDP
    
    ; Display player's turn
    DISPLAY_TURN_MSG PROC
        ; Display Message
        LINE_BREAK
        PRINTS display_turn
        
        ; Display player number
        MOV AL, turn
        ADD AL, '1'
        PRINTC AL
        PRINTC '!'
        LINE_BREAK
        
        RET
    DISPLAY_TURN_MSG ENDP
    
    ; Take position input
    INPUT_POSITIONS PROC
        ; Prompt
        LINE_BREAK
        PRINTS display_piece_selection_msg
        LINE_BREAK
            
        ; Take input - piece selection
        MOV CX, 2
        MOV SI, 0
        PIECE_SELECTION_LOOP:
            IP_LOOP:
                ; Display prompt
                PRINTS prompt_input_index
                
                ; Take number input
                INPUTN piece_position[SI]
                LINE_BREAK
                
                ; Check if input is valid
                MOV AL, piece_position[SI]
                CALL CHECK_VALUE_VALIDITY
                
                ; If not valid
                CMP is_valid, 0
                JE IPL_MSG
                JMP PSL_CONTROL
                
                IPL_MSG:
                    PRINTS display_incorrect_value
                    LINE_BREAK
                    JMP IP_LOOP
                
            ; Loop - Control
            PSL_CONTROL:
                INC SI
                LOOP PIECE_SELECTION_LOOP
        RET
    INPUT_POSITIONS ENDP    
    
    ; Calculate index based on user input | row should be in AL and column should in BL
    CALCULATE_INDEX PROC
        ; Clear high portions
        MOV AH, 0
        MOV BH, 0
        
        ; Decrease row & column
        DEC AL
        DEC BL
        
        ; Multiply row (AL) by 8 (row size)
        MUL row_size
        
        ; Add it
        ADD AL, BL
        
        ; Store to index variable
        MOV index, AL
        
        RET
    CALCULATE_INDEX ENDP
    
    ; Check if user input is valid 1-8 | value should be in AL
    CHECK_VALUE_VALIDITY PROC                                                    
        MOV is_valid, 0     ; Default is 0 - False
        CMP AL, 0
        JGE CLV_IN_RANGE
        JMP CLV_EXIT
        
        CLV_IN_RANGE:
            CMP AL, 8
            JLE CLV_CONFIRM
            JMP CLV_EXIT
        
        CLV_CONFIRM:
            MOV is_valid, 1 ; 1 - True
        
        CLV_EXIT:
            RET
    CHECK_VALUE_VALIDITY ENDP
    
    ; Check if a piece exists at specific position
    CHECK_PIECE_EXIST PROC
        MOV AL, index
        MOV AH, 0
        
        MOV SI, AX
        CMP board[SI], '.'
        MOV is_valid, 0  ; Assume no piece exists by default
        JE CP_EXIT
        
        MOV is_valid, 1   ; If not empty, piece exists
        
        CP_EXIT:
            RET
    CHECK_PIECE_EXIST ENDP
    
    ; Check if pawn (small) movable
    CHECK_IF_MOVABLE_PAWN PROC
        RET
    CHECK_IF_MOVABLE_PAWN ENDP
    
    ; Check if selected piece is movable or not
    CHECK_IF_MOVABLE PROC
        ; Shift the position to temporary array
        SHIFT_POSITION
        
        ; If piece is pawn (small)
        CMP piece, 'p'
        JE SMALL_PAWN_CIM
        
        ; If piece is Pawn (capital)
        CMP piece, 'P'
        JE CAPITAL_PAWN_CIM
        
        ; If piece is bishop
        CMP piece, 'b'
        JE BISHOP_CIM
        CMP piece, 'B'
        JE BISHOP_CIM
        
        ; If piece is rook
        CMP piece, 'r'
        JE ROOK_CIM
        CMP piece, 'R'
        JE ROOK_CIM
        
        ; If piece is queen
        CMP piece, 'q'
        JE QUEEN_CIM
        CMP piece, 'Q'
        JE QUEEN_CIM
        
        ; If piece is king
        CMP piece, 'k'
        JE KING_CIM
        
        ; If piece is K
        CMP piece, 'K'
        JE KING_CIM
        
        ; Check for pawn (small)
        SMALL_PAWN_CIM:
            JMP CIM_EXIT
        
        ; Check for Pawn (capital)
        CAPITAL_PAWN_CIM:
            JMP CIM_EXIT
        
        ; Check for bishop
        BISHOP_CIM:
            JMP CIM_EXIT
        
        ; Check for rook
        ROOK_CIM:
            JMP CIM_EXIT
        
        ; Check for queen
        QUEEN_CIM:
            JMP CIM_EXIT
        
        ; Check for king
        KING_CIM:
            
        CIM_EXIT:
            RET
    CHECK_IF_MOVABLE ENDP
    
    ; Update turn
    UPDATE_TURN PROC
        XOR turn, 1  ; Toggle between 0 and 1
        RET
    UPDATE_TURN ENDP
END MAIN
