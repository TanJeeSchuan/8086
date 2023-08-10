.model small
.stack 100

.data
msg db 'Hello World','$'
iA db 100

.code
main proc

mov ax,@data
mov ds,ax
mov ax,4c00h

; start
mov ah, 01h     ;get input
int 21h
mov bh, al

mov ah, 02h
mov dl, 0Ah
int 21h

mov ah, 01h     ;get input
int 21h
mov bl, al

mov ah, 02h
mov dl, 0Ah
int 21h

add bl,bh
mov dl, bl
sub dl, 48d
mov ah, 02h
int 21h

sub dl,'0'      ;to raw number
mov al,dl       ;move to ax

pushBCD:    mov bx,000Ah    ;set divisor
            div bx
            push dx
            inc cx          ;record number of digits processed in cx
            test ax,ax
            jnz pushBCD

printStack: pop dx
            add dl,"0"      ;ascii convert
            mov ah,02
            int 21h
            loop printStack ;decrement cx and jump until cx = 0

;end
mov ah,4ch
int 21h

;outside main function


main endp
end main