.MODEL SMALL
.STACK 100
.DATA

bcdInputBuffer  DB  "$$$"

.CODE
MAIN            PROC
                mov ax, @data
                mov ds, ax
                xor ax, ax

                Mov	cx,	3
                Mov	bx,	3

                Mov	dl,	"1"
                L1:
                        Push	cx

                        L2:
                            Mov	ah, 02h
                            INT	21h
                            inc     dx
                            Loop	L2

                        push    dx
                        Mov	dl,	10d
                        Int	21h
                        pop     dx


                        Pop	cx
                        Dec	cx

                        Dec	bx
                        Cmp	bx,	0
                        Ja	L1

                mov ah, 4ch
                int 21h
MAIN ENDP

BCD_INPUT       PROC                    ;output to al
                push        si

                lea         si, bcdInputBuffer

                mov         cx, 3d      ;max number of times to loop
                xor         dx, dx      ;dl as temp value counter

                ;;get bcd input
                BCD_INPUT_LOOP:
                            mov         ah, 1h
                            int         21h

                            cmp         al, 13d
                            je          BCD_INPUT_LOOP_END
                            
                            sub         al, 48d
                            mov         [si],al

                            inc         si
                            loop        BCD_INPUT_LOOP  
                BCD_INPUT_LOOP_END:

                mov         ax, 1                   ;ax tracks 位数 of number, eg first number * 1, second number * 10, third number *
                lea         si, bcdInputBuffer+2
                mov         cx, 3d                  ;number of times to loop
                BCD_INPUT_CAL:
                            xor         bx, bx

                            mov         bl, [si]
                            cmp         bl, "$"     ;if is not digit
                            je          BCD_INPUT_CAL_NOT_DIGIT

                            push        ax              

                            push        dx                  ;mul will effect dx
                            mul         bx
                            pop         dx

                            add         dx, ax
                            pop         ax

                            push        dx                  ;mul will effect dx
                            mov         bx, 10d
                            mul         bx
                            pop         dx

                            BCD_INPUT_CAL_NOT_DIGIT:
                            dec         si
                            loop        BCD_INPUT_CAL

                mov         cx, 3d
                lea         si, bcdInputBuffer
                BCD_INPUT_CLEAR_STR:
                            mov         [bcdInputBuffer],   "$" 
                            loop        BCD_INPUT_CLEAR_STR
                mov         ax, dx
                pop         si
                ret
BCD_INPUT       ENDP

PRINT_STR       PROC
                            push        ax
                            mov         ah,09d
                            int         21h
                            pop         ax
                            ret
PRINT_STR       ENDP

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

NEWLINE         PROC
                            push    dx
                            mov     dl,0Ah
                            call PRINT_CHAR
                            pop     dx
                            ret
NEWLINE         ENDP

end main