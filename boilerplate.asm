; Boilerplate code of Assembly language
.MODEL SMALL
.STACK 100H

.DATA
    ; All the data placed here

.CODE
    MAIN PROC FAR
        MOV AX, @DATA
        MOV DS, AX
        
        ; Main code starts here
        
        MAIN ENDP
    END MAIN