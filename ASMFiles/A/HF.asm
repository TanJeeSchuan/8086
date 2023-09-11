.model small
.stack
.data

numberOfItems   DB  8
            ;1        0         01           qty
items   DB  1, "Lemons$$$$$$$$$$$$$$1.20$$$$", 16
items2  DB  2, "Blueberries$$$$$$$$$4.99$$$$", 78
items3  DB  3, "Tea$$$$$$$$$$$$$$$$$14.99$$$", 45
items4  DB  4, "Brandy Apricot$$$$$$17.37$$$", 79
items5  DB  5, "Tomato Ravioli Soup$3.99$$$$", 27
items6  DB  6, "Wasabi Paste$$$$$$$$18.21$$$", 63
items7  DB  7, "Cheese$$$$$$$$$$$$$$15.67$$$", 7
items8  DB  8, "Garlic$$$$$$$$$$$$$$3.08$$$$", 13
        DB  0

itemSaleRecord  DB  6,  77,  15,  9,  0,  0,  0,  0 
quantity    db  0


itemID      EQU     0
itemName    EQU     1
itemPrice   EQU     21
itemQty     EQU     29
itemSize    EQU     30

CURSOR MACRO row,column
                push    ax
                push    bx
                push    cx
                push    dx

                ;set cursor
                mov dh, row        ;row
                mov dl, column       ;column
                mov bh, 0         ;
                mov ah, 02h       ; 
                int 10h

                pop    dx
                pop    cx
                pop    bx
                pop    ax
ENDM  

.code
main    proc
		mov     ax, @data
		mov     ds, ax

        lea     si, items + itemSIze*0 +itemPrice
        call    GET_ITEM_PRICE
                          
        mov ax,dx
        call    PRINT_NUM
              
        mov ah, 4ch
        int 21h      
    MAIN ENDP  

GET_ITEM_PRICE  PROC                            ;output price from item in si into dx
                push    si
                xor     ax, ax
                xor     bx, bx
                xor     cx, cx
                xor     dx, dx

                mov     cx, 0                   ;cx as number counter
 
                dec     si       
                PRICE_BCD_CONV_LOOP:
                        inc     si
                        mov     al, [si]
                        cmp     al, "$"
                        je      PRICE_BCD_CONV_CALC
                        
                        cmp     al, "."
                        je      PRICE_BCD_CONV_LOOP
                        
                        inc     cx              ;record number of digits
                        jmp     PRICE_BCD_CONV_LOOP                   
                                            
                        PRICE_BCD_CONV_CALC:
                                mov         ax, 0001h                   ;ax tracks place of number, eg first number * 1, second number * 10, third number *
                                dec         si
                                
                                BCD_INPUT_CAL:
                                xor         bx, bx

                                mov         bl, [si]
                                cmp         bl, "$"     ;if is not digit
                                je          BCD_INPUT_CAL_NOT_DIGIT  
                                
                                cmp         bl, "."     ;if is not digit
                                je          BCD_INPUT_CAL_NOT_DIGIT
                                
                                sub         bl, 48d


                                push        ax              

                                push        dx                  ;mul will effect dx
                                mul         bx
                                pop         dx

                                add         dx, ax
                                pop         ax

                                push        dx                  ;mul will effect dx
                                mov         bx, 10d
                                mul         bx
                                pop         dx

                                dec         si
                                loop        BCD_INPUT_CAL               
                                
                                jmp         BCD_INPUT_CAL_NOT_DIGIT_END 
                                BCD_INPUT_CAL_NOT_DIGIT:
                                            dec         si
                                            jmp         BCD_INPUT_CAL
                                BCD_INPUT_CAL_NOT_DIGIT_END:    
                pop     si
                ret
GET_ITEM_PRICE  ENDP

PRINT_ALL_ITEMS PROC
                            push        ax
                            push        bx
                            push        cx
                            push        dx

                            ;;GET CURRENT CURSOR POS
                            mov         ah, 03h
                            mov         bl, 00h
                            int         10h                 ;cursor pos will be stored in dh dl
                            push        dx

                            xor         cx  ,cx
                            mov         cl  ,[numberOfItems]
                            mov         bl  ,2
                            lea         si  ,items
                            print_item_loop:
                                        add         bl  ,2
                                        CURSOR      bl  ,3

                                        call        PRINT_ITEM
                                        add         si  ,itemSize

                                        loop        print_item_loop

;                            add         bl  ,2
;                            CURSOR      bl  ,3
;                            lea         dx  ,itemExitString
;                            call        PRINT_STR

                            pop         dx
                            CURSOR      dh,dl       ;set cursor back to original position

                            pop         dx
                            pop         cx
                            pop         bx
                            pop         ax
                            ret
PRINT_ALL_ITEMS ENDP

PRINT_ITEM      PROC                                                        ;print to row value in bl
                            push    ax
                            push    bx
                            push    cx
                            push    dx
                            push    si

                            xor         ax, ax
                            mov         al, [si]
                            call        PRINT_NUM

                            CURSOR      bl, 15
                            lea         dx, [si + itemName]
                            call        PRINT_STR

                            CURSOR      bl, 39
                            lea         dx, [si + itemPrice]
                            call        PRINT_STR

                            CURSOR      bl, 52
                            mov         al, [si + itemQty]
                            call        print_Num

                            

                            pop     si
                            pop     dx
                            pop     cx
                            pop     bx
                            pop     ax
                            ret
PRINT_ITEM  ENDP    

PRINT_STR       PROC
                            push        ax
                            mov         ah,09d
                            int         21h
                            pop         ax
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

                            pop    dx
                            pop    cx
                            pop    bx
                            pop    ax

                            ret
PRINT_NUM           ENDP

END                 MAIN