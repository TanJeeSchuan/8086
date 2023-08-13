.model small
.stack 100
.data

var1 DB "T"
var2 DB "A"

.code
main proc

mov ax,@data
mov ds,ax
mov ax,4c00h

; start

mov dl,"("
mov ah,02h
int 21h
mov dl,var1
int 21h
mov dl,","
int 21h
mov dl,var2
int 21h
mov dl,")"
int 21h
mov dl,">"
int 21h

mov bl,var1
mov bh,var2
mov var1,bh
mov var2,bl


mov dl,"("
mov ah,02h
int 21h
mov dl,var1
int 21h
mov dl,","
int 21h
mov dl,var2
int 21h
mov dl,")"
int 21h

;end

mov ah,4ch
int 21h

main endp
end main