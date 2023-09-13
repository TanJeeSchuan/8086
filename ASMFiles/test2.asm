.MODEL      SMALL
.STACK      100
.DATA

strNumLen                   EQU 8      ;length of strNum

testStr     DB          "09951234", "$"

.CODE
MAIN        PROC
            mov         ax, @DATA
            mov         ds, ax
            xor         ax, ax

            lea         si, testStr
            call        PRINT_PRICE_STR


            
            mov         ah, 4Ch
            int         21h
MAIN        ENDP         

PRINT_PRICE_STR     PROC                                    ;do not print leading zero
                            push        si

                            xor         cx, cx
                            PRINT_PRICE_STR_ZERO_CHECK:     ;exit loop when found non zero
                                        mov         al, [si]
                                        inc         cx
                                        inc         si

                                        cmp         al, "$"
                                        je          PRINT_PRICE_STR_EXIT

                                        cmp         al, "0"
                                        je          PRINT_PRICE_STR_ZERO_CHECK
                            dec         si                  ;si is the address of the first number
                            dec         cx

                            mov         ax, strNumLen
                            sub         ax, cx
                            mov         cx, ax
                            
                            PRINT_PRICE_PRINT_LOOP:
                                        mov         dl, [si]
                                        call        PRINT_CHAR
                                        inc         si

                                        cmp         cx, 3
                                        je          PRINT_PRICE_DECIMAL
                                        loop        PRINT_PRICE_PRINT_LOOP

                                        jmp         PRINT_PRICE_STR_EXIT
                                        PRINT_PRICE_DECIMAL:
                                                    MOV         dl, "."
                                                    call        PRINT_CHAR                                                    
                                                    loop        PRINT_PRICE_PRINT_LOOP
                            
                            PRINT_PRICE_STR_EXIT:
                            pop         si
                            ret
PRINT_PRICE_STR     ENDP

PRINT_CHAR      PROC                                        ;print cjaracter of value in dl
                            push    ax
                            mov     ah,02h
                            int     21h
                            pop     ax
                            ret
PRINT_CHAR      ENDP

PRINT_STR           PROC
                            push        ax
                            mov         ah,09d
                            int         21h
                            pop         ax
                            ret
PRINT_STR       ENDP
  

END         MAIN