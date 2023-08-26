.model small
.stack 100
.data

str1    DB  10d
        DB  "Do you want to continue printing (y/n)? $"
str2    DB  "Please enter y or n only"
        DB  10d
        DB  "$"

char    DB  "A"

.code
main proc

mov ax,@data
mov ds,ax
mov es,ax
mov ax,0h

; start

mov         dl,[char]
call        print_char

jmp         loopStart

error:      
            call        NEWLINE
            lea         dx,str2
            call        PRINT_STR

loopStart:
            lea         dx,str1
            call        PRINT_STR

            mov         ah,01h
            int         21h

            cmp         al,"y"
            je          incChar

            cmp         al,"n"
            je          loopEnd

            jmp         error

            incChar:
                        mov         dl,[char]
                        inc         dl
                        mov         [char],dl

                        call        NEWLINE
                        mov         dl,[char]
                        call        print_char

                        jmp         loopStart   

loopEnd:

;end

mov ah,4ch
int 21h

main endp

PRINT_STR       PROC
                        push    ax
                        mov     ah,09h
                        int     21h
                        pop    ax
                        ret
PRINT_STR       ENDP

PRINT_NUM       PROC                        ;print ax
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
PRINT_NUM       ENDP

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

end main