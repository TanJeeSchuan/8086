.MODEL small
.STACK 100
.DATA

buffer          DB 32
                DB ?
                DB 32 DUP(0)
                DB "$"

password        DB 21 DUP("0")

correctPass     DB "12345ABC"
                DB "$"

enterText       DB "Enter Password: $"

pwIncorrect     DB "Incorrect password! Chances left $"
pwCorrect       DB "Correct password! Welcome!$"

loginChances    DB 3

logo            DB "				ABC$"

.CODE
MAIN PROC

mov ax,@data
mov ds,ax
mov ax,4c00h

lea         dx,logo
call        PRINT_STR

; start
passCheck:

call        NEWLINE
call        NEWLINE

lea         dx,enterText
call        PRINT_STR

lea         di,password
call        input_str

call        NEWLINE

lea         si,password
lea         di,correctPass
call        STRCMP                                          ;will return 0 if string matches  

cmp         ax,0
jz          pass_correct                                    ;jump if password is correct
;;this code will run if password is incorrect
            mov         dl,[loginChances]
            cmp         dl,0
            jz          exit                                ;if no chances left

            lea         dx,pwIncorrect
            call        PRINT_STR

            mov         dl,[loginChances]
            dec         dl
            mov         [loginChances],dl
            add         dl,48d
            call        PRINT_CHAR

            jmp         passCheck
pass_correct:
            call        NEWLINE
            lea         dx,pwCorrect
            call        PRINT_STR
pass_check_end:

call        NEWLINE
call        NEWLINE


;end
exit:
mov ah,4ch
int 21h

MAIN ENDP

STRLEN          PROC                                        ;output length of si in ax
                        push        si
                        xor         dx,dx
                        xor         bx,bx
                        xor         ax,ax

                        strlenLoop:
                                    mov     bl,[si]
                                    cmp     bl,"$"
                                    je      strlenLoopEnd

                                    inc     si
                                    inc     ax

                                    jmp     strlenLoop

                        strlenLoopEnd:

                        pop         si
                        ret
STRLEN          ENDP

INPUT_STR       PROC                                        ;read input and move to address in di
                            push        ax
                            push        dx
                            push        di
                            xor         ax,ax
                            xor         cx,cx

                            mov         dx, offset buffer               ;input string
                            mov         ah,0Ah
                            int         21h

                            mov         cl,[buffer+1]                   ;move length of input to cl

                            mov         ah,"$"
                            lea         di,buffer+2                     ;offset to start of string value
                            add         di,cl                           ;move to after last character
                            mov         [di],ah                         ;move $ character to last place

                            pop         di
                            push        di

                            lea         si,buffer+2
                            xor         ch,ch
                            inc         cl
                            input_str_cpy:
                                        mov         ah,[si]
                                        mov         [di],ah

                                        inc         si
                                        inc         di
                                        loop        input_str_cpy

                            pop         di
                            pop         dx
                            pop         ax
                            ret
INPUT_STR       ENDP

STRCMP          PROC                                        ;compares string in si and di, if equal will return 0 in ax
                            push        si
                            push        di

                            xor         ax,ax
                            STRCMP_LOOP_START:
                                        mov         al,[si]
                                        mov         ah,[di]
                                        
                                        inc         si
                                        inc         di

                                        cmp         al,"$"
                                        je          STRCMP_LOOP_END

                                        cmp         al,ah
                                        je          STRCMP_LOOP_START

                            STRCMP_LOOP_END:
                            sub         al,ah               ;return sub of both strings
                            xor         ah,ah

                            pop         di
                            pop         si
                            ret
STRCMP          ENDP

PRINT_STR       PROC
                            push        ax
                            mov         ah,09d
                            int         21h
                            pop         ax
                            ret
PRINT_STR       ENDP

PRINT_NUM       PROC                                        ;print from ax              
                        push    ax                          ;preserves original register values
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

            IntPrint:   
                        pop     dx
                        add     dx,48d
                        int     21h
                        loop    IntPrint

                        pop dx                              ;restore original ax value
                        pop cx
                        pop bx
                        pop ax
                        ret
PRINT_NUM       ENDP

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