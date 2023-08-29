.model small
.stack 100
.data

fibonacciArr    DB  1,1
                DB  50  DUP(0) 

.code
main proc

mov ax,@data
mov ds,ax
mov ax,4c00h

; start

xor     ax,ax
xor     bx,bx
xor     cx,cx
xor     dx,dx

mov     cx,8d    ;print how many values

lea     si,fibonacciArr

add     si,3d   ;start from the third element of array

fiboLoop:       
                xor     bx,bx
                mov     al,[si - 2]
                mov     ah,[si - 1]

                add     bl,al
                add     bl,ah

                mov     [si],bl

                inc     si

                xor     ax,ax
                mov     al,bl
                call    PRINT_NUM

                mov     dl,","
                mov     ah,02h
                int     21h

                loop    fiboLoop
                

;end

mov ah,4ch
int 21h

main endp

PRINT_NUM           PROC                        ;print ax
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

PRINT_NUM           ENDP

NEWLINE             PROC
                            push    ax
                            push    dx
                            mov     dl,10d
                            mov     ah,02h
                            int     21h
                            pop     dx
                            pop     ax
                            ret
NEWLINE             ENDP

end main
