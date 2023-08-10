.model small
.stack 100
.data



.code
main proc

mov ax,@data
mov ds,ax
mov ax,4c00h

; start


mov dl,"T"
push sp
jmp print_char

;end

mov ah,4ch
int 21h

print_char:                     ;print from dl
                mov ah,02h
                int 21h
                pop si
                jmp si


main endp
end main