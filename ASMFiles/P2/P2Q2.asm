.model small
.stack 100
.data

inputChar = 'H'

.code
main proc

mov ax,@data
mov ds,ax
mov ax,4c00h

; start

mov al,inputChar

mov dl,al
mov ah,02h
int 21h

mov dl,","
mov ah,02h
int 21h

mov al,inputChar
add al,32d

mov dl,al
mov ah,02h
int 21h

;end

mov ah,4ch
int 21h

main endp
end main