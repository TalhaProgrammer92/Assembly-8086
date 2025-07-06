; Infix to Postfix conversion - Created just for fun (not part of the curriculum)

.MODEL SMALL

.STACK 100H

.DATA
    ; Stack
    my_stack DB 100 DUP('$')
    head DW 0
    
    ; Infix expression
    infix DB '(A+B)*(C+D)$'
    infix_index DW 0
    
    ; Postfix expression
    postfix DB 100 DUP('$')
    postfix_index DW 0
    
    ; Messages
    msg_infix DB 'Infix is $'
    msg_postfix DB 'Postfix is $'
    
    ; Misc
    alnum_flag DB 0   ; Check if character in infix is alpha num or not
    
    ; Macro - Print a character
    PRINTC MACRO chr
        MOV DL, chr
        MOV AH, 02H
        INT 21H
    PRINTC ENDM
    
    ; Macro - Line break
    LINE_BREAK MACRO
        PRINTC 0DH
        PRINTC 0AH
    LINE_BREAK ENDM
    
    ; Macro - Print a string
    PRINTS MACRO str
        MOV AH, 09H
        LEA DX, str
        INT 21H
    PRINTS ENDM
    
    ; Macro - Push data (AL) onto stack
    PUSH_DATA MACRO
        MOV SI, head
        MOV my_stack[SI], AL

        INC head
    PUSH_DATA ENDM
    
    ; Macro - Pop data from stack at SI and store in AL
    POP_DATA MACRO
        ;MOV SI, head
        MOV AL, my_stack[SI]

        MOV my_stack[SI], '$'

        DEC head
    POP_DATA ENDM

.CODE

    ; Entry Point
    MAIN PROC FAR
        ; Move data to the data segment register
        MOV AX, @DATA
        MOV DS, AX
        
        CALL PRINT_INFIX
        
        CALL CONVERT
        
        CALL PRINT_POSTFIX
        
        ; Program termination
        MOV AH, 4CH
        INT 21H
    MAIN ENDP
    
    ; Print infix in terminal
    PRINT_INFIX PROC
        PRINTS msg_infix
        PRINTS infix
        
        LINE_BREAK
        
        RET
    PRINT_INFIX ENDP
    
    ; Print postfix in terminal
    PRINT_POSTFIX PROC
        PRINTS msg_postfix
        PRINTS postfix
        
        RET
    PRINT_POSTFIX ENDP
    
    ; Check if a character (in AL) is alpha num or not
    IS_ALPHA_NUM PROC
        MOV alnum_flag, 0
        
        CMP AL, 'a' ; If >= 'a'
        JGE IAN_ALPHA_SMALL ; Check if lie b/w a and z
        
        CMP AL, 'A' ; If >= 'A'
        JGE IAN_ALPHA_CAPITAL ; Check if lie b/w A and Z
        
        CMP AL, '0' ; If >= '0'
        JGE IAN_NUM ; Check if lie b/w 0 and 9 
        
        JMP IAN_RET ; If not alpha num then go back
        
        ; Check if a small alphabet
        IAN_ALPHA_SMALL:
            CMP AL, 'z'
            JLE IAN_TRUE
            JMP IAN_RET
        
        ; Check if a capital alphabet
        IAN_ALPHA_CAPITAL:
            CMP AL, 'Z'
            JLE IAN_TRUE
            JMP IAN_RET
        
        ; Check if a number
        IAN_NUM:
            CMP AL, '9'
            JLE IAN_TRUE
            JMP IAN_RET
        
        IAN_TRUE:
            MOV alnum_flag, 1
        
        IAN_RET:
            RET
    IS_ALPHA_NUM ENDP
    
    ; Stack -> Postfix [Add elements]
    STACK_INTO_POSTFIX PROC
        SIP_LOOP:
            MOV SI, head

            CMP head, 0   ; If head is < 0 i.e. stack is empty
            JL SIP_RET

            CMP my_stack[SI], '('   ; If got '('
            JE SIP_BRACE

            ; Pop data from stack and insert it into postfix
            POP_DATA
            MOV SI, postfix_index
            MOV postfix[SI], AL

            INC postfix_index
            
            JMP SIP_LOOP

        ; Remove last '(' bracket only if the stack is not empty
        SIP_BRACE:
            POP_DATA

        SIP_RET:
            RET
    STACK_INTO_POSTFIX ENDP
    
    
    ; Convert Infix to Postfix
    CONVERT PROC
        ; Traverse infix expression
        CVT_LOOP:
            MOV SI, infix_index

            ; Compare the character of infix
            
            CMP infix[SI], ' '  ; If it's whitespace then skip
            JE CVT_CONTROL
            
            MOV AL, infix[SI]   ; If the character is alpha num (operand) then add to postfix
            CALL IS_ALPHA_NUM
            CMP alnum_flag, 1
            JE CVT_POSTFIX
            
            CMP infix[SI], ')'   ; If the character is closing brace ')' then add all stack element till '(' or stack is empty
            JE CVT_STACK_POSTFIX
            
            ; Otherwise (operator) push character onto stack
            MOV AL, infix[SI]
            PUSH_DATA
            JMP CVT_CONTROL
            
            ; Move every stack element till get '(' or the stack become empty
            CVT_STACK_POSTFIX:
                CALL STACK_INTO_POSTFIX
                JMP CVT_CONTROL

            ; Add character to postfix expression
            CVT_POSTFIX:
                MOV BX, postfix_index
                
                ;MOV AL, infix[SI]
                MOV postfix[BX], AL
                
                INC postfix_index
                
                ;JMP CVT_CONTROL
            
            ; Loop Control
            CVT_CONTROL:
                INC infix_index
                
                MOV SI, infix_index
                CMP infix[SI], '$'
                JNE CVT_LOOP

        ; Fill postfix with lefted data in stack
        CALL STACK_INTO_POSTFIX

        RET
    CONVERT ENDP
    
END MAIN
