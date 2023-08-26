.model small
.stack 100
.data

byteList DB 2, 4, 6, 8, 10, 12

.code
main proc

mov ax,@data
mov ds,ax
mov es,ax
mov ax,4c00h

; start

mov     ax,0h
mov     dx,0000h                                ;use DX as accumulator
mov     cx,6h                                   ;number of elements is array
mov     bx,0000h                                ;bx as tracker

lea     si,byteList

loopStart:  
                    mov     al,[si]             ;move si value to al
                    add     dl,al               ;add to dl

                    inc     si                  ;to next element

                    loop    loopStart

mov     ax,dx
call    PRINT_NUM
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

                            pop    ax
                            pop    bx
                            pop    cx
                            pop    dx

                            ret

PRINT_NUM           ENDP

NEWLINE         PROC
                        push    ax
                        push    dx
                        mov     dl,10d
                        mov     ah,02h
                        int     21h
                        pop     dx
                        pop     ax
                        ret
NEWLINE         ENDP

end main