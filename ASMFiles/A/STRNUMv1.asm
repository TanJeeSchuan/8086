.MODEL COMPACT
.STACK 100
.DATA

strNum1             DB  "40257576"
                    DB  "$"

strNum2             DB  "00000005"
                    DB  "$"

maxStrLen           DB  ?

i                   DB  0
j                   DB  0
w                   DW  0
len                 DB  0
carry               DW  0
remainder           DB  0

normal1             DB  50  DUP("$")

normal2             DB  50  DUP("$")

result              DB  50  DUP("$")
                    DB  "$"

TEN                 DB  10d

.CODE
MAIN            PROC

mov ax,@data
mov ds,ax
mov ax,4c00h

; start

lea         dx,strNum1
call        PRINT_STR
call        NEWLINE

lea         dx,strNum2
call        PRINT_STR
call        NEWLINE
call        NEWLINE



lea         si,strNum1
lea         di,strNum2
call        MUL_STRNUM

; lea         di,result
; mov         ah,"U"
; mov         [di],ah

lea         dx,result
call        PRINT_STR

;end

mov ah,4ch
int 21h

MAIN            ENDP

ADD_STRNUM      PROC                                            ;output result to result
                        xor         ax,ax

                        ; ;remove decimals from si, di strings
                        ; push        di                      ;normalise si string
                        ; lea         di,normal1
                        ; call        NORMALISE_STR
                        ; mov         si,di
                        ; pop         di

                        ; push        si                      ;normalise di string
                        ; mov         si,di
                        ; lea         di,normal2
                        ; call        NORMALISE_STR
                        ; pop         si

                        ;get the length of the longer string
                        call        STRLEN                  ;length of si
                        push        ax                   

                        push        si          
                        mov         si,di
                        call        STRLEN                  ;length of di
                        pop         si

                        pop         bx
                        call        LARGER_NUM              ;larger number in ax,bx will be in ax
                        mov         cx,ax                   ;longest length of si and di will be in CX

                        ;offset si,di
                        add         si,cx                   ;move to last character
                        dec         si
                        add         di,cx
                        dec         di
                        
                        xor         bx,bx                   ;prepare bx for use as carry register
                        add_loop:
                                    mov         al,[si]     ;get int value of strin             ; *POINTER      lea offset &inte
                                    sub         al,48d
                                        
                                    mov         ah,[di]     ;get int value of string
                                    sub         ah,48d

                                    add         al,bl       ;add carry
                                    add         al,ah

                                    xor         bl,bl       ;reset carry flag

                                    cmp         al,9d       ;if al larger than 9, overflow, carry register bl set
                                    ja          add_overflow
                                    jmp         add_no_overflow

                                    add_overflow:
                                                sub         al,10d
                                                mov         bl,1d       ;set carry register
                                    
                                    add_no_overflow:
                                    mov         ah,0
                                    add         al, 48d

                                    mov         [si],al

                                    dec         si
                                    dec         di

                                    push        di          ;load into result

                                    lea         di,result   ;di is address of result
                                    add         di,cx       ;offset to cx + 1
                                    dec         di
                                    mov         [di],al     ;insert in di

                                    pop         di

                                    loop        add_loop
                        ret
ADD_STRNUM      ENDP

SUB_STRNUM      PROC                                            ;output result to result
                        ;get the length of the longer string
                        call        STRLEN                  ;length of si
                        push        ax                   

                        push        si          
                        mov         si,di
                        call        STRLEN                  ;length of di
                        pop         si

                        pop         bx
                        call        LARGER_NUM              ;larger number in ax,bx will be in ax
                        mov         cx,ax                   ;longest length of si and di will be in CX

                        ;offset si,di
                        add         si,cx                   ;move to last character
                        dec         si
                        add         di,cx
                        dec         di

                        xor         bx,bx

                        sub_loop:
                                    mov         al,[si]
                                    sub         al,48d

                                    mov         ah,[di]
                                    sub         ah,48d

                                    sub         al,bl
                                    xor         bl,bl
                                    sub         al,ah
                                    js          sub_underflow   ;if underflow
                                    jmp         sub_no_underflow

                                    sub_underflow:
                                                neg         al
                                                mov         ah,10d
                                                sub         ah,al
                                                mov         al,ah
                                                mov         bl,1         
                        sub_no_underflow:
                                    mov         ah,0
                                    add         al, 48d

                                    mov         [si],al

                                    dec         si
                                    dec         di

                                    push        di          ;load into result

                                    lea         di,result   ;di is address of result
                                    add         di,cx       ;offset to cx + 1
                                    dec         di
                                    mov         [di],al     ;insert in di

                                    pop         di

                                    loop        sub_loop 
                        ret
SUB_STRNUM      ENDP

MUL_STRNUM      PROC
                        ;get the length of the longer string
                        call        STRLEN                  ;length of si
                        push        ax                   

                        push        si          
                        mov         si,di
                        call        STRLEN                  ;length of di
                        pop         si

                        pop         bx
                        call        LARGER_NUM              ;larger number in ax,bx will be in ax
                        mov         cx,ax                   ;longest length of si and di will be in CX

                        sub         cl,1                    ;decrement 1 because array range is 0 - (strLen  - 1)

                        mov         [i],cl                   ;cl as i, ch as j, both begins at end of number
                        mov         [j],cl
                        mov         [len],cl
                        xor         ax,ax

                        ;avalible registers ax,bx,dx
                        mul_loop_j:
                                    xor         cx,cx

                                    ;get value from di where a(n), a(n-1)... a(0), where n is j     #reversed array order
                                    mov         cl,[j]
                                    push        di
                                    add         di,cl
                                    mov         al,[di]     ;al = di[cl]
                                    sub         al,48d

                                    mov         cl,[i]
                                    push        cx

                                    mov         [carry],0       ;remainder = 0, carry = 0
                                    mov         [remainder],0
                                    mul_loop_i:
                                                push        ax
                                                
                                                push        si
                                                mov         cl,[i]
                                                add         si,cl
                                                mov         ah,[si]     ;ah = di[cl]
                                                sub         ah,48d
                                                pop         si

                                                ;get number in result bl = w[i+j]
                                                push        di
                                                xor         bx,bx
                                                xor         cx,cx
                                                lea         di,result
                                                mov         cl,[i]
                                                add         cl,[j]
                                                ; add         cl,ch
                                                add         di,cl
                                                mov         bl,[di]
                                                pop         di

                                                cmp         bl,"$"
                                                je          mul_newchar
                                                jmp         mul_no_newchar

                                                mul_loop_i_checkpoint:
                                                            jmp         mul_loop_i
                                                mul_loop_j_checkpoint:
                                                            jmp         mul_loop_j
                    
                                                mul_newchar:
                                                            mov         bl,"0"
                                                mul_no_newchar:
                                                sub         bl,48d
                                                mov         [w],bl
                                                ;;get result part end

                                                ;;ah = num1
                                                ;;al = num2
                                                mul         ah          ;t  = ah*al
                                                add         ax,[w]      ;t += w[i+j]
                                                add         ax,[carry]  ;t += carry

                                                div         ten

                                                mov         [carry],al
                                                mov         [remainder],ah

                                                push        di
                                                xor         bx,bx
                                                xor         cx,cx
                                                lea         di,result
                                                mov         cl,[i]
                                                add         cl,[j]
                                                ; add         cl,ch
                                                add         di,cl
                                                mov         bl,[remainder]
                                                add         bl,48d
                                                mov         [di],bl
                                                pop         di

                                                pop         ax
                                                ;decrement i, loop until i < 0
                                                mov         cl,[i]
                                                dec         cl
                                                mov         [i],cl

                                                cmp         cl,-1
                                                jg          mul_loop_i_checkpoint

                                    push        di
                                    xor         bx,bx
                                    xor         cx,cx
                                    lea         di,result
                                    mov         cl,[i]
                                    add         cl,[j]
                                    ; add         cl,ch
                                    add         di,cl
                                    mov         bl,[carry]
                                    add         bl,48d
                                    mov         [di],bl
                                    pop         di


                                    pop         cx
                                    mov         [i],cl

                                    pop         di
                                    ;decrement j, loop until j < 0
                                    mov         cl,[j]
                                    dec         cl
                                    mov         [j],cl

                                    cmp         cl,-1
                                    jg          mul_loop_j_checkpoint
                        ret
MUL_STRNUM      ENDP

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

NORMALISE_STR   PROC                                        ;output string number without decimal point from si to di
                        push        si
                        push        di
                        xor         ax,ax       ;al contains character
                        normLoop:
                                    mov     al  ,[si]
                                    
                                    cmp     al,"$"          ;if is string end
                                    je      normLoopEnd

                                    cmp     al,"."
                                    je      normRemoveDec   ;if is decimal point
                                    jmp     normRemoveDecEnd

                                    normRemoveDec:
                                            inc         si
                                            mov         al,[si]
                                    normRemoveDecEnd:

                                    mov     [di],al

                                    inc     si
                                    inc     di
                                    
                                    jmp      normLoop
                        normLoopEnd:
                        pop         di
                        pop         si
                        ret
NORMALISE_STR   ENDP

PRINT_STR       PROC                                        ;print value from address in dx
                        push        ax
                        mov         ah,09h      
                        int 21h
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

LARGER_NUM      PROC                                        ;compare ax,bx, large number will be AX
                        cmp     ax,bx
                        jb      AX_SMALLER                   ;if ax is smaller than bx
                        jmp     AX_SMALLER_END               

                        AX_SMALLER:
                                    mov     ax,bx

                        AX_SMALLER_END:
                        ret
LARGER_NUM      ENDP

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

PRINT_RESULT    PROC
                            push        cx
                            push        dx
                            push        di
                            mov         cx,20d
                            lea         di,result
                            loopF:
                                        xor dx,dx
                                        mov dl,[di]
                                        call    PRINT_CHAR
                                        inc di
                                        loop loopF
                            pop         di
                            pop         dx
                            pop         cx

                            ret
PRINT_RESULT    ENDP

DEBUG_CHAR      PROC
                            push        dx
                            
                            call        NEWLINE
                            mov         dl,"T"
                            call        PRINT_CHAR
                            call        NEWLINE

                            pop         dx
                            ret
DEBUG_CHAR      ENDP

END MAIN