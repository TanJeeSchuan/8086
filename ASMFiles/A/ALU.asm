.model small
.stack 100
.data

num1    DW  0051d           ;51.5278d 
        DW  8984d

num2    DW  0045d           ;45.8984d
        DW  5278d           

Rnum    DW  ?
        DW  ?

newline EQU 10
decimal EQU 46d

.code
main proc

mov ax,@data
mov ds,ax
mov ax,4c00h

; start

call print_n

lea si,num1
call print_dec

call print_n
call print_n

lea si,num2
call print_dec

call print_n
call print_n

;load addresses
lea si,num1
lea di,num2

; call dec_add
call dec_sub


lea si,num1
call print_dec


;end

mov ah,4ch
int 21h

endProgram:
mov dl,"T"
call print_char
mov ah,4ch
int 21h

dec_add   :                                         ;performs decimal addition from si and di, modifies value in si


                        ;load mantissa
                        mov ax, [si + 2]                  ;一个word 2 byte，+2 来拿第二个word
                        mov bx, [di + 2]

                        add ax,bx                           ;add mantissa

                        cmp ax,2710h                        ;check if mantissa exceeds 10000
                        jae over_10000                      ;if mantissa >= 10000

                        jmp no_overflow                     ;if not exceed 10000 jump over over_10000: function

                        over_10000:
                        sub ax,2710h                        ;subtract 10000 from mantissa
                        STC                                 ;set carry flag for whole number addition

                        no_overflow:
                        mov cx,0000h                        ;
                        mov [si + 2],cx                     ;set [si + 2] to zero

                        mov [si + 2],ax                   ;load calculated mantissa

                        ;load whole number
                        mov ax, [si]
                        mov bx, [di]

                        adc ax,bx                           ;add with carry
                        mov [si],ax                       ;load into si

                        ret

dec_sub   :                                         ;performs decimal addition from si and di, modifies value in si
                        mov ax,[si + 2]                                 ;load mantissa values in address
                        mov bx,[di + 2]

                        sub ax,bx                                       ;subtract mantissa

                        jc sub_overflow                                 ;if carry flag set (有进位) (eng???) jump to sub_overflow

                        jmp sub_no_overflow
                        sub_overflow:
                                neg ax                                  ;negate ax, reverse two's complement
                                mov cx,10000d                           ;prepare for substraction
                                sub cx,ax                               ;10000 subtract ax, to find the value of the ax in the limit of 10000
                                mov ax,cx
                                STC                                     ;set carry flag for whole number subtraction

                        sub_no_overflow:
                        mov [si+2],ax                                   ;load mantisssa result in ax to si mantissa part

                        mov ax,[si]                                     ;load whole numbers in memory to addresses
                        mov bx,[di]

                        sbb ax,bx                                       ;subtract with carry

                        mov [si],ax                                     ;load whole number result in ax to si whole number part

                        ret

dec_mul   :                                         ;performs decimal multiplication
                        mov ax,

print_dec :                                         ;print decimal from si
                            mov     ax, 0000h
                            mov     ax, [si]
                            call    print_num_leading_zero

                            mov     dl, decimal
                            call    print_char

                            mov     ax, [si + 2]
                            call    print_num_leading_zero
            ret

print_num :                                         ;print from ax 
                            push    ax             ;preserves original register values
                            push    bx
                            push    cx
                            push    dx
                            mov     bx,000Ah        
                            mov     cx,0000h
            Divloop:
                            mov     dx,0000h
                            div     bx
                            push    dx
                            inc     cx
                            test    ax,ax
                            jnz     Divloop
            mov ah,02h                          ;setup for print
            IntPrint:       pop     dx
                            add     dx,48d
                            int     21h
                            loop    IntPrint

            pop dx                              ;restore original ax value
            pop cx
            pop bx
            pop ax
            ret

print_char:                                         ;print from dl
            push ax                             
            mov ah,02h
            int 21h
            pop ax
            ret

print_n   :                                         ;print newline
            push dx
            mov dl, newline
            call print_char
            pop dx
            ret

print_num_leading_zero :                            ;print from ax with 4 places leading zeros. (eg. if ax=0021d, function will print 0021)
                            push    ax              ;preserves original register values
                            push    bx
                            push    cx
                            push    dx
                            mov     bx,000Ah        
                            mov     cx,0000h
            Divloop_leading_zero:
                            mov     dx,0000h
                            div     bx
                            push    dx
                            inc     cx
                            test    ax,ax
                            jnz     Divloop_leading_zero
            
            startCheck_leading_zero:
                            cmp cx,0004h                        ;if cx ]is below 
                            jl push_zero_leading_zero

            mov ah,02h                          ;setup for print
            IntPrint_leading_zero:       
                            pop     dx
                            add     dx,"0"
                            int     21h
                            loop    IntPrint

            pop dx                              ;restore original ax value
            pop cx
            pop bx
            pop ax
            ret

            push_zero_leading_zero:
                            mov ax,0h
                            push ax
                            inc cx

                            ; mov dl,"T"
                            ; call print_char
                            jmp startCheck_leading_zero



main endp
end main