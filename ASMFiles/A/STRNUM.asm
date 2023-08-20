.MODEL COMPACT
.STACK 100
.DATA

strNum1             DB  "40257576"
                    DB  "$"

strNum2             DB  "22832525"
                    DB  "$"

maxStrLen           DB  ?

normal1             DB  50  DUP("$")

normal2             DB  50  DUP("$")

result              DB  50  DUP("$")

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

                        ; ;offset si,di
                        ; add         si,cx                   ;move to last character
                        dec         si
                        ; add         di,cx
                        dec         di

                        mov         bx,cx                   ;cx as i, bx as j, both begins at end of number
                        mov         [maxStrLen],cl
                        xor         ax,ax
                        mul_loop_j:                         ;multiply numbers for j = n; j > 0; j--;; i = n; i > 0; i--
                                                            ;anchor al
                                    push        di
                                    add         di,bx       ;di[bx]
                                    mov         al,[di]     ;load number from second number to al
                                    sub         al,48d
                                    pop         di

                                    push        cx

                                    xor         dx,dx
                                    mul_loop_i:
                                                push        si
                                                add         si,cx               ;si[cx]
                                                mov         ah,[si]             ;load first number from si to ah
                                                sub         ah,48d
                                                pop         si

                                                push        ax
                                                mul         ah                  ;al x ah result will be in ax
                                                add         ax,dx               ;add carry to multiplication result
                                                xor         dx,dx

                                                ; push        ax
                                                ; mov         ah,0
                                                ; call        PRINT_NUM
                                                ; call        NEWLINE
                                                ; pop         ax

                                                cmp         ax,9d               ;if ax is more than 9, overflow
                                                ja          mul_overflow        
                                                jmp         mul_no_overflow

                                                mul_overflow:
                                                            push        bx
                                                            mov         bx,10d  ;divide ax by 10

                                                            div         bx      ;quotient ax will be the carry, remainder will be the current number

                                                            pop         bx
                                                            push        dx      ;exchange value of ax,dx
                                                            mov         dx,ax   
                                                            pop         ax      ;resulting value will be in lower register

                                                mul_no_overflow:
                                                ;store output in result
                                                push        di
                                                lea         di,result

                                                push        cx                  ;set offset max-i + max-j to result address
                                                push        bx
                                                xor         bx,bx
                                                mov         bl,[maxStrLen]
                                                sub         bl,cl
                                                add         di,bx
                                                pop         bx
                                                pop         cx

                                                push        cx                  
                                                push        bx
                                                xor         cx,cx
                                                mov         cl,[maxStrLen]      
                                                sub         cl,bl
                                                add         di,cl
                                                pop         bx
                                                pop         cx

                                                mov         ah,[di]
                                                cmp         ah,"$"          ;if character is $ set it to zero
                                                je          mul_set_zero
                                                jmp         mul_no_set_zero

                                                mul_set_zero:
                                                            mov         ah  ,"0"

                                                mul_no_set_zero:
                                                sub         ah,48d
                                                add         al,ah           ;add to previous value in value of result[i+j]

                                                cmp         al,9d               ;if al is more than 9, overflow
                                                ja          mul_overflow2
                                                jmp         mul_no_overflow2

                                                ;i loop checkpoint
                                                mul_loop_i_checkpoint:
                                                jmp         mul_loop_i

                                                ;j loop checkpoint
                                                mul_loop_j_checkpoint:
                                                jmp         mul_loop_j

                                                mul_overflow2:
                                                            sub         al,10d

                                                            inc         di
                                                            push        ax

                                                            mov         ah,[di]
                                                            cmp         ah,"$"      ;if new digit does not exist yet
                                                            je          mul_overflow2_new
                                                            jmp         mul_overflow2_no_new

                                                            mul_overflow2_new:
                                                                        mov     ah,"1"
                                                                        mov     [di],ah     ;move to next digit, dont add

                                                            call        PRINT_RESULT
                                                            call        NEWLINE

                                                                        jmp     mul_overflow2_new_end

                                                            mul_overflow2_no_new:
                                                                        add     ah,1
                                                                        mov     [di],ah
                                                                        jmp     mul_overflow2_new_end

                                                            mul_overflow2_new_end:

                                                            dec         di
                                                            pop         ax

                                                mul_no_overflow2:
                                                add         al,48d
                                                mov         [di],al

                                                xor         ah,ah

                                                cmp         cx,1
                                                je          last_loop
                                                jmp         not_last_loop
                                                
                                                last_loop:
                                                            inc         di
                                                            add         dl,48d
                                                            mov         [di],dl         ;move last remainder to largest place 
                                                            sub         dl,48d
                                                            dec         di

                                                not_last_loop:

                                                pop         di
                                                pop         ax
                                                loop        mul_loop_i_checkpoint                  ;use cx(i) to loop

                                    pop         cx

                                    dec         bx
                                    cmp         bx,0
                                    ja          mul_loop_j_checkpoint
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

END MAIN