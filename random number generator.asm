; Random number generator - ChatGPT

.model small
.stack 100h
.data
    msg db 'Random number (1-9): $'
    num db ?

.code
main:
    mov ax, @data
    mov ds, ax

    ; Display message
    lea dx, msg
    mov ah, 09h
    int 21h

    ; Get pseudo-random seed from timer
    mov ah, 2Ch        ; DOS function to get time
    int 21h            ; CH=hour, CL=minute, DH=second, DL=hundredths (0-99)

    ; Use DL (0-99) safely with AX for division
    xor ah, ah         ; Clear AH, now AX = 00DL
    mov al, dl         ; Move hundredths into AL (zero-extended)
    mov bl, 9
    div bl             ; AX / BL ? AL = quotient, AH = remainder

    inc ah             ; Remainder was 0�8 ? now 1�9
    mov num, ah        ; Store result

    ; Print the number
    mov dl, num
    add dl, '0'
    mov ah, 02h
    int 21h

    ; Exit
    mov ah, 4Ch
    int 21h
end main
