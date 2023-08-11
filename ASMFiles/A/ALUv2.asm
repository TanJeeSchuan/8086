.model small
.stack 100
.data

num1                DB  4                               ;decimal location from end of number
                    DD  10041231d                       ;1004.1231

buffer              DB 20 DUP(?)
                    DB "$"

.code
main proc

mov ax,@data
mov ds,ax
mov ax,4c00h

; start




;end

mov ah,4ch
int 21h

print_dec:                                          ;print number in di
                        mov  cx,[di]                ;load location of decimal point in number
                        


print_lnum:                                          ;print large number in si in decimal format
                        push ax
                        push bx
                        push cx
                        push dx

                        xor cx,cx
                        mov bx,000Ah
                        
    print_lnum_div_loop: 
                        xor dx,dx                   ;set dx to zero
                        div bx
                        push dx
                        inc cx
                        test ax,ax
                        jnz print_num_div_loop

                        mov ah, 02h

    print_lnum_print_lp: 
                        pop dx
                        add dx,"0"
                        int 21h
                        loop print_num_print_lp

                        pop ax
                        pop bx
                        pop cx
                        pop dx

                        ret

print_num:                                          ;print number in ax in decimal format
                        push ax
                        push bx
                        push cx
                        push dx

                        xor cx,cx
                        mov bx,000Ah
                        
    print_num_div_loop: 
                        xor dx,dx                   ;set dx to zero
                        div bx
                        push dx
                        inc cx
                        test ax,ax
                        jnz print_num_div_loop

                        mov ah, 02h

    print_num_print_lp: 
                        pop dx
                        add dx,"0"
                        int 21h
                        loop print_num_print_lp

                        pop ax
                        pop bx
                        pop cx
                        pop dx

                        ret

main endp
end main