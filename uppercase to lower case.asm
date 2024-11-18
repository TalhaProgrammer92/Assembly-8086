.model small
.stack 100h
.data
    msg db 'Enter a character in Upper Case : $'
    msg1 db 'Character in Lower Case: $'
    chr db ?
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
        dispstr msg 
        mov ah,01h
        int 21h
        mov chr,al
        newline
        dispstr msg1
        mov dl,chr
        add dl,32
        mov ah,02h
        int 21h
        mov ah,4ch
        int 21h
        main endp
    end main