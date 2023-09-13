.model small
.stack
.data

strNumLen                   EQU 8      ;length of strNum
mulResultLen                EQU 20

remainder                   DB  0
carry                       DB  0

mulResult                   DB  mulResultLen DUP("0"), "$"
mulX                        DB  ?
mulY                        DB  ?
mulI                        DB  0
mulJ                        DB  0
;;;;;;;;;

numberOfItems               DB  8
                                    ;1        0         01           qty
items                       DB  1, "Lemons$$$$$$$$$$$$$$1.20$$$$", 16
                            DB  2, "Blueberries$$$$$$$$$4.99$$$$", 78
                            DB  3, "Tea$$$$$$$$$$$$$$$$$14.99$$$", 40
                            DB  4, "Brandy Apricot$$$$$$17.37$$$", 29
                            DB  5, "Tomato Ravioli Soup$3.99$$$$", 27
                            DB  6, "Wasabi Paste$$$$$$$$18.21$$$", 28
                            DB  7, "Cheese$$$$$$$$$$$$$$15.67$$$", 7
                            DB  8, "Garlic$$$$$$$$$$$$$$3.08$$$$", 13
                            DB  0

itemSaleRecord              DB  6,  77,  15,  9,  0,  0,  0,  1 

itemSubTotals               DW  0,  0,   0,   0,  0,  0,  0,  0

itemSubTotalsString         DB  8 DUP(strNumLen DUP("0"), "$")

result                      DB  strNumLen  DUP("0"), "$"

subtotal                    DB  8 DUP(48d)
                            DB  "$"

totalPrice                  DB  mulResultLen DUP("0"), "$"

;;;3 decimal places
testVal                     DB  "00123550$"

sstRate                     DB  "00000060$"         ;;sst rate 0.060

quantity                    DB  0

itemID                      EQU 0
itemName                    EQU 1
itemPrice                   EQU 21
itemQty                     EQU 29
itemSize                    EQU 30

STRLEN          MACRO   inputStr        ;return string length in ax
                lea     si, inputStr

                xor     cx, cx
                STRLEN_LOOP:
                        mov     al, [si]
                        inc     si

                        inc     cx
                        cmp     al, "$"
                        jne     STRLEN_LOOP

                dec     cx
                mov     ax, cx
ENDM
STRSHL          MACRO   inputStr        ;shift characters of string to the left one char

                STRLEN  inputStr        ;string length in ax
                mov     cx, ax

                lea     si, inputStr
                inc     si
                STRSHL_LOOP:
                        mov     al, [si]
                        dec     si
                        mov     [si],al

                        add     si, 2
                        loop    STRSHL_LOOP

                dec     si
                mov     al,"$"
                mov     [si],al

                dec     si
                mov     al, "0"
                mov     [si],al
ENDM
STRCPY          MACRO   dest,   source
                lea     si, source
                lea     di, dest

                STRCPY_L:
                        mov     al, [si]
                        mov     [di],al

                        inc     si
                        inc     di

                        cmp     al, "$"
                        jne     STRCPY_L
ENDM
CLEAR_STRNUM    MACRO   inputStr
                xor     cx, cx
                mov     cl, [strNumLen]

                lea     si, inputStr
                add     si, cx
                dec     si

                CLEAR_STRNUM_L:
                        mov     al, "0"
                        mov     [si],al
                        dec     si
                        loop    CLEAR_STRNUM_L
ENDM
NUM_TO_STR_M    MACRO   value, destAddress
                push    ax
                push    si

                mov     ax, value
                lea     si, destAddress
                call    NUM_TO_STR

                pop     si
                pop     ax
ENDM
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
MAIN                PROC
                    mov         ax, @data
                    mov         ds, ax
                    xor         ax, ax
    
                    call        CALC_SUBTOTAL           ;multiples item price with  qty in itemSaleRecord and output in itemSubTotals
    
                    call        SUBTOTALS_TO_STR        ;convert itemSubTotals to string number. Output to itemSubTotalsString
    
                    call        SUM_SUBTOTALS           ;sum all the item subtotals in itemSubTotalsString, output in result
    
                    STRCPY      subtotal,   result
                    STRSHL      subtotal                ;shift string left, replace empty slot with "0", to prepare for rounding issues

                    lea         si, subtotal
                    lea         di, sstRate
                    call        STRNUM_MUL

                    STRCPY      totalPrice,  mulResult

                    lea         dx, totalPrice
                    call        PRINT_STR
                
                    mov ah, 4ch
                    int 21h      
MAIN                ENDP  

STRNUM_ADD          PROC                            ;string si + string di
                        push    ax
                        push    bx
                        push    cx
                        push    dx
                        push    si
                        push    di

                        mov     [remainder], 0

                        mov     cx, strNumLen
                        dec     cx
                        add     si, cx          ;offset to last char
                        add     di, cx

                        mov     cx, strNumLen

                        STRNUM_ADD_LOOP:
                                mov     al, [si]
                                sub     al, 48d

                                mov     ah, [di]
                                sub     ah, 48d

                                add     al, ah
                                add     al, [remainder]
                                xor     ah, ah

                                mov     bx, 10d
                                div     bl              ;remainder in ah, quotient in al 

                                mov     [remainder],al  ;save quotient

                                push    cx
                                push    di
                                
                                dec     cx
                                lea     di,     result
                                add     di,     cx

                                add     ah,     48d
                                mov     [di],   ah

                                pop     di
                                pop     cx

                                dec     si
                                dec     di
                                loop    STRNUM_ADD_LOOP

                        pop     di
                        pop     si
                        pop     dx
                        pop     cx
                        pop     bx
                        pop     ax

                        ret
STRNUM_ADD          ENDP

STRNUM_MUL          PROC                            ;multiply si, di strings, assume string has 3 decimal places, thus last 3 digits throw away
                        mov     [carry]     ,0
                        mov     [mulI]      ,0
                        mov     [mulJ]      ,0

                        mov     cx, strNumLen
                        dec     cx

                        add     si, cx          ;offset to last char
                        add     di, cx

                        mov     cx, strNumLen

                        STRNUM_MUL_L1:
                                mov     al, [di]
                                sub     al, 48d
                                mov     [mulY],al

                                mov     [mulI], 0
                                push    cx

                                push    si
                                mov     cx, strNumLen
                                
                                STRNUM_MUL_L2:
                                    
                                        push    cx
                                        xor     ax, ax
                                        mov     al, [si]
                                        sub     al, 48d

                                        xor     bx, bx
                                        mov     bl, [mulY]
                                        mul     bx                  ;ax = ui + vj

                                        call    GET_IJ

                                        push    si
                                        lea     si, mulResult
                                        add     si, dx              ;OFFSET to w(i+j) result. n-1, n-2, ..., 0 (reverse order, index ends with 0)

                                        xor     bx, bx
                                        mov     bl, [si]            ;w(i+j)
                                        sub     bl, 48d                                        

                                        add     ax, bx              ;ax = ui + vj + w(i+j)

                                        xor     bx, bx
                                        mov     bl, [carry]
                                        add     ax, bx              ;ax = ui + vj + w(i+j) + k

                                        xor     dx, dx
                                        mov     bx, 10d
                                        div     bx                  ;dx = ax Mod 10, ax = FLOOR(ax/b)

                                        add     dl,     48d
                                        mov     [si],   dl          ;w(i+j) = ax Mod 10

                                        mov     [carry], al         ;k = FLOOR(ax/b)
                                        pop     si

                                        ; call    DEBUG

                                        inc     [mulI]

                                        dec     si

                                        pop     cx
                                        loop    STRNUM_MUL_L2

                                pop     si

                                call    GET_IJ
                                push    si
                                lea     si, mulResult
                                add     si, dx              ;OFFSET to w(i+j) result. n-1, n-2, ..., 0 (reverse order, index ends with 0)

                                mov     al, [carry]
                                add     al, 48d
                                mov     [si],   al

                                pop     si
                                
                                inc     [mulJ]
                                dec     di

                                pop     cx
                                loop    STRNUM_MUL_L1
                        ret
STRNUM_MUL          ENDP

DEBUG               PROC
                                        mov     dl, [mulI]
                                        add     dl, 48d
                                        call    PRINT_CHAR

                                        mov     dl, " "
                                        call    PRINT_CHAR

                                        mov     dl, [mulJ]
                                        add     dl, 48d
                                        call    PRINT_CHAR

                                        mov     dl, " "
                                        call    PRINT_CHAR

                                        lea     dx, mulResult
                                        call    PRINT_STR

                                        mov     dl, " "
                                        call    PRINT_CHAR
                                        call    PRINT_CHAR

                                        call    GET_IJ
                                        mov     ax, dx
                                        ; add     dx, 48d
                                        call    PRINT_NUM

                                        mov     ah, 01h
                                        int     21h
                                        ret
DEBUG               ENDP

GET_IJ              PROC                                        ;return i+j in dx
                                mov     dh, [mulI]             ;i+j
                                mov     dl, [mulJ]
                                add     dh, dl

                                mov     dl, mulResultLen    ;get the length of result string
                                dec     dl
                                sub     dl, dh               ;(i+j) offset from result string
                                xor     dh, dh

                                ret
GET_IJ              ENDP

SUM_SUBTOTALS       PROC
                        xor         di, di
                        xor         cx, cx
                        mov         cl, [numberOfItems]
                        sumAllSubtotals:
                                    push        cx

                                    dec         cx
                                    mov         ax, strNumLen
                                    inc         ax
                                    mul         cx              ;index to next strNum
                                    mov         di, ax

                                    pop         cx

                                    lea         si, result
                                    lea         di, itemSubTotalsString[di]
                                    call        STRNUM_ADD

                                    loop        sumAllSubtotals

                        ret
SUM_SUBTOTALS       ENDP

SUBTOTALS_TO_STR    PROC
                        xor         si, si              ;index for itemSubTotals
                        xor         di, di              ;index for itemSubTotalsString
                        xor         cx, cx
                        mov         cl, [numberOfItems]
                        itemSubTotals_To_String:
                                    push        cx
                                    dec         cx

                                    mov         ax, 2
                                    mul         cx
                                    mov         si, ax              ;index for itemSubtotals ;;; address + 2*cx

                                    mov         ax, strNumLen       
                                    inc         ax
                                    mul         cx
                                    mov         di, ax              ;index for itemSubTotalsString ;;; addresss + stringLength*cx

                                    pop         cx

                                    NUM_TO_STR_M    itemSubTotals[si], itemSubTotalsString[di]

                                    loop        itemSubTotals_To_String
                    ret
SUBTOTALS_TO_STR    ENDP

CALC_SUBTOTAL       PROC
                        xor     cx, cx
                        mov     cl, [numberOfItems]
                        calculateSubTotalLoop:
                                lea     si, items + itemPrice
                                lea     di, itemSaleRecord

                                push    cx
                                dec     cx
                                mov     ax, itemSize            ;offset to previous item cx*itemSize
                                mul     cx
                                add     si, ax
                                add     di, cx
                                pop     cx

                                call    GET_ITEM_PRICE    

                                mov     ax, dx
                                xor     dx, dx
                                mov     dl, [di]                ;get sold qty

                                mul     dx                      ;calculate SaleQty*Price

                                push    ax
                                mov     bx, 2
                                mov     ax, cx
                                dec     ax
                                mul     bx
                                mov     di, ax
                                pop     ax
                                mov     itemSubTotals[di], ax

                                loop    calculateSubTotalLoop

                        ret
CALC_SUBTOTAL   ENDP

NUM_TO_STR          PROC        ;value in ax to si
                        push    ax
                        push    bx
                        push    cx
                        push    dx
                        push    si

                        add     si, strNumLen           ;offset to last char of string number
                        dec     si

                        xor     cx, cx
                        mov     bx, 10d                 ;/10

                        NUM_TO_STR_DIV_LOOP:
                                xor     dx, dx          ;clear remainder

                                div     bx

                                add     dl, 48d
                                mov     [si],   dl
                                dec     si
                                
                                cmp     ax, 0
                                jnz     NUM_TO_STR_DIV_LOOP

                        pop    si
                        pop    dx
                        pop    cx
                        pop    bx
                        pop    ax

                        ret
NUM_TO_STR      ENDP

GET_ITEM_PRICE      PROC                            ;output price from item in si into dx
                push    cx
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
                pop     cx
                ret
GET_ITEM_PRICE  ENDP

PRINT_ALL_ITEMS     PROC
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

PRINT_ITEM          PROC                                                        ;print to row value in bl
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

PRINT_STR           PROC
                            push        ax
                            mov         ah,09d
                            int         21h
                            pop         ax
                            ret
PRINT_STR       ENDP   

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

                            pop    dx
                            pop    cx
                            pop    bx
                            pop    ax

                            ret
PRINT_NUM           ENDP

NEWLINE             PROC
                            push    dx
                            mov     dl,0Ah
                            call PRINT_CHAR
                            pop     dx
                            ret
NEWLINE         ENDP

PRINT_CHAR          PROC                                        ;print cjaracter of value in dl
                            push    ax
                            mov     ah,02h
                            int     21h
                            pop     ax
                            ret
PRINT_CHAR      ENDP


END                 MAIN