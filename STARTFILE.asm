.model small
.stack 100
.data
.code
main proc

mov ax,@data
mov ds,ax
mov ax,4c00h

; start

;end

mov ah,4ch
int 21h

main endp
end main