.MODEL SMALL
.STACK 100
.DATA

str1        DB  "This is my favorite$"

strA        DB  " A = $"
strE        DB  " E = $"
strI        DB  " I = $"
strO        DB  " O = $"
strU        DB  " U = $"

VowelA      DB  0
VowelE      DB  0
VowelI      DB  0
VowelO      DB  0
VowelU      DB  0
.CODE
MAIN PROC

MOV AX,@DATA
MOV DS,AX

; START

lea         si, str1

; countL:
            ; MOV     al, [si]
            ; inc     si

            lea     si, Str1
            mov     bl, "a"
            call    COUNT_CHAR
            mov     [VowelA],   al

            mov     bl, "e"
            call    COUNT_CHAR
            mov     [VowelE],   al

            mov     bl, "i"
            call    COUNT_CHAR
            mov     [VowelI],   al

            mov     bl, "o"
            call    COUNT_CHAR
            mov     [VowelO],   al

            mov     bl, "u"
            call    COUNT_CHAR
            mov     [VowelU],   al

            lea     dx, strA
            call    PRINT_STR
            mov     dl, [VowelA]
            call    PRINT_CHAR

            lea     dx, strE
            call    PRINT_STR
            mov     dl, [VowelE]
            call    PRINT_CHAR

            lea     dx, strI
            call    PRINT_STR
            mov     dl, [VowelI]
            call    PRINT_CHAR

            lea     dx, strO
            call    PRINT_STR
            mov     dl, [VowelO]
            call    PRINT_CHAR

            lea     dx, strU
            call    PRINT_STR
            mov     dl, [VowelU]
            call    PRINT_CHAR
;END

MOV AH,4CH
INT 21H

MAIN ENDP

PRINT_CHAR      PROC                                        ;print cjaracter of value in dl
                            push    ax
                            add     dl, 48d
                            mov     ah, 02h
                            int     21h
                            pop     ax
                            ret
PRINT_CHAR      ENDP

PRINT_STR       PROC
                            push        ax
                            mov         ah,09d
                            int         21h
                            pop         ax
                            ret
PRINT_STR       ENDP

COUNT_CHAR      PROC                                        ;compare si and bl
                            push    si

                            xor     ax, ax
                            COUNT_CHARL:
                                    mov     dl, [si]
                                    inc     si
                                    cmp     dl, "$"
                                    je      COUNT_CHARL_EXIT

                                    cmp     dl, bl
                                    jne     COUNT_CHARL

                                    inc     ax
                                    jmp     COUNT_CHARL
                            COUNT_CHARL_EXIT:

                            pop     si
                            ret
COUNT_CHAR      ENDP

END MAIN