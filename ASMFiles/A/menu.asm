.MODEL      SMALL
.STACK      100
.DATA

buffer          DB 32
                DB ?
                DB 32 DUP(0)
                DB "$"

anyKeyToCont    DB  "Press any key to continue!$"

;++++++++++++++++++++++++++++++++++++++++++++++MENU SECTION++++++++++++++++++++++++++++++++++++++++++++++++++++
menuHeader      DB          "                             __   __      __   __   __  ", 10d
                DB          "                        /\  |__) /  `    |__) /  \ /__` ", 10d
                DB          "                       /~~\ |__) \__,    |    \__/ .__/ $"

divider         DB          40 DUP ("->"),"$"

menuBorder      DB          "        _______________________________________________________ "         ,10d
                DB          "       /\                                                      \"         ,10d
                DB          "   (O)===)><><><><><><><><><><><><><><><><><><><><><><><><><><><)==(O)"   ,10d
                DB          "       \/''''''''''''''''''''''''''''''''''''''''''''''''''''''/"         ,10d
                DB    5 DUP("       (                                                      (",10d,"        )                                                      )",10d)
                DB          "       /\''''''''''''''''''''''''''''''''''''''''''''''''''''''\    "     ,10d
                DB          "   (O)===)><><><><><><><><><><><><><><><><><><><><><><><><><><><)==(O)"   ,10d
                DB          "       \/______________________________________________________/"         ,10d
                DB          "$"

menuSelections  DB          "1)     SALES$$$$$$$$" 
                DB          "2)     CUSTOMER$$$$$"
                DB          "3)     EXIT$$$$$$$$$"

currentSel      DB          1



maxSel          EQU         3

CURSOR MACRO row,column
                ;set cursor
                mov dh, row        ;row
                mov dl, column       ;column
                mov bh, 0         ;
                mov ah, 02h       ; 
                int 10h
ENDM

COLOUR_CHAR MACRO character, colour, printNum
                push    ax
                push    bx
                push    cx
                push    dx

                mov al, character        ;row
                mov bl, colour       ;column
                mov cx, printNum         ;
                mov ah, 09h       ; 
                int 10h

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

                call        menu

                CURSOR      21,0
            EXIT:
                mov         ah  ,4ch
                int         21h
MAIN            ENDP

MENU            PROC
                mov         bl  ,00001011b
                mov         cx  ,240d
                call        CHANGE_COLOUR

                lea         dx  ,menuHeader
                call        PRINT_STR

                call        NEWLINE

                lea         dx  ,divider
                call        PRINT_STR

                mov         bl  ,00001101b
                mov         cl  ,80d
                mov         ch  ,5d
                call        CHANGE_COLOUR

                lea         dx  ,menuBorder
                call        PRINT_STR

                CURSOR      9,15
                mov         bl  ,00001010b
                mov         cl  ,30d
                mov         ch  ,0
                call        CHANGE_COLOUR

                lea         dx  ,menuSelections
                call        PRINT_STR

                CURSOR      12,15
                mov         bl  ,00001010b
                mov         cl  ,30d
                mov         ch  ,0
                call        CHANGE_COLOUR

                lea         dx  ,menuSelections+20
                call        PRINT_STR

                CURSOR      15,15
                mov         bl  ,00001010b
                mov         cl  ,30d
                mov         ch  ,0
                call        CHANGE_COLOUR

                lea         dx  ,menuSelections+40
                call        PRINT_STR

                mov         cx, 9d
                CURSOR      cx,35
                selectionLoop:
                            push        dx
                            mov         dl, " "
                            call        PRINT_CHAR
                            pop         dx

                            CURSOR      cx,35

                            COLOUR_CHAR 17d,00001100b,1

                            mov         ah  ,07h
                            int         21h

                            cmp         al, "w"             ;up
                            je          selectionUp

                            cmp         al, "s"             ;down
                            je          selectionDown          

                            cmp         al  ,13d
                            jne         selectionLoop

                            jmp         selectionLoopExit

                            selectionUp:
                                        mov         bl, 1
                                        mov         bh, [currentSel]
                                        cmp         bh, bl
                                        ja          selectionMoveUp
                                        jmp         selectionLoop

                            selectionDown:
                                        mov         bl, maxSel
                                        mov         bh, [currentSel]
                                        cmp         bh, bl
                                        jb          selectionMoveDown
                                        jmp         selectionLoop

                            selectionMoveUp:
                                        dec         bh
                                        mov         [currentSel],bh
                                        mov         al, 06d
                                        
                                        sub         cx,3

                                        jmp         selectionLoop

                            selectionMoveDown:
                                        inc         bh
                                        mov         [currentSel],bh
                                        mov         al, 06d

                                        add         cx,3

                                        jmp         selectionLoop
                selectionLoopExit:

                ret
MENU            ENDP

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

CHANGE_COLOUR   PROC
                            push        ax

                            xor         ax  ,ax
                            mov         ah  ,09h
                            int         10h

                            pop         ax
                            ret
CHANGE_COLOUR   ENDP



END MAIN