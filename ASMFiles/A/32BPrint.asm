.model small
.stack 100
.data

num1                DD 12345678d
buffer              DQ ?

.code
main proc

mov ax,@data
mov ds,ax
mov ax,4c00h

; start

lea si,num1

mov ax,[si]
mov bx,[si + 2]

call print_num
call newline

mov ax,bx
call print_num

;end

mov ah,4ch
int 21h

main endp

PRINT_NUM       PROC                                        ;print from ax              这个没有用到
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
PRINT_NUM       ENDP

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

GET_LOWER_DL    PROC                                        ;put last 4 bits of DL to BL, first 4 bits of DL to BH
                            push    cx
                            push    dx

                            mov     cl,4d
                            shl     dl,cl                   ;shifts left 4 then right 4 to get value of lower 4 bits
                            shr     dl,cl
                            mov     bl,dl

                            pop     dx                      
                            push    dx
                            shr     dl,cl                   ;shifts right 4 to get value of higher 4 bits
                            mov     bh,dl

                            pop     dx
                            pop     cx

                            ret
GET_LOWER_DL    ENDP

SHR_REG         PROC                                        ;shift dx:ax to the right
                            shr dx,1                    ;shift right will set carry flag will shifted bit is 1
                            rcr ax,1                    ;(Rotate through Carry Right)
                            ret
SHR_REG         ENDP

SHL_REG         PROC                                        ;shift dx:ax to the left
                            shl ax,1                    ;shift left will set carry flag will shifted bit is 1
                            rcl dx,1                    ;(Rotate through Carry left)
                            ret
SHL_REG         ENDP

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

SPACE           PROC
                            push dx
                            mov     dl," "
                            call PRINT_CHAR
                            pop     dx
                            ret
SPACE           ENDP

end main