.model small
.stack 100
.data

str1    DB  "There are $"
str2    DB  " positive and $"
str3    DB  " negative values in the list.$"

list    DB  12, 29, -9, 5, -48, 20, 0

posInt  DB  0
negInt  DB  0

.code
main proc

mov ax,@data
mov ds,ax
mov es,ax
mov ax,0h

; start


lea     si,list

loopStart:      
                mov     al,[si]

                inc     si

                test    al,al

                jz      exitLoop

                js     negative            ;if signed flag is set, al is negative
                
                jmp     positive
                negative:
                            mov     bl,[negInt]
                            inc     bl
                            mov     [negInt],bl
                            jmp     loopStart

                positive:
                            mov     bl,[posInt]
                            inc     bl
                            mov     [posInt],bl
                            jmp     loopStart    

exitLoop:

lea     dx,str1
call    PRINT_STR

xor     ax,ax
mov     al,[posInt]
call    PRINT_NUM

lea     dx,str2
call    PRINT_STR

xor     ax,ax
mov     al,[negInt]
call    PRINT_NUM

lea     dx,str3
call    PRINT_STR
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

end main