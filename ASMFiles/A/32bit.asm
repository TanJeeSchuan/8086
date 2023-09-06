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

add         si, 2

xor         ax, ax
mov         bx, 10d
mov         cx, 2d      ;j = n - 1
xor         dx, dx      ;r = 0
lea         di, result + 2
long_print_loop:
            mov         ax, dx
            mul         bx
            mov         dx, ax

            xor         ax,ax

            mov         ax, [si]
            add         ax, dx          ;remainder * base + u[j]
            xor         dx, dx
            div         bx              ;DONT TOUCH DX

            ; ;;print dx
            ; push        ax
            ; mov         ax,dx
            ; call        print_num
            ; pop         ax
            ; call        newline
            
            mov         [di],ax

            sub         si, 2
            sub         di, 2
            loop        long_print_loop

mov         ax,[result+2]
call        print_num


mov         ah, 4ch
int         21h
MAIN        ENDP

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