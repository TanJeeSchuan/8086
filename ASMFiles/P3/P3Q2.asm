.model small
.stack 100
.data

data1       DB    "MILK",'$'
data2       DB    4   dup ('*'),'$'

inital      DB    "Initial Content$"
after       DB    "After Replacement$"
reversed    DB    "After Reversed$"

data1Name   DB    "data1: $"
data2Name   DB    "data2: $"

.code
main proc

mov ax,@data
mov ds,ax
mov ax,4c00h

; start

call    NEWLINE

lea     dx,inital
call    PRINT_STR

call    NEWLINE

call    PRINT_DATA 

call    NEWLINE
call    NEWLINE

lea     si,data1
lea     di,data2
replacementLoop1:
        mov         al,[si]

        cmp         al,"$"      ;read until $
        je          replacementLoop1exit

        mov         [di],al
        inc         si
        inc         di
        jmp         replacementLoop1
replacementLoop1exit:

lea     dx,after
call    PRINT_STR

call    NEWLINE

call    PRINT_DATA 

call    NEWLINE
call    NEWLINE

lea     dx,reversed
call    PRINT_STR

call    NEWLINE

lea     si,data1
lea     di,data2
mov     cx,4d               ;length of string
call    REVERSE_STR

call    PRINT_DATA   
;end

mov ah,4ch
int 21h

main endp

PRINT_DATA      PROC
                        lea     dx,data1Name
                        call    PRINT_STR

                        lea     dx,data1
                        call    PRINT_STR
                        
                        call    NEWLINE

                        lea     dx,data2Name
                        call    PRINT_STR

                        lea     dx,data2
                        call    PRINT_STR
                        
                        ret
PRINT_DATA      ENDP

REVERSE_STR     PROC                            ;reverse SI to DI, length in cx
                        mov     bx  ,   0d      ;BX to be loop counter
                        add     si  ,   cx      ;move si to point to last element
                        dec     si              ;read until before seperator

                        revLoop:
                                mov     dl  ,   [si]         ;move value in dx to dl
                                mov     [di],   dl

                                dec     si              ;read backwards
                                inc     di              ;move forwards

                                inc     bx              ;loop counter

                                cmp     bx,cx
                                jb      revLoop         ;if =< string length     

                        ret
REVERSE_STR     ENDP

PRINT_STR       PROC
                        push    ax
                        mov     ah,09h
                        int     21h
                        pop    ax
                        ret
PRINT_STR       ENDP

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