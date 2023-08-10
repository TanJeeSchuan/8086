.model small
.stack 100
.data
a db 0dh,0ah, "This is my first DEBUG Program"
b db 0dh,0ah, "$"

val1 DB 6
val2 DB 3
val3 DB 4
result DB ?

.code
main proc

mov ax,@data
mov ds,ax
mov ax,4c00h

; start

mov al,val2
add al,5
mov bl,val1
sub al,bl
mov bl,val3
add al,bl

mov result,al
add result,48d

mov dl,result
mov ah,02h
int 21h

;end

mov ah,4ch
int 21h

main endp
end main