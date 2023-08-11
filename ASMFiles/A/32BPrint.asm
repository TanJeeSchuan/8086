.model small
.stack 100
.data
.code
main proc

mov ax,@data
mov ds,ax
mov ax,4c00h

; start

mov dx,0001h
mov ax,1000000000000000b

DDLess4Check:
                            call    SHR_REG
                            call    print_bin
                            call    newline

                            test ax,ax
                            jnz DDLess4Check

;end

mov ah,4ch
int 21h

main endp

PRINT_NUM   PROC                                        ;print from ax              这个没有用到
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
PRINT_NUM   endp

PRINT_BIN   PROC
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
            IntPrintB:      pop     dx
                            add     dx,48d
                            int     21h
                            loop    IntPrintB

            pop dx                              ;restore original ax value
            pop cx
            pop bx
            pop ax
            ret
PRINT_BIN   endp

SHR_REG     PROC                                        ;shift dx:ax to the right
                            shr dx,1                    ;shift right will set carry flag will shifted bit is 1
                            rcr ax,1                    ;(Rotate through Carry Right)
                            ret
SHR_REG     ENDP

SHL_REG     PROC                                        ;shift dx:ax to the left
                            shl dx,1                    ;shift left will set carry flag will shifted bit is 1
                            rcl ax,1                    ;(Rotate through Carry left)
                            ret
SHL_REG     ENDP

PRINT_CHAR  PROC                                        ;print cjaracter of value in dl
                            push    ax
                            mov     ah,02h
                            int     21h
                            pop     ax
                            ret
PRINT_CHAR  ENDP

NEWLINE     PROC
                            push    dx
                            mov     dl,0Ah
                            call PRINT_CHAR
                            pop     dx
                            ret
NEWLINE     ENDP
end main