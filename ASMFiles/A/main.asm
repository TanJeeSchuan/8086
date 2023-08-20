.MODEL small
.STACK 100
.DATA

buffer          DB 32
                DB ?
                DB 32 DUP(0)

.CODE
MAIN PROC

mov ax,@data
mov ds,ax
mov ax,4c00h

; start


call        NEWLINE

; lea         dx,password+1
; call        PRINT_STR

mov         dl,password+2
call        print_char

;end

mov ah,4ch
int 21h

MAIN ENDP

INPUT_STR       PROC
                            push        ax

                            xor         ax,ax

                            mov         dx, offset buffer               ;input string
                            mov         ah,0Ah
                            int         21h

                            pop         ax
                            ret
INPUT_STR       ENDP

PRINT_STR       PROC
                            push        ax
                            mov         ah,09d
                            int         21h
                            pop         ax
                            ret
PRINT_STR       ENDP

NEWLINE         PROC
                            push    dx
                            mov     dl,0Ah
                            call PRINT_CHAR
                            pop     dx
                            ret
NEWLINE         ENDP

PRINT_CHAR      PROC                                        ;print cjaracter of value in dl
                            push    ax
                            mov     ah,02h
                            int     21h
                            pop     ax
                            ret
PRINT_CHAR      ENDP

END MAIN