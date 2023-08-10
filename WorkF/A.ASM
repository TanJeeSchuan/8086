.model small
.stack 100
.data

points_num  DW 1233h
            DB "$"

discount    DB ? 

.code
main proc

mov ax,@data
mov ds,ax
mov ax,4c00h

; start

mov ah,09h
lea dx, points_num
int 21h

print_num: mov dx,points_num

;end

mov ah,4ch
int 21h

main endp
end main
