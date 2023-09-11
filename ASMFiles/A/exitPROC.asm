.MODEL      SMALL
.STACK      100
.DATA

buffer          DB 32
                DB ?
                DB 32 DUP(0)
                DB "$"

anyKeyToCont    DB  "Press any key to continue!$"

;++++++++++++++++++++++++++++++++++++++++++++++EXIT SECTION++++++++++++++++++++++++++++++++++++++++++++++++++++

confirmExit     DB  "EXIT POS SYSTEM ?$"

yesStr          DB  "[ Y E S ]$"

noStr           DB  "[ N O ]$"

exitSel         DB  1

exitBox         DB  00000000b   ;colour  
                DB  7   ,12         ;first corner (row, column)
                DB  19  ,64       ;second corner

exitBox1        DB  10001111b   ;colour  
                DB  4    ,8         ;first corner (row, column)
                DB  18   ,60      ;second corner

exitBox2        DB  11111111b   ;colour  
                DB  4    ,8         ;first corner (row, column)
                DB  17   ,58      ;second corner

exitBox3        DB  01110000b   ;colour  
                DB  5    ,10         ;first corner (row, column)
                DB  17   ,58      ;second corner

yesPos          DB  14  ,16
noPos           DB  14  ,42

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

                xor     ax,ax
                xor     bx,bx
                xor     cx,cx
                xor     dx,dx

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

                call        cls

                CURSOR      0,0             ;change BG colour
                xor         bx  ,bx
                mov         bl  ,00011111b
                mov         cx  ,1000h
                call        CHANGE_COLOUR

                lea         si, exitBox
                call        DISPLAY_BOX

                BG_16_COLOUR

                lea         si, exitBox1
                call        DISPLAY_BOX

                lea         si, exitBox2
                call        DISPLAY_BOX

                lea         si, exitBox3
                call        DISPLAY_BOX

                CURSOR      4,  58
                COLOUR_CHAR 0,  01111111b,  2

                CURSOR      17,  8
                COLOUR_CHAR 0,  01111111b,  2

                CURSOR      7,25
                lea         dx, confirmExit
                call        PRINT_STR

                CURSOR      [yesPos],[yesPos+1]
                lea         dx, yesStr
                call        PRINT_STR

                CURSOR      [noPos],[noPos+1]
                lea         dx, noStr
                call        PRINT_STR

                CURSOR      7,10
                exitSelectionLoop:
                            mov         ah, 07h
                            int         21h



                            cmp         al, "a"
                            je          exitSelectionLeft

                            cmp         al, "d"
                            je          exitSelectionRight

                            cmp         al  ,13d
                            jne         exitSelectionLoop
                            jmp         exitSelectionLoopExit

                            exitSelectionLeft:
                                        mov         [exitSel] , 1

                                        CURSOR      [yesPos],[yesPos+1]
                                        mov         bl  ,00001111b
                                        mov         cx  ,9
                                        call        CHANGE_COLOUR

                                        lea         dx, yesStr
                                        call        PRINT_STR

                                        CURSOR      [noPos],[noPos+1]
                                        mov         bl  ,01110000b
                                        mov         cx  ,7
                                        call        CHANGE_COLOUR

                                        lea         dx, noStr
                                        call        PRINT_STR

                                        jmp         exitSelectionLoop

                            exitSelectionRight:
                                        mov         [exitSel] , 2

                                        CURSOR      [noPos],[noPos+1]
                                        mov         bl  ,00001111b
                                        mov         cx  ,7
                                        call        CHANGE_COLOUR

                                        lea         dx, noStr
                                        call        PRINT_STR

                                        CURSOR      [yesPos],[yesPos+1]
                                        mov         bl  ,01110000b
                                        mov         cx  ,9
                                        call        CHANGE_COLOUR

                                        lea         dx, yesStr
                                        call        PRINT_STR

                                        jmp         exitSelectionLoop
                exitSelectionLoopExit:

                CURSOR      20,0
                mov         ah  ,4ch
                int         21h
MAIN            ENDP

DISPLAY_BOX     PROC
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

                            ret
DISPLAY_BOX     ENDP

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


;;DO NOT PUT NEW FUNCTIONS BELLOW THIS COMMENT
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

CHANGE_COLOUR   PROC                                ;bl to select colour, cx ammount of chars to change colour to
                            push        ax

                            xor         ax  ,ax
                            mov         ah  ,09h
                            int         10h

                            pop         ax
                            ret
CHANGE_COLOUR   ENDP



END MAIN