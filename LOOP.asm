.model small
.stack 100h
.data
    msg db 'HELLO PAKISTAN : $'
    NUM DB 1
dispstr macro s
        lea dx,s
        mov ah,09h
        int 21h
 dispstr endm
 newline macro
    mov dl,0dh
    mov ah,02h
    int 21h
    mov dl,0ah
    mov ah,02h
    int 21h
    
 newline endm
 .code
    main proc far
        mov ax,@data
        mov ds,ax
        
        MOV CX,9
        
  AGIAN:      
        MOV DL,NUM
        ADD DL,48
        MOV AH,02H
        INT 21H
        
        NEWLINE
        INC NUM
        LOOP AGIAN
        
        
        mov ah,4ch
        int 21h
        main endp
    end main