; Assembly program to print "Hello World"

; This directive specifies the memory model to be used for the program.
; SMALL model is chosen, which limits the code and data segments to 64KB each.
.MODEL SMALL    

; This directive allocates 100H (256 decimal) bytes of memory for the stack.
; The stack is used for storing function parameters, return addresses, and local variables during program execution.
.STACK 100H

; This directive marks the beginning of the data segment. 
.DATA
    ; This line defines a byte array named MSG and initializes it with the string "Hello World" followed by a dollar sign ($).
    ; The dollar sign is a string termination character. 
    MSG DB 'Hello World$'

; This directive marks the beginning of the code segment.
.CODE
    ; This line defines a procedure named MAIN as a far procedure.
    ; Far procedures can be called from any segment in memory. 
    MAIN PROC FAR
        ; This instruction moves the address of the data segment into the AX register.        
        MOV AX, @DATA
        ; This instruction copies the contents of AX (the data segment address) into the DS register.
        ; The DS register is used to access data in the data segment.
        MOV DS, AX
        
        ; Display the message
        ; This instruction moves the offset (address within the segment) of the MSG variable into the DX register. 
        MOV DX, OFFSET MSG
        ; This instruction loads the function number 09H into the AH register.
        ; This function number corresponds to the DOS function to display a string.
        MOV AH, 09H
        ; This instruction interrupts the processor and calls the DOS interrupt handler.
        ; The AH register contains the function number, and the DX register contains the address of the string to be displayed.
        ; The DOS interrupt handler will display the string "Hello World" on the screen.
        INT 21H
        
        ; Exit
        ; This instruction loads the function number 4CH into the AH register.
        ; This function number corresponds to the DOS function to terminate the program.
        MOV AH, 4CH
        ; This instruction interrupts the processor and calls the DOS interrupt handler.
        ; The DOS interrupt handler will terminate the program.
        INT 21H
        
        ; This directive marks the end of the MAIN procedure.
        MAIN ENDP
    ; This directive marks the end of the assembly program. 
    END MAIN