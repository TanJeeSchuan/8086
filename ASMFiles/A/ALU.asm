.model small
.stack 100
.data

num1    DW  0025d           ;51.5278d     whole number    ;decimal number 要allocate 两个 WORD 来store
        DW  1500d           ;             mantissa  

num2    DW  0002d           ;45.8984d
        DW  0500d           

buffer  DW  10 DUP(0)       ;10 Bytes of value 0

newline EQU 10
decimal EQU 46d

.code
main proc

mov ax,@data
mov ds,ax
mov ax,4c00h

; start

call print_n            ;print newline

lea si,num1             ;load address of num1 into si
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

; call dec_add              ;add function
; call dec_sub              ;sub function
call dec_mul

lea si,num1
call print_dec

call print_n

; mov  ax,[buffer+8]
; call print_num

;end

mov ah,4ch
int 21h

endProgram:
mov dl,"T"
call print_char
mov ah,4ch
int 21h

ADD32           PROC                                        ;performs addition on dx:ax and bx:cx

ADD32           ENDP

DEC_MUL         PROC                                        ;performs multiplication from si and di, output in si
                        xor     ax,ax
                        xor     bx,bx
                        xor     cx,cx
                        xor     dx,dx

                        mov     ax,[si+2]
                        mov     bx,[di+2]

                        mul     bx                          ;dx will be carry, ax is (w(0,1,2) + previous_carry + ax*bx mod FFFFh)
                        push    ax                          ;w0
                        mov     cx,dx                       ;store carry at cx

                        xor     dx,dx
                        mov     ax,[si]

                        mul     bx
                        add     ax,cx                       ;ax + carry
                        push    ax                          ;w1
                        mov     cx,dx                       ;store carry at cx

                        xor     dx,dx
                        mov     ax,[si+2]
                        mov     bx,[di]

                        mul     bx
                        add     ax,cx                       ;add carry
                        pop     dx                          ;get w1
                        add     ax,dx                       ;w1 + ax*bx + carry
                        push    ax                          ;w1
                        mov     cx,dx                       ;carry as cx

                        xor     ax,ax
                        xor     dx,dx
                        mov     ax,[si]
                        mov     ax,[di]
                        
                        mul     bx
                        call    PRINT_NUM
                        call    print_n
                        add     ax,cx
                        push    ax                          ;w2

                        pop     ax                          ;get w2
                        call    PRINT_HEX
                        call    print_n
                        mov     [si],ax

                        pop     ax                          ;get w1
                        call    PRINT_HEX
                        call    print_n
                        mov     [si+2],ax

                        pop     ax                          ;throw away smallest digit partS
                        call    PRINT_HEX
                        call    print_n
                        
                        ret

                        
DEC_MUL         ENDP

DEC_ADD         PROC                                        ;performs decimal addition from si and di, modifies value in si
                        ;load mantissa
                        mov ax, [si + 2]                    ;一个word 2 byte，+2 来拿第二个word
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

                        mov [si + 2],ax                     ;load calculated mantissa

                        ;load whole number
                        mov ax, [si]
                        mov bx, [di]

                        adc ax,bx                           ;add with carry
                        mov [si],ax                         ;load into si

                        ret
DEC_ADD         ENDP

DEC_SUB         PROC                                        ;performs decimal addition from si and di, modifies value in si
                        mov ax,[si + 2]                     ;load mantissa values in address
                        mov bx,[di + 2]

                        sub ax,bx                           ;subtract mantissa

                        jc sub_overflow                     ;if carry flag set (有进位) (eng???) jump to sub_overflow

                        jmp sub_no_overflow
            sub_overflow:
                                neg ax                      ;negate ax, reverse two's complement
                                mov cx,10000d               ;prepare for substraction
                                sub cx,ax                   ;10000 subtract ax, to find the value of the ax in the limit of 10000
                                mov ax,cx
                                STC                         ;set carry flag for whole number subtraction

            sub_no_overflow:
                        mov [si+2],ax                       ;load mantisssa result in ax to si mantissa part

                        mov ax,[si]                         ;load whole numbers in memory to addresses
                        mov bx,[di]

                        sbb ax,bx                           ;subtract with carry

                        mov [si],ax                         ;load whole number result in ax to si whole number part

                        ret
DEC_SUB         ENDP

PRINT_DEC       PROC                                        ;print decimal from si
                        mov     ax, 0000h                   ;clean ax register
                        mov     ax, [si]                    ;load whole number
                        call    print_num_leading_zero      ;print whole number

                        mov     dl, decimal                 ;print decimal character
                        call    print_char

                        mov     ax, [si + 2]                ;load mantissa
                        call    print_num_leading_zero      ;print mantissa

                        ret
PRINT_DEC       ENDP

PRINT_NUM       PROC                                        ;print from ax              这个没有用到
                        push    ax                          ;preserves original register values
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

            IntPrint:   
                        pop     dx
                        add     dx,48d
                        int     21h
                        loop    IntPrint

                        pop dx                              ;restore original ax value
                        pop cx
                        pop bx
                        pop ax
                        ret
PRINT_NUM       ENDP

PRINT_CHAR      PROC                                        ;print from dl
                        push ax                             
                        mov ah,02h
                        int 21h
                        pop ax
                        ret
PRINT_CHAR      ENDP

PRINT_N         PROC                                        ;print newline
                        push dx
                        mov dl, newline
                        call print_char
                        pop dx
                        ret
PRINT_N         ENDP

PRINT_NUM_LEADING_ZERO PROC                                 ;print from ax with 4 places leading zeros. (eg. if ax=0021d, function will print 0021)
                            push    ax                      ;preserves original register values
                            push    bx
                            push    cx
                            push    dx
                            mov     bx,000Ah        
                            mov     cx,0000h
            Divloop_leading_zero:
                            mov     dx,0000h                ;clean dx
                            div     bx                      ;divide ax by 10
                            push    dx                      ;push remainder to stack
                            inc     cx                      ;increment cx to record number of times loop
                            test    ax,ax                   ;test the number of ax
                            jnz     Divloop_leading_zero    ;if ax is not zero jump to start of loop
            
            startCheck_leading_zero:
                            cmp cx,0004h                    ;if cx is below 
                            jl push_zero_leading_zero       ;if cx is below 4 jump to function that puts 0 in stack and increments cx

            mov ah,02h                                      ;setup for print
            IntPrint_leading_zero:                          ;print data in stack, number of data is recorded in cx
                            pop     dx
                            add     dx,"0"
                            int     21h
                            loop    IntPrint    

            pop dx                                          ;restore original register value
            pop cx
            pop bx
            pop ax
            ret

            push_zero_leading_zero:
                            mov ax,0h                       ;prepare for push
                            push ax                         ;push 0 to stack
                            inc cx                          ;cx++
                            jmp startCheck_leading_zero     ;jump to leading zero checker
PRINT_NUM_LEADING_ZERO ENDP

PRINT_HEX       PROC
                            push    ax                          ;preserves original register values
                            push    bx
                            push    cx
                            push    dx
                            mov     bx,0010h        
                            mov     cx,0000h
                DivloopHex:
                            mov     dx,0000h
                            div     bx
                            push    dx
                            inc     cx
                            test    ax,ax
                            jnz     DivloopHex

                            mov ah,02h                          ;setup for print

                IntPrintHex:   
                            pop     dx
                            cmp     dx,10d
                            jae     hexAdd
                    
                            add     dx,48d

                    endAdd:        
                            int     21h
                            loop    IntPrintHex

                            pop dx                              ;restore original ax value
                            pop cx
                            pop bx
                            pop ax
                            ret

                hexAdd:
                            add     dx,55d
                            jmp     endAdd

PRINT_HEX       ENDP

PRINT_BIN       PROC                                        ;print binary from ax
                            push    ax             ;preserves original register values
                            push    bx
                            push    cx
                            push    dx
                            mov     bx,0002h        
                            mov     cx,0000h
            DivloopB:
                            mov     dx,0000h
                            div     bx
                            push    dx
                            inc     cx
                            test    ax,ax
                            jnz     DivloopB
            mov ah,02h                          ;setup for print

            mov bx,0000h

            mov bx,16d                          ;max number of digits
            sub bx,cx                           ;number of leading zeros = max digits - number of chars to print

            mov dl,"0"                          ;prepare for print

            push cx                             ;store cx for later use
            mov  cx,bx

            test cx,cx                          ;if cx != 0, print 0 for cx number of times
            jnz Trailing0B

            jmp Trailing0BEnd

            Trailing0B:     int 21h
                            loop Trailing0B


            Trailing0BEnd:
            pop  cx

            IntPrintB:      pop     dx
                            add     dx,48d
                            int     21h
                            loop    IntPrintB

            pop dx                              ;restore original ax value
            pop cx
            pop bx
            pop ax
            ret
PRINT_BIN       ENDP

main endp
end main