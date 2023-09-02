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

loginChances    DB 5

logo            DB "				ABC$"

;ORDER SYSTEM
itemHeader      DB "Item ID"
                DB 09h
                DB 09h
                DB "Product Name"
                DB 09h
                DB "Price"
                DB "$"

item            DB 1                        
                DB "APPLE$-------------"               
                DB "1.20$-----"              

                DB 2       
                DB "BANANA$------------" 
                DB "5.50$-----"

                DB 3       
                DB "DURIAN$------------" 
                DB "25.79$----"

                DB 4       
                DB "RAMBUTN$-----------"
                DB "4.00$-----"

                DB 5       
                DB "PEACH$-------------" 
                DB "10.00$----"    

                DB 6       
                DB "PEAR$--------------" 
                DB "15.00$----"

                DB "$"

itemSelection   DB "Select the item: $"

wrongItemSelection DB "Wrong item selection!"

;;offsets for item "array"
itemSize    EQU     30
id          EQU     0
itemName    EQU     1
itemPrice   EQU     20

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
            call        STRCMP                              ;will return 0 if string matches  

            cmp         ax,0
            jz          pass_correct                        ;jump if password is correct
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
exit:
            mov ah,4ch
            int 21h

pass_correct:
            call        NEWLINE
            lea         dx,pwCorrect
            call        PRINT_STR
pass_check_end:

call        NEWLINE
call        NEWLINE

lea         dx,itemHeader
call        PRINT_STR

call        NEWLINE

;print all items
xor         ax,ax
xor         cx,cx
xor         di,di

lea         si,item                             ;address of item array
print_item_loop: 
            mov         al,[si]                 ;move id in si to al
            cmp         al,"$"                  ;if is end of array, exit loop
            je          print_item_loop_exit    

            call        PRINT_NUM               ;print id
            
            push        ax
            push        dx
            mov         ah,02h
            mov         dl,9d
            int         21h                     ;print 2 of tabs
            int         21h
            pop         dx
            pop         ax

            push        si
            add         si,itemName             ;offset si to address of itemName
            mov         dx,si
            call        PRINT_STR               ;print string in SI
            pop         si

            push        ax
            push        dx
            mov         ah,02h
            mov         dl,9d
            int         21h                     ;print 2 of tabs
            int         21h
            pop         dx
            pop         ax


            push        si
            add         si,itemPrice            ;offset si to address of itemPrice
            mov         dx,si
            call        PRINT_STR               ;print string in SI
            pop         si

            call        NEWLINE

            add         si,itemSize             ;increment si by the size of a item element

            jmp         print_item_loop
print_item_loop_exit:

;input and validation
ITEM_SELECTION_INPUT:
            call        NEWLINE
            lea         dx,itemSelection
            call        PRINT_STR
            mov         ah,01h
            int         21h

            cmp         al,"1"
            jb          WRONG_ITEM_SELECTION_INPUT
            cmp         al,"6"
            ja          WRONG_ITEM_SELECTION_INPUT

            call        NEWLINE

            jmp         CORRECT_ITEM_SELECTION_INPUT

            WRONG_ITEM_SELECTION_INPUT:
                        call        NEWLINE
                        lea         dx,wrongItemSelection
                        call        PRINT_STR
                        call        NEWLINE
                        jmp         ITEM_SELECTION_INPUT

CORRECT_ITEM_SELECTION_INPUT:



;end
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

; PRINT_TABS      PROC                                        ;print number of spaces in cx
;                             push    ax
;                             push    cx
;                             push    dx

;                             PRINT_SPACES_LOOP:
;                                     mov     dl,09d
;                                     mov     ah,02h
;                                     int     21h
;                                     loop    PRINT_SPACES_LOOP

;                             pop     dx
;                             pop     cx
;                             pop     ax
;                             ret
; PRINT_TABS      ENDP


END MAIN