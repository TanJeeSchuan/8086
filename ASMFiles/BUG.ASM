.model small
.stack 100
.data

str1        DB "Current Points : $"
str2        DB "Discount Amount: $"
points_num  DW 1224d
            DB "$"

discount    DB ? 

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

mov dl,10d
call print_char
            
lea dx,str2
call print_str

mov bx,000Ah
mov dx,0000h
div bx

call print_dec

;end

mov ah,4ch
int 21h

print_str:  mov ah,09h      ;print value from address in dx
            int 21h
            ret

print_num:  ;print from ax 
                            push ax             ;preserves original ax value
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
            
            call print_num
            mov dl,","
            mov ax,dx
            call print_num

            pop dx
            pop ax

main endp
end main
