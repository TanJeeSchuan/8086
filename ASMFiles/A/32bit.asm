.MODEL SMALL
.STACK 100
.DATA

long1       DW  00BCh
            DW  614Fh

result      DW  2   DUP(?)
            DB  "$"

.CODE
MAIN        PROC
mov         ax, @DATA
mov         ds, ax
xor         ax, ax


lea         si, long1
mov         bx, 10d

xor         cx, cx
PRINT_LONG_LOOP:
            call        DIV_LONG
            ; inc         cx

            ; add         dx, 48d
            ; call        PRINT_CHAR

            ; mov         ax, [si+2]
            ; test        ax, ax
            ; jnz         PRINT_LONG_LOOP

            ; mov         ax, [si]
            ; test        ax, ax
            ; jnz         PRINT_LONG_LOOP

xor         ax,ax
call        NEWLINE
mov         al, [long1+3]
call        PRINT_NUM


mov         ah, 4ch
int         21h
MAIN        ENDP

DIV_LONG        PROC                                    ;si 的doubleword / bx， remainder 在 dx
                            push    si
                            push    ax
                            push    bx
                            push    cx

                            mov     bx, 10d
                            mov     cx, 4d
                            xor     dx, dx

                            DIV_LONG_LOOP:
                                    push    bx
                                    mov     bx, 100h
                                    mov     ax, dx          
                                    mul     bx              ;remainder (dx) * 100h
                                    add     ax, [si]        ;+ divWord[i]
                                    pop     bx

                                    xor     dx, dx
                                    div     bx

                                    mov     [si],al
                                    inc     si

                                    call    NEWLINE
                                    call    PRINT_NUM

                                    loop    DIV_LONG_LOOP

                            pop     cx
                            pop     bx
                            pop     ax
                            pop     si
                            ret
DIV_LONG        ENDP

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

END         MAIN