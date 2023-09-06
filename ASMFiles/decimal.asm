.model small
.stack 100
.data

.code
main proc

mov ax,@data
mov ds,ax
mov ax,0h

; start

mov     ax,99d          ;initialise value
mov     bx,3d

xor     dx,dx           ;set to 0
div     bx              ;ax/bx  dx 是remainder

call    PRINT_NUM       ;print ax

mov     cx,4            ;precision (几个小数位?)

push    dx          
mov     dl, "."
call    PRINT_CHAR
pop     dx

decimalLoop:
        mov         ax,dx   
        mov         dx,10   
        mul         dx          ;remainder*10

        xor         dx,dx
        div         bx          ;(remainder*10)/bx

        call        PRINT_NUM   ;print ax

        loop        decimalLoop


;end

mov ah,4ch
int 21h

main endp

PRINT_STR       PROC
                        push    ax
                        mov     ah,09h
                        int     21h
                        pop    ax
                        ret
PRINT_STR       ENDP

PRINT_NUM       PROC                        ;print ax
                            push    ax
                            push    bx
                            push    cx
                            push    dx

                            mov     bx,0Ah      ;initalise divisor
                            mov     cx,0h
                            
                            divLoop:    
                                        xor     dx,dx       ;clear remainder
                                        div     bx
                                        push    dx          ;save remainder
                                        inc     cx          ;count looped number
                                        test    ax,ax       ;if ax != 0, continue
                                        jnz     divLoop

                            mov     ah,02h

                            printLoop:  
                                        pop     dx          ;get remainder
                                        add     dl,"0"
                                        int     21h         ;print
                                        loop    printLoop   ;loop until cx is zero (the number of times divLoop)

                            pop    dx
                            pop    cx
                            pop    bx
                            pop    ax

                            ret
PRINT_NUM       ENDP

PRINT_CHAR      PROC                                        ;print cjaracter of value in dl
                            push    ax
                            mov     ah,02h
                            int     21h
                            pop     ax
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