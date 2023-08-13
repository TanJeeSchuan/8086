.MODEL SMALL
.STACK 100
.DATA

num1                DD  0FFFFFFFFh                               ;double type varoab;e

strNum1             DB  "525.25"

strNum2             DB  "475.75"

output              DB  50 DUP("$")

buffer              DB 20 DUP(?)
                    DB "$"

.CODE
MAIN            PROC

mov ax,@data
mov ds,ax
mov ax,4c00h

; start



;end

mov ah,4ch
int 21h

MAIN            ENDP

PRINT_DOUBLE    PROC
                        mov dx,[si]
                        mov ax,[si + 2]
                        ret
PRINT_DOUBLE    ENDP

STRNUM_ADD      PROC
                        mov dx
STRNUM_ADD      ENDP

END MAIN