; Tic Tac Toe - Advance

.MODEL SMALL

.STACK 100H

.DATA
    ;;;;;;;;;;;;;;;;;;;;;
    ; Game Varaibles     
    ;;;;;;;;;;;;;;;;;;;;;
    
    ; Main
    board DB 9 DUP('$')
    turn DW 0
    
    ; Player
    symbol DB 'X', 'O'
    score DB 2 DUP(?)
    input DB ?
    
    ;;;;;;;;;;;;;;;;;;;;;;;;;
    ; Messages / Prompts     
    ;;;;;;;;;;;;;;;;;;;;;;;;;
    
    ; Messages
    msg_menu DB '1-New Game | 2-Load Game: $'
    msg_turn DB 'Turn of $'
    msg_prompt DB 'Enter cell number: $'
    
    ; Alerts
    alert_range DB 'Incorrect cell number!$'
    alert_filled DB 'Cell is already filled!$'
    
    ; Winner
    msg_won DB ' is Winner!$'
    msg_draw DB 'Game is Draw!$'
    
    ;;;;;;;;;;;;;;;;;;;;;
    ; File Variables     
    ;;;;;;;;;;;;;;;;;;;;;
    
    ; File
    fname DB 'board.txt', 0
    fhandle DW ?
    
    ;;;;;;;;;;;;;
    ; Macros     
    ;;;;;;;;;;;;;
    
    ; Print String
    PRINTS MACRO str
        MOV AH, 09H
        LEA DX, str
        INT 21H
    PRINTS ENDM
    
    ; Print Character
    PRINTC MACRO chr
        MOV AH, 02H
        MOV DL, chr
        INT 21H
    PRINTC ENDM
    
    ; Line Break
    LINE_BREAK MACRO
        PRINTC 0DH
        PRINTC 0AH
    LINE_BREAK ENDM
    
    ; Take input
    TAKE_INPUT MACRO
        MOV AH, 01H
        INT 21H
        MOV input, AL
    TAKE_INPUT ENDM
    
    ; Clear Screen
    CLRSCR MACRO
        MOV AH, 00H
        MOV AL, 03H
        INT 10H
    CLRSCR ENDM
    
    ; Create File
    CREATE_FILE MACRO
        MOV AH, 3DH
        LEA DX, fname
        MOV CL, 0
        INT 21H
        MOV fhandle, AX
    CREATE_FILE ENDM
    
    ; Store board data to file / write
    STORE_DATA MACRO
        MOV AH, 40H
        MOV BX, fhandle
        LEA DX, board
        MOV CX, 9
        INT 21H
    STORE_DATA ENDM
    
    ; Read data from file
    READ_DATA MACRO
        MOV AH, 3FH
        LEA DX, board
        MOV CX, 9
        MOV BX, fhandle
        INT 21H
    READ_DATA ENDM
    
    ; Close file
    CLOSE_FILE MACRO
        MOV AH, 3EH
        MOV BX, fhandle
        INT 21H
    CLOSE_FILE ENDM

.CODE
    ;;;;;;;;;;;;;;;;;
    ; Procedures     
    ;;;;;;;;;;;;;;;;;
    
    ; Entry Point
    MAIN PROC FAR
        ; Move data to data segment register
        MOV AX, @DATA
        MOV DS, AX
        
        CALL MAIN_MENU
        
        ; Terminate Program Execution
        EXIT:
            MOV AH, 4CH
            INT 21H
    MAIN ENDP
    
    ; Main Menu
    MAIN_MENU PROC
        ; Prompt player to select an option
        PRINTS msg_menu
        TAKE_INPUT
        
        ; Clear the Screen
        CLRSCR
        
        ; New Game
        CMP input, '1'
        JE MM_NEW_GAME
        
        ; Load Game
        CMP input, '2'
        JE MM_LOAD_GAME
        
        ; Exit program
        JMP EXIT
        
        MM_NEW_GAME:
            CALL GAME
            JMP MM_EXIT
        
        MM_LOAD_GAME:
            CALL LOAD
        
        MM_EXIT:
            RET
    MAIN_MENU ENDP
    
    ; Start game
    GAME PROC
        RET
    GAME ENDP
    
    ; Load Game
    LOAD PROC
        RET
    LOAD ENDP
END MAIN
