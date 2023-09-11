.MODEL      SMALL
.STACK      100
.DATA

buffer          DB 32
                DB ?
                DB 32 DUP(0)
                DB "$"

anyKeyToCont    DB  "Press any key to continue!$"

bcdInputBuffer  DB  "$$$"

;++++++++++++++++++++++++++++++++++++++++++++++SALES SECTION++++++++++++++++++++++++++++++++++++++++++++++++++++
itemSelectionChoice DB  1

numberOfItems   DB  8
                       ;1        0         01           qty
items           DB  1, "Lemons$$$$$$$$$$$$$$1.20$$$$", 16
                DB  2, "Blueberries$$$$$$$$$4.99$$$$", 78
                DB  3, "Tea$$$$$$$$$$$$$$$$$14.99$$$", 45
                DB  4, "Brandy Apricot$$$$$$17.37$$$", 79
                DB  5, "Tomato Ravioli Soup$3.99$$$$" ,27
                DB  6, "Wasabi Paste$$$$$$$$18.21$$$", 63
                DB  7, "Cheese$$$$$$$$$$$$$$15.67$$$", 7
                DB  8, "Garlic$$$$$$$$$$$$$$3.08$$$$", 13
                DB  0

;ITEM SELECTION

itemSelHeader   DB  201d, 32 DUP (205d), "ITEM SELECTION", 32 DUP (205d), 187d
                DB  20  DUP(186d, 78 DUP(" "), 186d)
                DB  200d, 78 DUP (205d), 188d
                DB  "$"

itemHeader      DB  "ID", 10 DUP(" "), "Item Name", 15 DUP(" "), "Price", 8 DUP(" "), "Qty"
                DB  "$"

itemSelBorder   DB  192d ,52 DUP(196d), 217d
                DB  "$"

itemSaleRecord  DB  8 DUP(0)

itemExitString  DB  "0           FINISH SALE$"

;QTY SECTION
qtyDisplayBox   DB  01011111b
                DB   5, 20             ;row,column
                DB  8, 41

qtyBorder1      DB  201d, 1 DUP (205d), "QTY (1-999)", 7 DUP (205d), 187d,10d
                DB  "$"
qtyBorder2      DB  186d, 19 DUP (" "), 186d,10d
                DB  "$"
qtyBorder3      DB  200d, 19 DUP (205d), 188d
                DB  "$"

qtyPrompt       DB  "QTY: $"

qtyError        DB  "Invalid QTY$"

itemID      EQU     0
itemName    EQU     1
itemPrice   EQU     21
itemQty     EQU     29
itemSize    EQU     30

selColour   EQU     01001110b

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

COLOUR_CHAR MACRO character, colour, printNum
                push    ax
                push    bx
                push    cx
                push    dx

                xor     bx,bx

                mov cx, printNum         
                mov al, character        
                mov bl, colour       
                mov ah, 09h       
                int 10h

                pop    dx
                pop    cx
                pop    bx
                pop    ax
ENDM

BG_16_COLOUR    MACRO
                push    ax
                push    bx
                push    cx
                push    dx

                xor     ax,ax
                xor     bx,bx
                xor     cx,cx
                xor     dx,dx

                mov         ax, 1003h
                mov         bl, 0       ;enable 16 colours for background, disable text blink
                int         10h

                pop    dx
                pop    cx
                pop    bx
                pop    ax
ENDM

BG_8_COLOUR     MACRO
                push    ax
                push    bx
                push    cx
                push    dx

                xor     ax,ax
                xor     bx,bx
                xor     cx,cx
                xor     dx,dx

                mov         ax, 1003h
                mov         bl, 1       ;enable 8 colours for background, enable text blink
                int         10h

                pop    dx
                pop    cx
                pop    bx
                pop    ax
ENDM
.CODE

MAIN            PROC
                mov         ax  ,@DATA
                mov         ds  ,ax
                xor         ax  ,ax
                xor         bx  ,bx
                xor         cx  ,cx
                xor         dx  ,dx

    SALES_START:
                xor         bx, bx
                mov         [itemSelectionChoice], 1        ;reset selection

                call        cls
                CURSOR      0,0 

                lea         dx  ,itemSelHeader
                call        PRINT_STR

                CURSOR      2  ,3
                COLOUR_CHAR 0, 00011110b, 52d
                lea         dx  ,itemHeader
                call        PRINT_STR
                
                jmp         SALES_START_BREAK
                SALES_START_CP:
                            jmp         SALES_START
                SALES_START_BREAK:

                CURSOR      3  ,2
                lea         dx  ,itemSelBorder
                call        PRINT_STR

                call        PRINT_ALL_ITEMS
                
                call        ITEM_SELECTION          ;modify itemSelectionChoice
                            cmp         [itemSelectionChoice], 9        ;exit if 9(exit selection)
                            je          ITEM_SELECTION_EXIT

                            call        DISPLAY_QTY_BOX

                            ;;move qty input cursor
                            call        MOVE_CURSOR_QTY

                            ;item choice to al
                            xor         ax, ax
                            mov         al, [itemSelectionChoice]   ;item choice to al
                            dec         al                      

                            ;change di into the address of the sale record of the selected item
                            lea         di, itemSaleRecord          ;change address to the selected item
                            add         di, ax
                            ;change si to the address of the selected item
                            xor         bx, bx
                            mov         bl, itemSize
                            mul         bx                          ;item choice number * itemSize to get offset of the selected item
                            lea         si, items                   
                            add         si, ax                      ;item + offset

                            QTY_CHECK:
                                        xor         bx, bx
                                        call        BCD_INPUT                   ;store input into ax
                                        mov         bl, [si + itemQty]          ;quantity of selected item

                                        call        MOVE_CURSOR_QTY

                                        cmp         ax, bx                      ;if input is larger than qty of item
                                        ja          QTY_CHECK_ERROR
                                        jmp         QTY_CHECK_END
                                        QTY_CHECK_ERROR:
                                                    lea         dx, qtyError
                                                    call        PRINT_STR
                                                    jmp         SALES_START_CP
                            QTY_CHECK_END:

                            ;;write sold qty to sales record
                            mov         [di],   al

                            CURSOR      22,0
                            call        ANYPAUSE

                            jmp         SALES_START_CP
                ITEM_SELECTION_EXIT:
                
                call        cls
                CURSOR      0,0
                lea         si, itemSaleRecord
                mov         cx, 8d
                L1:
                            xor         ax,ax
                            mov         al,[si]
                            call        PRINT_NUM
                            call        NEWLINE
                            inc         si
                            loop        L1

                CURSOR      21,0
                mov         ah  ,4ch
                int         21h
MAIN            ENDP

MOVE_CURSOR_QTY PROC
                            push        bx

                            mov         bl, [qtyDisplayBox+1]   ;use bl to store row number
                            mov         bh, [qtyDisplayBox+2]   ;use bh to store column number
                            add         bl, 1
                            add         bh, 2
                            CURSOR      bl, bh

                            pop         bx
                            ret
MOVE_CURSOR_QTY ENDP

DISPLAY_QTY_BOX PROC
                            push        ax
                            push        bx
                            push        cx
                            push        dx

                            lea         si, qtyDisplayBox  
                            call        DISPLAY_BOX

                            mov         bl, [qtyDisplayBox+1]   ;use bl to store row number
                            CURSOR      bl, [qtyDisplayBox+2]
                            lea         dx, qtyBorder1
                            call        PRINT_STR

                            inc         bl                      ;next row
                            CURSOR      bl, [qtyDisplayBox+2]
                            lea         dx, qtyBorder2
                            call        PRINT_STR

                            inc         bl                      ;next row
                            CURSOR      bl, [qtyDisplayBox+2]
                            lea         dx, qtyBorder3
                            call        PRINT_STR

                            pop         dx
                            pop         cx
                            pop         bx
                            pop         ax
                            ret
DISPLAY_QTY_BOX ENDP

ITEM_SELECTION  PROC                                                        ;modify itemSelectionChoice
                            mov         bl  ,4
                            CURSOR      bl  ,3
                            COLOUR_CHAR 0, 01001110b, 51d

                            itemSelectionLoop:
                                    call        PRINT_ALL_ITEMS

                                    mov         dl, [itemSelectionChoice]

                                    mov         ah, 07h
                                    int         21h

                                    cmp         al, "w"
                                    je          itemSelectionUp
                                    
                                    cmp         al, "s"
                                    je          itemSelectionDown

                                    cmp         al, 13d
                                    je          itemSelectionConfirm_CP
                                    jmp         itemSelectionLoop

                                    itemSelectionLoop_CP:
                                                jmp         itemSelectionLoop

                                    itemSelectionUp:
                                                cmp         [itemSelectionChoice],  1
                                                jbe         itemSelectionLoop

                                                COLOUR_CHAR 0, 00001111b, 51d

                                                dec         dl
                                                mov         [itemSelectionChoice],  dl

                                                sub         bl  ,2
                                                CURSOR      bl  ,3

                                                COLOUR_CHAR 0, selColour, 51d
                                                jmp         itemSelectionLoop

                                    itemSelectionConfirm_CP:
                                                jmp         itemSelectionConfirm

                                    itemSelectionDown:   
                                                cmp         [itemSelectionChoice],  9
                                                jae         itemSelectionLoop_CP

                                                COLOUR_CHAR 0, 00001111b, 51d

                                                inc         dl
                                                mov         [itemSelectionChoice],  dl

                                                add         bl  ,2
                                                CURSOR      bl  ,3

                                                COLOUR_CHAR 0, selColour, 51d
                                                jmp         itemSelectionLoop_CP

                            itemSelectionConfirm:

                            ret
ITEM_SELECTION  ENDP

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

                            add         bl  ,2
                            CURSOR      bl  ,3
                            lea         dx  ,itemExitString
                            call        PRINT_STR

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
PRINT_ITEM      ENDP

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
PRINT_NUM       ENDP

BCD_INPUT       PROC                    ;output to al
                push        si

                lea         si, bcdInputBuffer

                mov         cx, 3d      ;max number of times to loop
                xor         dx, dx      ;dl as temp value counter

                ;;get bcd input
                BCD_INPUT_LOOP:
                            mov         ah, 1h
                            int         21h

                            cmp         al, 13d
                            je          BCD_INPUT_LOOP_END
                            
                            sub         al, 48d
                            mov         [si],al

                            inc         si
                            loop        BCD_INPUT_LOOP  
                BCD_INPUT_LOOP_END:

                mov         ax, 1                   ;ax tracks 位数 of number, eg first number * 1, second number * 10, third number *
                lea         si, bcdInputBuffer+2
                mov         cx, 3d                  ;number of times to loop
                BCD_INPUT_CAL:
                            xor         bx, bx

                            mov         bl, [si]
                            cmp         bl, "$"     ;if is not digit
                            je          BCD_INPUT_CAL_NOT_DIGIT

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

                            BCD_INPUT_CAL_NOT_DIGIT:
                            dec         si
                            loop        BCD_INPUT_CAL

                mov         cx, 3d
                lea         si, bcdInputBuffer
                BCD_INPUT_CLEAR_STR:
                            mov         [bcdInputBuffer],   "$" 
                            loop        BCD_INPUT_CLEAR_STR
                mov         ax, dx
                pop         si
                ret
BCD_INPUT       ENDP

;;DO NOT PUT NEW FUNCTIONS BELLOW THIS COMMENT

DISPLAY_BOX     PROC
                            push        ax
                            push        bx
                            push        cx
                            push        dx

                            ;;GET CURRENT CURSOR POS
                            mov         ah, 03h
                            mov         bl, 00h
                            int         10h                 ;cursor pos will be stored in dh dl
                            push        dx

                            mov     ah, [si + 2]
                            mov     al, [si + 4]
                            sub     al, ah           ;calculate number of columns to print
                            xor     ah, ah

                            mov     ch, [si + 1]
                            mov     cl, [si + 3]
                            sub     cl, ch
                            xor     ch, ch

                            mov     bl, [si + 1]

                            DISPLAY_BOX_LOOP:
                                    CURSOR  bl,[si+2]

                                    push    ax
                                    push    bx
                                    push    cx
                                    push    dx
                                    mov     cx, ax          ;number of chars to print
                                    mov     al, " "         ;char to print
                                    mov     bl, [si]        ;colour
                                    mov     ah, 09h         ;ah 09 int 10h
                                    int     10h
                                    pop     dx
                                    pop     cx
                                    pop     bx
                                    pop     ax
                                    
                                    inc     bl
                                    loop    DISPLAY_BOX_LOOP

                            pop         dx
                            CURSOR      dh,dl       ;set cursor back to original position

                            pop     dx
                            pop     cx
                            pop     bx
                            pop     ax

                            ret
DISPLAY_BOX     ENDP

PRINT_STR       PROC
                            push        ax
                            mov         ah,09d
                            int         21h
                            pop         ax
                            ret
PRINT_STR       ENDP

CLS             PROC
                            push    ax
                            push    bx
                            push    cx
                            push    dx

                            mov ah, 06h       ;
                            mov al, 00h       ;
                            mov bh, 0Fh       ;
                            mov cx, 0         ; Clear Screen
                            mov dh, 100       ;
                            mov dl, 80        ;
                            int 10h           ;

                            mov dx, 0         ;
                            mov bh, 0         ; Set cursor to (0,0)
                            mov ah, 02h       ; 
                            int 10h 

                            pop     dx
                            pop     cx
                            pop     bx
                            pop     ax

                            ret
CLS             ENDP

INPUT_STR       PROC                                        ;read input and move to address in di
                            push        ax
                            push        dx
                            push        di
                            xor         ax,ax
                            xor         cx,cx

                            mov         dx, offset buffer               ;input string
                            mov         ah,0Ah
                            int         21h

                            xor         cx,cx
                            mov         cl,[buffer+1]                   ;move length of input to cl

                            mov         ah, "$"
                            lea         di, buffer+2                     ;offset to start of string value
                            add         di, cx                           ;move to after last character
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

ANYPAUSE        PROC
                            push        ax
                            push        dx

                            lea         dx, anyKeyToCont
                            call        PRINT_STR
                            mov         ah, 01h
                            int         21h

                            pop         dx
                            pop         ax
                            ret
ANYPAUSE        ENDP

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

CHANGE_COLOUR   PROC
                            push        ax

                            xor         ax  ,ax
                            mov         ah  ,09h
                            int         10h

                            pop         ax
                            ret
CHANGE_COLOUR   ENDP

END MAIN