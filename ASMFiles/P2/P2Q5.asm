.model small
.stack 100
.data

str1 DB "Please enter a digit: $"
str2 DB " times $"
str3 DB " returns: $"

.code
main proc

mov ax,@data
mov ds,ax
mov ax,4c00h

; start

lea dx,str1
mov ah,09h
int 21h

mov ah,0001h    ;input
int 21h
mov bl,al

mov ah,02h      ;print \n
mov dl, 10d
int 21h

mov dl,bl       ;print input
int 21h

lea dx,str2     ;print times
mov ah,09h  
int 21h

mov ah,02h      ;print input
mov dl,bl
int 21h

mov ah,09h      ;print returns:
lea dx,str3
int 21h

sub bl,48d      ;multiply
mov al,bl
mul bl

; mov ah,02h      ;print result (single digit only)
; mov dl,al
; add dl,48d
; int 21h

;;METHOD 1
; mov bl,0Ah
; div bl          ;divide ax by bl, al will be quotient, ah is remainder

; mov cl,ah       ;save AH because remainder is last

; mov ah,02h      ;print quotient
; mov dl,al
; add dl,"0"
; int 21h

; mov dl,cl       ;print remainder
; add dl,"0"
; int 21h

; mov     bx,000Ah

; div     bx
; push    dx

; div     bx
; push    dx

; mov     ah,02h

; pop     dx
; int     21h

; pop     dx
; int     21h

call    PRINT_NUM

;end

mov ah,4ch
int 21h

main endp

PRINT_NUM           PROC                        ;print ax
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

PRINT_NUM           ENDP
end main