.MODEL SMALL
.STACK 100
.DATA

strNum1             DB  4                           ;number of places of whole number
                    DB  8                           ;length of number
                    DB  "5135.2537"
                    DB  "$"

strNum2             DB  4                           ;number of places of whole number
                    DB  8                           ;length of number
                    DB  "5973.6552"
                    DB  "$"

normal1             DB  50  DUP("$")

normal2             DB  50  DUP("$")

result              DB  20  DUP("$")

.CODE
MAIN            PROC

mov ax,@data
mov ds,ax
mov ax,4c00h

; start

lea     si,strNum1
lea     di,strNum2
call    STRNUM_ADD

lea     dx,strNum1
add     dx,2
call    PRINT_STR

call    NEWLINE

lea     dx,strNum2
add     dx,2
call    PRINT_STR

call    NEWLINE

lea     dx,result
call    PRINT_STR

;end

mov ah,4ch
int 21h

MAIN            ENDP

PRINT_STR       PROC                            ;print value from address in dx
                        push        ax
                        mov         ah,09h      
                        int 21h
                        pop         ax
                        ret
PRINT_STR       ENDP

REVERSE_STR     PROC                            
REVERSE_STR     ENDP

NORMALISE_STR   PROC                            ;output string number without decimal point from si to di
                        xor         ax,ax
                        xor         bx,bx
                        xor         cx,cx
                        xor         dx,dx

                        push        di

                        mov         cl,[si+2]   ;load size of string to cl
                        inc         cl
                        
                        normalLoop:  
                                    mov         al,[si]
                                    cmp         al,"."              ;if character is '.'
                                    je          normalise_dot

                                    mov         [di],al
                                    
                                    inc         si
                                    inc         di

                                    loop        normalLoop

                        pop         di
                        ret

                        normalise_dot:
                                    inc         si
                                    jmp         normalLoop
NORMALISE_STR   ENDP

STRNUM_ADD      PROC                            ;add numbers in si and di. output in result. numbers must have same places
                        xor         ax,ax
                        xor         bx,bx
                        xor         cx,cx
                        xor         dx,dx

                        push        di                      ;remove the decimal point from si string
                        lea         di,normal1
                        call        NORMALISE_STR   
                        pop         di

                        mov         si,di                   ;remove the decimal point from di string
                        lea         di,normal2
                        call        NORMALISE_STR

                        xor         ax,ax
                        xor         bx,bx
                        xor         cx,cx
                        xor         dx,dx

                        ;CALCULATION START

                        lea         si,normal1
                        lea         di,normal2

                        mov         cl,[si+1]                   ;get length of first str
                        mov         dl,[di+1]                   ;get length of second str

                        add         si,2                        ;offset to the start of number
                        add         di,2

                        dec         cx                          ;decrement address by one due to decimal point being removed, length - 1
                        dec         dx

                        add         si,cx                       ;address to last number
                        add         di,dx

                        lea         dx,result

                        push        di
                        push        si

                        lea         di      ,[normal1]
                        lea         si      ,[result]

                        mov         al      ,[di]
                        mov         [si]    ,al

                        mov         al      ,[di+1]
                        mov         [si+1]  ,al

                        pop         si
                        pop         di

                        add         dx,2

                        inc         cx

                        addLoop:    
                                    mov         ah,[si]
                                    sub         ah,48d

                                    mov         al,[di]
                                    sub         al,48d

                                    add         al,ah
                                    add         al,bl                       ;add carry
                                    xor         bx,bx                       ;reset carry

                                    ;carry
                                    cmp         al,10d
                                    jae         add_carry
                                    jmp         add_nocarry

                                    add_carry:
                                                sub         al,10d          ;subtract 10 from result
                                                mov         bl,1d           ;carry in bl

                                    add_nocarry:
                                                add         al,48d

                                                push        di              ;store di
                                                mov         di  ,dx
                                                mov         [di],al         ;load to result
                                                pop         di

                                    dec         si
                                    dec         di
                                    inc         dx

                                    loop        addLoop

                        test        bl,bl                                   ;if bl is zero, append the result
                        jnz         add_append
                        jmp         add_noappend

                        add_append:
                                    mov         di  ,dx

                                    mov         al  ,[di+1]
                                    inc         al
                                    mov         [di+1],al

                                    add         bl  ,48d
                                    mov         [di],bl                     ;append carry to result 

                        add_noappend:

                        ret
STRNUM_ADD      ENDP

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