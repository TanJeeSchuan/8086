.model small
.stack 100
.data

str1        DB "Current Points : $"
str2        DB "Discount Amount: $"
str3        DB "Remaining Points: $"
points_num  DW 1264h
            DB "$"

newline EQU 10

discount    DW 2 DUP (0)                   ;discount format

.code
main proc

mov ax,@data
mov ds,ax
mov ax,4c00h

; start

lea dx,str1
call print_str

mov ax,[points_num]
call print_num

mov dl,newline
call print_char
            
lea dx,str2
call print_str

mov ax,[points_num]
mov bx,100d
mov dx,0000h
div bx

mov [discount][0],ax
mov [discount][2],dx
call print_dec

mov dl,newline
call print_char
call print_char

lea dx,str3
call print_str

mov [points_num], 0000h     ;set points to zero
mov ax,[points_num]
call print_num

mov dl,newline
call print_char
call print_char

mov bx,TYPE WORD
mov ax,[discount][2]
call print_num

;end


mov ah,4ch
int 21h

print_str:  ;print value from address in dx
            push ax
            mov ah,09h      
            int 21h
            pop ax
            ret

print_num:  ;print from ax 
                            push ax             ;preserves original ax value
                            push bx
                            push cx
                            push dx
                            mov bx,000Ah        
                            mov cx,0000h
            Divloop:
                            mov dx,0000h
                            div bx
                            push dx
                            inc cx
                            test ax,ax
                            jnz Divloop
            mov ah,02h                          ;setup for print
            IntPrint:       pop dx
                            add dx,48d
                            int 21h
                            loop IntPrint

            pop ax                              ;restore original ax value
            pop bx
            pop cx
            pop dx
            ret

print_char: ;print from dl
            push ax                             
            mov ah,02h
            int 21h
            pop ax
            ret

print_dec:  ;print fixed point decimal AX = number, DX = mantissa
            push ax
            push dx
            push dx

            call print_num

            mov dl,"."
            call print_char

            pop dx
            add dh,48d
            add dl,48d

            push dx
            mov dl,dh
            call print_char
            pop dx
            call print_char

            pop ax
            pop dx

            ret

main endp
end main
