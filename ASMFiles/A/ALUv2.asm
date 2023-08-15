.MODEL SMALL
.STACK 100
.DATA

num1                DD  0FFFFFFFFh                               ;double type varoab;e

strNum1             DB  6
                    DB  "335.25"
                    DB  "$"

strNum2             DB  6
                    DB  "433.65"
                    DB  "$"

result              DB  20 DUP(?)

output              DB  50 DUP("$")

buffer              DB  20 DUP(?)
                    DB  "$"

.CODE
MAIN            PROC

mov ax,@data
mov ds,ax
mov ax,4c00h

; start

lea     si,strNum1
lea     di,strNum2
call    STRNUM_ADD

lea     si,result
call    PRINT_STR

;end

mov ah,4ch
int 21h

MAIN            ENDP

PRINT_DOUBLE    PROC
                        mov         dx,[si]
                        mov ax,[si + 2]
                        ret
PRINT_DOUBLE    ENDP

PRINT_STR       PROC                            ;print value from address in dx
                        push        ax
                        mov         ah,09h      
                        int 21h
                        pop         ax
                        ret
PRINT_STR       ENDP

STRNUM_ADD      PROC
                        mov         cl,[si]     ;number of chars
                        lea         dx,result

                        add         si,cx
                        add         di,cx
                        add         dx,cx

                        CLC

                        add_loop:
                                    
                                    mov     al,[si]
                                    cmp     al,"."     
                                    je      point
                                    sub     al,48d

                                    mov     ah,[di]
                                    cmp     ah,"."
                                    je      point
                                    sub     ah,48d

                                    add     al,ah
                                    add     al,bl

                                    cmp     al,9d
                                    ja      add_OF      ;if al is more than 9, overflow

                                    jmp     no_OF       ;no overflow

                                    add_OF:
                                            sub     al,10d
                                            mov     bl,1d                     ;set carry

                                    no_OF:

                                    add     al,"0"

                        point:      push    di
                                    mov     di,dx

                                    mov     [di],al
                                    pop     di

                                    dec     si
                                    dec     di
                                    dec     dx

                                    loop    add_loop

                        ret

                        
                                    

STRNUM_ADD      ENDP

PRINT_NUM       PROC                                        ;print from ax              
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

END MAIN