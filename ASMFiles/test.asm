.MODEL      SMALL
.STACK      100
.DATA

.CODE
MAIN        PROC
            mov         ax, @DATA
            mov         ds, ax
            xor         ax, ax

            mov         ah, 01h
            L1:
                        int         21h
                        cmp         al, 13d
                        je          L1_EXIT

                        cmp         al, 8d
                        je          L1_BACKSPACE
                        jmp         L1

                        L1_BACKSPACE:
                                    mov         dl, " "
                                    call        PRINT_CHAR
                                    mov         dl, 8d
                                    call        PRINT_CHAR
                        jmp         L1
            L1_EXIT:
            mov         ah, 4Ch
            int         21h
MAIN        ENDP         

PRINT_CHAR      PROC                                        ;print cjaracter of value in dl
                            push    ax
                            mov     ah,02h
                            int     21h
                            pop     ax
                            ret
PRINT_CHAR      ENDP


END         MAIN