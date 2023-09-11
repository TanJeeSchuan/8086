.MODEL      SMALL
.STACK      100
.DATA

bcdInputBuffer  DB  "$$$"

abcLogo         DB "                             **      ******      ******",  10d, 13d
                DB "                            ****    /*////**    **////**", 10d, 13d
                DB "                           **//**   /*   /**   **    // ", 10d, 13d
                DB "                          **  //**  /******   /**       ", 10d, 13d
                DB "                         ********** /*//// ** /**       ", 10d, 13d
                DB "                        /**//////** /*    /** //**    **", 10d, 13d
                DB "                        /**     /** /*******   //****** ", 10d, 13d
                DB "                        //      //  ///////     //////  $"

;++++++++++++++++++++++++++++++++++++++++++++++LOGIN SECTION++++++++++++++++++++++++++++++++++++++++++++++++++++
loginChances    DB  5
loginState      DB  0

userNumber      DB  3
loginInfo       DB  "2201610$$$","12345ABC$$$$$$$$$$$$"
                DB  "S2201130$$","67890XYZ$$$$$$$$$$$$"
                DB  "1$$$$$$$$$","1$$$$$$$$$$$$$$$$$$$"

loginHeader     DB  80 DUP("=")
                DB  35 DUP(" "), "LOGIN PAGE"
                DB  10d
                DB  80 DUP("=")
                DB  "$"

loginBorder     DB  "                  ", 201d, 40 DUP(205d), 187d, 10d
                DB  "                  ", 186d, 40 DUP(" ") , 186d, 10d
                DB  "                  ", 204d, 40 DUP(205d), 185d, 10d
                DB  "                  ", 186d, 40 DUP(" ") , 186d, 10d
                DB  "                  ", 200d, 40 DUP(205d), 188d
                DB  "$"

promptUsername  DB  "Username: $"
promptPassword  DB  "Password: $"

userNotFound    DB  "USER NOT FOUND!$"
passWrong       DB  "WRONG PASSWORD$"

successfulLogin DB  "LOGIN SUCCESSFUL!$"
failedLogin1    DB  "LOGIN FAILED $"
failedLogin2    DB  " CHANCES LEFT!$"
noMoreChance    DB  "No more login chances...$"

anyKeyToCont    DB  "Press any key to continue!$"

testStr         DB  "TEST STRING$"

buffer          DB 32
                DB ?
                DB 32 DUP(0)
                DB "$"

inputUsername   DB  10 DUP("$")
inputPassword   DB  20 DUP("$")

skull           DB  "        .... NO! ...                  ... MNO! ...         ", 10d
                DB  "      ..... MNO!! ...................... MNNOO! ...        ", 10d
                DB  "        ..... MMNO! ......................... MNNOO!! .    ", 10d
                DB  "        .... MNOONNOO!   MMMMMMMMMMPPPOII!   MNNO!!!! .    ", 10d
                DB  "        ... !O! NNO! MMMMMMMMMMMMMPPPOOOII!! NO! ....      ", 10d
                DB  "            ...... ! MMMMMMMMMMMMMPPPPOOOOIII! ! ...       ", 10d
                DB  "        ........ MMMMMMMMMMMMPPPPPOOOOOOII!! .....         ", 10d
                DB  "        ........ MMMMMOOOOOOPPPPPPPPOOOOMII! ...           ", 10d
                DB  "            ....... MMMMM..    OPPMMP    .,OMI! ....       ", 10d
                DB  "            ...... MMMM::   o.,OPMP,.o   ::I!! ...         ", 10d
                DB  "                .... NNM:::.,,OOPM!P,.::::!! ....          ", 10d
                DB  "                .. MMNNNNNOOOOPMO!!IIPPO!!O! .....         ", 10d
                DB  "                ... MMMMMNNNNOO:!!:!!IPPPPOO! ....         ", 10d
                DB  "                .. MMMMMNNOOMMNNIIIPPPOO!! ......          ", 10d
                DB  "                ...... MMMONNMMNNNIIIOO!..........         ", 10d
                DB  "            ....... MN MOMMMNNNIIIIIO! OO ..........       ", 10d
                DB  "            ......... MNO! IiiiiiiiiiiiI OOOO ...........  ", 10d
                DB  "        ...... NNN.MNO! . O!!!!!!!!!O . OONO NO! ........  ", 10d
                DB  "        .... MNNNNNO! ...OOOOOOOOOOO .  MMNNON!........    ", 10d
                DB  "        ...... MNNNNO! .. PPPPPPPPP .. MMNON!........      ", 10d
                DB  "            ...... OO! ................. ON! .......       $", 10d

accountSize     EQU 30
usernameOffset  EQU 0
passwordOffset  EQU 10
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

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

;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

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
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

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

itemSaleRecord  DB  0,  0,  0,  0,  0,  0,  0,  0

;ITEM SELECTION

itemSelHeader   DB  201d, 32 DUP (205d), "ITEM SELECTION", 32 DUP (205d), 187d
                DB  20  DUP(186d, 78 DUP(" "), 186d)
                DB  200d, 78 DUP (205d), 188d
                DB  "$"

itemHeader      DB  "ID", 10 DUP(" "), "Item Name", 15 DUP(" "), "Price", 8 DUP(" "), "Qty"
                DB  "$"

itemSelBorder   DB  192d ,52 DUP(196d), 217d
                DB  "$"


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

;++++++++++++++++++++++++++++++++++++++++++++++CUSTOMER SECTION++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++=++++++++++++

customerMenu                DB "                ",218d, 38 DUP(196d) , 191d, 13d, 10d
                            DB "                ",179d, "   ABC Customer Management Function   ", 179d, 13d, 10d
                            DB "                ",179d, 38 DUP(196d), 179d, 13d, 10d
                            DB "                ",179d, "**       |Functions Available|      **", 179d, 13d, 10d
                            DB "                ",179d, "**       |===================|      **", 179d, 13d, 10d
                            DB "                ",179d, 38 DUP(196d), 179d, 13d, 10d
                            DB "                ",179d, "        ^|  1. Add Customer  |^       ", 179d, 13d, 10d
                            DB "                ",179d, "        ^|  2. Display Cust  |^       ", 179d, 13d, 10d
                            DB "                ",179d, "        ^|  3. Remove Cust   |^       ", 179d, 13d, 10d
                            DB "                ",179d, "        ^|  4. Exit to Main  |^       ", 179d, 13d, 10d
                            DB "                ",192d, 38 DUP(196d), 217d, 13d, 10d, "$"

customerMenuStr1            DB  "ABC Customer Management Function$"
customerMenuStr2            DB  "Functions Available$"
customerMenuAdd             DB  "1. Add Customer$"
customerMenuDisplay         DB  "2. Display Cust$"
customerMenuRemove          DB  "3. Remove Cust$"
customerMenuExit            DB  "4. Exit to Main$"

customerMenuInputPrompt     DB  "Enter a selection (1-4): $"

customerInvalidInput        DB  "Enter valid input!$"

customerHeader              DB  80 DUP("=")
                            DB  30 DUP(" "), "CUSTOMER PAGE"
                            DB  10d
                            DB  80 DUP("=")
                            DB  "$"

promptCustomerID            DB      "Customer ID: $"
promptCustomerName          DB      "Customer Name: $"
promptCustomerAge           DB      "Customer Age: $"
promptCustomerPhone         DB      "Customer Phone: $"
promptCustPoint             DB      "Customer Point: $"    
    
promptCustomerFull          DB      "Customer List Full!$"
    
promptCustContinueAdd       DB      "Continue adding ? (y/n) : $"
    
totalCustomersStr           DB      "Number of customers: $"
    
custInputBorder             DB  201d, 40 DUP(205d), 187d
                            DB  10d
                            DB  4 DUP(186d, 40 DUP(" ") , 186d, 10d,    204d, 40 DUP(205d), 185d,10d)
                            DB  186d, 40 DUP(" ") , 186d, 10d
                            DB  200d, 40 DUP(205d), 188d
                            DB  "$" 

customerIDHeader            DB  "ID$"
customerNameHeader          DB  "NAME$"       
customerAgeHeader           DB  "AGE$"       
customerPhoneHeader         DB  "PHONE$"       
customerPointHeader         DB  "POINTS$"       


custDisplayBorder           DB  9 DUP(196d), 194d, 20 DUP(196d), 194d , 5 DUP(196d), 194d, 14 DUP(196d), 194d , 8 DUP(196d), 191d , 10d
                            DB  5 DUP(9 DUP(" "), 179d, 20 DUP(" "), 179d , 5 DUP(" "), 179d, 14 DUP(" "), 179d , 8 DUP(" "), 179d, 10d,    9 DUP(196d), 197d, 20 DUP(196d), 197d , 5 DUP(196d), 197d, 14 DUP(196d), 197d , 8 DUP(196d), 180d ,10d)
                            DB  9 DUP(" "), 179d, 20 DUP(" "), 179d , 5 DUP(" "), 179d, 14 DUP(" "), 179d , 8 DUP(" "), 179d, 10d
                            DB  9 DUP(196d), 193d, 20 DUP(196d), 193d , 5 DUP(196d), 193d, 14 DUP(196d), 193d , 8 DUP(196d), 217d , 10d
                            DB  "$" 

custFullBox1                DB  11111100b
                            DB  5,  20
                            DB  12, 50

custFullBox2                DB  10001100b
                            DB  6,  22
                            DB  12, 50

custFullBox3                DB  01110100b
                            DB  6,  22
                            DB  11, 48

customerNumberLine          DB  195d, 10 DUP(196d), " "
                            DB  "$"

customerRemovePrompt        DB  "Enter customer number to delete: $"

customerCount               DB  2

                                ;012345678901234567890123456789012345678901234567890
customerArr                 DB  "S2299$Tan Jee Schuan$$$$$$21$$0164189855$$100$$$"
                            DB  "S2299$Tan Test Name$$$$$$$80$$01641898555$10055$"
                            DB  500 dup ("$")   

customerSize                EQU 48d
maxCustNum                  EQU 5

id                          EQU 0
custName                    EQU 6
age                         EQU 26
phone                       EQU 30 
bonusPoint                  EQU 42

;_/~\_/~\_/~\_/~\_/~\_/~\_/~\_/~\_/~\_/~\_/~\_/~\_/~\_/~\_.  MACROS _/~\_/~\_/~\_/~\_/~\_/~\_/~\_/~\_/~\_/~\_/~\_/~\_/~\_/~\_
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
                mov         bl, 0000h       ;enable 16 colours for background, disable text blink
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
                mov         bl, 0001h       ;enable 8 colours for background, enable text blink
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

                LOGIN_START:
                            call        cls

                            lea         dx, abcLogo
                            call        PRINT_STR

                            CURSOR      8,  0
                            COLOUR_CHAR 0,  00001011b,  240d
                            lea         dx  ,loginHeader
                            call        PRINT_STR

                            COLOUR_CHAR 0,  00001111b,  280d
                            call        CHANGE_COLOUR

                            call        LOGIN_INPUT

                            call        LOGIN_CHECK

                            ;;login chances check
                            mov         al  ,[loginChances]
                            cmp         al  ,0
                            je          LOGIN_NO_CHANCES

                            ;;if login not successful
                            mov         al  ,[loginState]
                            cmp         al  ,0
                            je          LOGIN_START

                            jmp         AFTER_LOGIN                 ;if login successful

                            LOGIN_NO_CHANCES:
                                        call        cls

                                        mov         bl, 01001111b
                                        mov         cx, 0FFFFh
                                        call        CHANGE_COLOUR

                                        lea         dx, skull
                                        call        PRINT_STR

                                        call        NEWLINE
                                        lea         dx, noMoreChance
                                        call        PRINT_STR

                                        jmp         EXIT_LABLE
                AFTER_LOGIN:

                MENU_START:
                            BG_8_COLOUR
                            call        cls

                            call        MENU        ;will change [currentSel]

                            mov         al, [currentSel]
                            
                            ;;match currentSel and function to call 
                            cmp         al, 1
                            je          main_menu_sales

                            cmp         al, 2
                            je          main_menu_customer

                            cmp         al, 3
                            je          main_menu_exit

                            jmp         MENU_START
                            
                            main_menu_sales:
                                        call        SALES
                                        jmp         MENU_START

                            main_menu_customer:
                                        call        CUSTOMER
                                        jmp         MENU_START

                            main_menu_exit:
                                        call        EXIT                        ;output selection in exitSel
                                                    mov         al, [exitSel]
                                                    cmp         al, 1
                                                    je          MENU_EXIT
                                        jmp         MENU_START
                MENU_EXIT:

                EXIT_LABLE:
                CURSOR      21,0
                mov         ah  ,4ch
                int         21h
MAIN            ENDP

EXIT            PROC                        ;output selection in exitSel

                xor         ax,ax
                xor         bx,bx
                xor         cx,cx
                xor         dx,dx

                call        cls
                CURSOR      0,0             ;change BG colour
                COLOUR_CHAR 0,  00011111b,  1000h

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
                COLOUR_CHAR 0, 00001111b, 9
                lea         dx, yesStr
                call        PRINT_STR

                CURSOR      [noPos],[noPos+1]
                lea         dx, noStr
                call        PRINT_STR

                CURSOR      [yesPos],[yesPos+1]

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
                                        COLOUR_CHAR 0, 00001111b, 9

                                        lea         dx, yesStr
                                        call        PRINT_STR

                                        CURSOR      [noPos],[noPos+1]
                                        COLOUR_CHAR 0, 01110000b, 7

                                        lea         dx, noStr
                                        call        PRINT_STR

                                        jmp         exitSelectionLoop

                            exitSelectionRight:
                                        mov         [exitSel] , 2

                                        CURSOR      [noPos],[noPos+1]
                                        COLOUR_CHAR 0, 00001111b, 7


                                        lea         dx, noStr
                                        call        PRINT_STR

                                        CURSOR      [yesPos],[yesPos+1]
                                        COLOUR_CHAR 0, 01110000b, 9


                                        lea         dx, yesStr
                                        call        PRINT_STR

                                        jmp         exitSelectionLoop
                exitSelectionLoopExit:
                ret

EXIT            ENDP

MENU            PROC
    
                CURSOR      0,  0
                COLOUR_CHAR 0,  00001011b,  240d
                lea         dx  ,menuHeader
                call        PRINT_STR

                CURSOR      4,  0
                lea         dx  ,divider
                call        PRINT_STR

                CURSOR      5,  0
                COLOUR_CHAR 0,  00001101b,  1600d
                lea         dx  ,menuBorder
                call        PRINT_STR

                CURSOR      9,15
                COLOUR_CHAR 0,  00001010b,  30d
                lea         dx  ,menuSelections
                call        PRINT_STR

                CURSOR      12,15
                COLOUR_CHAR 0,  00001010b,  30d
                lea         dx  ,menuSelections+20
                call        PRINT_STR

                CURSOR      15,15
                COLOUR_CHAR 0,  00001010b,  30d
                lea         dx  ,menuSelections+40
                call        PRINT_STR

                ;menu selection code
                mov         [currentSel],1

                mov         cx, 9d
                CURSOR      cx,35
                selectionLoop:
                            push        dx
                            mov         dl, " "
                            call        PRINT_CHAR          ;clear current selection arrow
                            pop         dx

                            CURSOR      cx  ,35
                            COLOUR_CHAR 17d ,00001100b,1    ;print arrow symbol once

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
                                        mov         bh, [currentSel]        ;only move up if current selection is larger than 1
                                        cmp         bh, bl
                                        ja          selectionMoveUp
                                        jmp         selectionLoop

                            selectionDown:
                                        mov         bl, maxSel
                                        mov         bh, [currentSel]        ;only move down if current selection is smaller than maxSel
                                        cmp         bh, bl
                                        jb          selectionMoveDown
                                        jmp         selectionLoop

                            selectionMoveUp:
                                        dec         bh
                                        mov         [currentSel],bh
                                        mov         al, 06d
                                        
                                        sub         cx,3                    ;cx track row of cursor, add 3 to move down one part

                                        jmp         selectionLoop

                            selectionMoveDown:
                                        inc         bh
                                        mov         [currentSel],bh
                                        mov         al, 06d

                                        add         cx,3                    ;cx track row of cursor, sub 3 to move up one part

                                        jmp         selectionLoop
                selectionLoopExit:

                ret
MENU            ENDP

LOGIN_INPUT     PROC                            
                            CURSOR      12, 0
                            COLOUR_CHAR 0,  00001110b,  400d
                            
                            lea         dx, loginBorder
                            call        PRINT_STR

                            CURSOR      13  ,20
                            COLOUR_CHAR 0,  00001111b, 39d
                            lea         dx  ,promptUsername
                            call        PRINT_STR

                            CURSOR      15  ,20
                            COLOUR_CHAR 0,  00001111b, 39d

                            lea         dx  ,promptPassword
                            call        PRINT_STR

                            ;set cursor to username: 
                            CURSOR      13  ,30
                            lea         di  ,inputUsername
                            call        input_str               ;write to DI

                            ;set cursor to password: 
                            CURSOR      15  ,30
                            lea         di  ,inputPassword
                            call        SECRET_INPUT            ;write to DI (input hidden)
                            ret
LOGIN_INPUT     ENDP

LOGIN_CHECK     PROC
                            mov         cx  ,1
                            lea         si  ,inputUsername
                            lea         di  ,loginInfo

                            CURSOR      19, 0
                            COLOUR_CHAR 0,  10001100b, 80d
                            MATCH_USERNAME:
                                        call        STRCMP              ;compares string in si, di until "$"
                                        cmp         ax  ,0              ;if match, go the match user password
                                        je          MATCH_PASSWORD

                                        xor         dx  ,dx
                                        mov         dl  ,[userNumber]
                                        cmp         cx  ,dx                 ;if number of tries more than number of users, user doesn't exist
                                        jae         USER_NOT_FOUND  

                                        add         di  ,accountSize        ;offset to next user
                                        inc         cx                      ;number of tries inc 1

                                        jmp         MATCH_USERNAME          ;find matching username

                                        USER_NOT_FOUND:
                                                    CURSOR      19, 33
                                                    lea         dx  ,userNotFound
                                                    call        PRINT_STR

                                                    jmp         LOGIN_FAIL

                            MATCH_PASSWORD:
                                        lea         si  ,inputPassword
                                        add         di  ,passwordOffset     ;offset to password region

                                        call        STRCMP                  ;compare input password with password of found user
                                        cmp         ax  ,0                  ;if found
                                        je          LOGIN_SUCCESS

                                        PASS_NOT_FOUND:
                                                    CURSOR      19, 33
                                                    lea         dx  ,passWrong
                                                    call        PRINT_STR

                                                    jmp         LOGIN_FAIL

                            LOGIN_FAIL:
                                        CURSOR      21, 0
                                        COLOUR_CHAR 0,  00001100b, 80d

                                        mov         dl  ,[loginChances]         ;decrease number of chances left
                                        dec         dl
                                        mov         [loginChances],dl

                                        ;;print LOGIN FAILED x CHANCES LEFT
                                        lea         dx  ,failedLogin1
                                        call        PRINT_STR

                                        mov         dl  ,[loginChances]
                                        add         dl  ,48d
                                        call        PRINT_CHAR

                                        lea         dx  ,failedLogin2
                                        call        PRINT_STR
                                        ;;-------------------------------------------

                                        CURSOR      24, 0
                                        call        ANYPAUSE
                                        jmp         LOGIN_EXIT

                            LOGIN_SUCCESS:
                                        CURSOR      19, 31
                                        COLOUR_CHAR 0,  10001010b,  40d

                                        lea         dx  ,successfulLogin
                                        call        PRINT_STR

                                        mov         [loginState],1          ;login succesfull, set to 1

                                        CURSOR      24, 0
                                        call        ANYPAUSE
                            LOGIN_EXIT:

                            ;clear login input data
                            push        si
                            push        cx
                            push        ax
                            lea         si, inputUsername
                            mov         cx, 30
                            clearLoginInput:
                                        mov     al,     "$"
                                        mov     [si],   al
                                        inc     si
                                        loop    clearLoginInput
                            pop         ax
                            pop         cx
                            pop         si
                            ret
LOGIN_CHECK     ENDP

SALES           PROC
                            xor         ax  ,ax
                            xor         bx  ,bx
                            xor         cx  ,cx
                            xor         dx  ,dx

    SALES_START:            xor         bx, bx
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
                            
                            call        ITEM_SELECTION          ;modify variable itemSelectionChoice

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
                                                                CURSOR      22,0
                                                                call        ANYPAUSE
                                                                jmp         SALES_START_CP
                                        QTY_CHECK_END:

                                        ;;write sold qty to sales record
                                        mov         [di],   al

                                        CURSOR      22,0
                                        call        ANYPAUSE

                                        jmp         SALES_START_CP
                            ITEM_SELECTION_EXIT:
                            ret
SALES           ENDP

CUSTOMER        PROC
                    customerMenuLoop:
                            call        CLS
                            call        CUSTOMER_MENU

                            CURSOR      20,  0
                            lea         dx,     customerMenuInputPrompt
                            call        print_STR

                            mov         ah, 01h
                            int         21h
                            
                            cmp         al, "1"
                            je          customerMenu_Add

                            cmp         al, "2"
                            je          customerMenu_Display

                            cmp         al, "3"
                            je          customerMenu_Remove

                            cmp         al, "4"
                            je          customerMenu_Exit

                            ;;invalid input
                            CURSOR      20,  0
                            lea         dx, customerInvalidInput
                            call        PRINT_STR
                            CURSOR      23,  0
                            call        ANYPAUSE
                            jmp         customerMenuLoop

                            customerMenu_Add:
                                        call        cls
                                        call        ADD_CUSTOMER
                                        jmp         customerMenu_End
                            
                            customerMenu_Display:
                                        call        cls
                                        call        DISPLAY_ALL_CUST
                                        jmp         customerMenu_End

                            customerMenu_Remove:
                                        call        cls
                                        call        REMOVE_CUSTOMER
                                        jmp         customerMenu_End
                                        
                            customerMenu_End:
                                        CURSOR      23, 0
                                        call        ANYPAUSE
                                        jmp         customerMenuLoop
                
                customerMenu_Exit:
                            ret
CUSTOMER        ENDP

;;;;;;

CUSTOMER_MENU       PROC
                            COLOUR_CHAR 0,  00001011b, 640d
                            lea         dx, abcLogo
                            call        PRINT_STR

                            CURSOR      9,0
                            COLOUR_CHAR 0,  00001101b, 880d
                            lea         dx, customerMenu
                            call        PRINT_STR

                            CURSOR      10, 20
                            COLOUR_CHAR 0,  00001111b, 35d
                            lea         dx, customerMenuStr1
                            call        PRINT_STR

                            CURSOR      12, 27
                            COLOUR_CHAR 0,  00001111b, 19d
                            lea         dx, customerMenuStr2
                            call        PRINT_STR

                            CURSOR      15, 29
                            COLOUR_CHAR 0,  00001010b, 15d
                            lea         dx, customerMenuAdd
                            call        PRINT_STR

                            CURSOR      16, 29
                            COLOUR_CHAR 0,  00001010b, 15d
                            lea         dx, customerMenuDisplay
                            call        PRINT_STR

                            CURSOR      17, 29
                            COLOUR_CHAR 0,  00001010b, 15d
                            lea         dx, customerMenuRemove
                            call        PRINT_STR

                            CURSOR      18, 29
                            COLOUR_CHAR 0,  00001010b, 15d
                            lea         dx, customerMenuExit
                            call        PRINT_STR

                            ret
CUSTOMER_MENU       ENDP

ADD_CUSTOMER        PROC
                            CURSOR      0,0

                            COLOUR_CHAR 0, 00001011b, 380d

                            lea         dx, customerHeader
                            call        PRINT_STR

                            call        NEWLINE
                            call        NEWLINE   

                            COLOUR_CHAR 0, 00001110b, 1100d
                            
                            lea         dx, custInputBorder                         
                            call        PRINT_STR

                            ;set cursor: 
                            CURSOR      6,  2
                            COLOUR_CHAR 0, 00001111b, 25d

                            lea         dx  ,promptCustomerID
                            call        PRINT_STR

                            CURSOR      8, 2
                            COLOUR_CHAR 0, 00001111b, 25d

                            lea         dx, promptCustomerName
                            call        PRINT_STR

                            CURSOR      10, 2
                            COLOUR_CHAR 0, 00001111b, 25d

                            lea         dx, promptCustomerAge
                            call        PRINT_STR

                            CURSOR      12, 2
                            COLOUR_CHAR 0, 00001111b, 25d

                            lea         dx, promptCustomerPhone
                            call        PRINT_STR

                            CURSOR      14, 2
                            COLOUR_CHAR 0, 00001111b, 25d

                            lea         dx, promptCustPoint
                            call        PRINT_STR

                            customerEnter:
                            ;;;compare if is full
                                        mov         cl, [customerCount]
                                        cmp         cl, maxCustNum
                                        jae         customerFull

                                        ;;;offset to address of empty customer (if exists)
                                        lea         si, customerArr
                                        mov         cx, maxCustNum
                                        findEmptyCust:
                                                    mov     dl, [si]
                                                    cmp     dl, "$"             ;if found empty customer element
                                                    je      findEmptyCustEnd

                                                    add     si, customerSize   

                                                    loop    findEmptyCust
                                                    jmp     customerFull        ;if cannot find, means full
                                        findEmptyCustEnd:
                                        call        CUST_DETAIL_INPUT

                                        mov         dl, [customerCount]
                                        inc         dl
                                        mov         [customerCount], dl

                                        mov         cl, [customerCount]
                                        cmp         cl, maxCustNum
                                        jae          customerFull

                                        ;;continue input?
                                        customerEnterInput:
                                                    CURSOR      18, 0
                                                    COLOUR_CHAR 0, 00001011b,   40
                                                    lea         dx, promptCustContinueAdd
                                                    call        PRINT_STR

                                                    mov         ah, 01h
                                                    int         21h

                                                    cmp         al, "n"
                                                    je          customerEnterExit

                                                    cmp         al, "y"
                                                    jne         customerEnterInput

                                        call        CLEAR_CUST_INPUT
                                        jmp         customerEnter

                            customerFull:
                                        CURSOR      0,0
                                        call        CUST_FULL_BOX

                            customerEnterExit:

                            ret
ADD_CUSTOMER        ENDP

REMOVE_CUSTOMER     PROC
                        call        DISPLAY_ALL_CUST
                        call        CUSTOMER_NUMBERING      ;show numbering on the customers

                        REMOVE_CUSTOMER_INPUT_LOOP:
                                    CURSOR      18, 0
                                    lea         dx, customerRemovePrompt
                                    call        PRINT_STR

                                    mov         ah, 01h
                                    int         21h

                                    xor         ah,ah
                                    sub         al, 48d     ;convert into value
                                    dec         al          ;dec 1

                                    cmp         al, 0
                                    jb          REMOVE_CUSTOMER_INPUT_LOOP

                                    cmp         al, maxCustNum
                                    jae         REMOVE_CUSTOMER_INPUT_LOOP

                        lea         si, customerArr
                        mov         bx, customerSize
                        mul         bx
                        add         si, ax
                        call        REMOVE_SI_CUST

                        ret
REMOVE_CUSTOMER     ENDP

REMOVE_SI_CUST      PROC
                        mov         al, [si]
                        cmp         al, "$"
                        je          REMOVE_SI_CUST_EXIT

                        mov         cx, customerSize
                        mov         al, "$"
                        REMOVE_SI_CUST_LOOP:
                                    mov     [si],   al
                                    inc     si
                                    loop    REMOVE_SI_CUST_LOOP


                        mov         al, [customerCount]
                        dec         al
                        MOV         [customerCount],    al

                        REMOVE_SI_CUST_EXIT:
                        ret
REMOVE_SI_CUST      ENDP

DISPLAY_ALL_CUST    PROC            ;display customerArr
                            CURSOR      2,0
                            lea         dx, custDisplayBorder
                            call        PRINT_STR

                            CURSOR      3,2
                            COLOUR_CHAR 0,  00001011b,  3
                            lea         dx, customerIDHeader
                            call        PRINT_STR

                            CURSOR      3,11
                            COLOUR_CHAR 0,  00001011b,  10
                            lea         dx, customerNameHeader
                            call        PRINT_STR

                            CURSOR      3,32
                            COLOUR_CHAR 0,  00001011b,  3
                            lea         dx, customerAgeHeader
                            call        PRINT_STR

                            CURSOR      3,38
                            COLOUR_CHAR 0,  00001011b,  10
                            lea         dx, customerPhoneHeader
                            call        PRINT_STR

                            CURSOR      3,52
                            COLOUR_CHAR 0,  00001011b,  7
                            lea         dx, customerPointHeader
                            call        PRINT_STR

                            xor         bx, bx
                            mov         bl, 3
                            CURSOR      3,20    
                            lea         si ,customerArr         ;print all customers
                            call        PRINT_ALL_CUST



                            CURSOR      18,2
                            lea         dx, totalCustomersStr   
                            call        PRINT_STR

                            mov         dl, [customerCount]     ;print number of customer
                            add         dl, 48d
                            mov         ah, 02h
                            int         21h

                            ret
DISPLAY_ALL_CUST    ENDP

CUST_FULL_BOX       PROC
                            BG_16_COLOUR
                            lea         si, custFullBox1
                            call        DISPLAY_BOX
                            lea         si, custFullBox2
                            call        DISPLAY_BOX
                            lea         si, custFullBox3
                            call        DISPLAY_BOX
                            CURSOR      8, 26
                            lea         dx, promptCustomerFull
                            call        PRINT_STR
                            ret
CUST_FULL_BOX       ENDP

CLEAR_CUST_INPUT    PROC
                        CURSOR      6, 15
                        COLOUR_CHAR " ", 00001010b, 20d
                        CURSOR      8, 17
                        COLOUR_CHAR 0, 00001010b, 20d
                        CURSOR      10, 16
                        COLOUR_CHAR 0, 00001010b, 20d
                        CURSOR      12, 18
                        COLOUR_CHAR 0, 00001010b, 20d
                        CURSOR      14, 18
                        COLOUR_CHAR 0, 00001010b, 20d

                        ret
CLEAR_CUST_INPUT    ENDP

CUST_DETAIL_INPUT   PROC                                        ;input into customer array
                        push        cx
                    startReadID:
                        CURSOR      6, 15
                        COLOUR_CHAR 0, 00001010b, 20d
                        push        si
                        mov         cx, 5d    
                              
                            readID:
                                    mov         ah, 01h
                                    int         21h

                                    cmp         al, 13d
                                    je          startReadName

                                    mov         [si], al
                                    inc         si
                                    loop        readID 

                    startReadName:
                            pop         si
                            push        si
                            add         si, custName 
                            mov         bl, "$"
                            mov         [si], bl       
                            
                            CURSOR      8, 17
                            COLOUR_CHAR 0, 00001010b, 20d
                            mov         cx, 20d
                            jmp         readName
                    
                            readName:   

                                    mov         ah, 01h
                                    int         21h

                                    cmp         al, 13d
                                    je          startReadAge

                                    mov         [si], al
                                    inc         si

                                    loop        readName

                    startReadAge:
                            pop         si
                            push        si
                            add         si, Age
                            mov         bl, "$"
                            mov         [si], bl 

                            CURSOR      10, 16
                            COLOUR_CHAR 0, 00001010b, 20d
                            mov         cx, 4d
                            jmp         readAge

                            readAge:

                                    mov         ah, 01h
                                    int         21h

                                    cmp         al, 13d
                                    je          startReadPhone

                                    mov         [si], al
                                    inc         si

                                    loop        readAge

                    startReadPhone:

                            pop         si
                            push        si
                            add         si, Phone
                            mov         bl, "$"
                            mov         [si], bl

                            CURSOR      12, 18
                            COLOUR_CHAR 0, 00001010b, 20d
                            mov         cx, 12d
                            jmp         ReadPhone 
                    
                            ReadPhone: 

                                    mov         ah, 01h
                                    int         21h

                                    cmp         al, 13d
                                    je          startCustPoint

                                    mov         [si], al
                                    inc         si

                                    loop        ReadPhone
                    
                    startCustPoint:

                            pop         si
                            push        si
                            add         si, bonusPoint
                            mov         bl, "$"
                            mov         [si], bl

                            CURSOR      14, 18
                            COLOUR_CHAR 0, 00001010b, 20d
                            mov         cx, 4d
                            jmp         ReadPoint
                    
                            ReadPoint:

                                    mov         ah, 01h
                                    int         21h

                                    cmp         al, 13d
                                    je          confirmAdded

                                    mov         [si], al
                                    inc         si

                                    loop        ReadPoint

                    confirmAdded:
                            pop         si

                            pop         cx

                            ret
CUST_DETAIL_INPUT   ENDP

PRINT_ALL_CUST      PROC                                        ;print customer array in SI
                        push        si

                        push        bx
                        ;;GET CURRENT CURSOR POS
                        mov         ah, 03h
                        mov         bl, 00h
                        int         10h                 ;cursor pos will be stored in dh dl

                        pop         bx
                        push        dx

                        xor         cx, cx
                        mov         cl, maxCustNum
                        PRINT_ALL_CUST_LOOP:
                                    add         bl  ,2
                                    CURSOR      bl  ,3

                                    call        PRINT_CUST
                                    add         si  ,customerSize

                                    loop        PRINT_ALL_CUST_LOOP

                        pop         dx                
                        CURSOR      dh, dl

                        pop         si
                        ret
PRINT_ALL_CUST      ENDP

PRINT_CUST          PROC
                            push    ax
                            push    bx
                            push    cx
                            push    dx
                            push    si

                            xor         ax, ax
                            lea         dx, [si]            ;id
                            call        print_STR

                            CURSOR      bl, 10
                            lea         dx, [si + custName]
                            call        PRINT_STR

                            CURSOR      bl, 32
                            lea         dx, [si + age]
                            call        PRINT_STR

                            CURSOR      bl, 37
                            lea         dx, [si + phone]
                            call        print_STR

                            CURSOR      bl, 52
                            lea         dx, [si + bonusPoint]
                            call        print_STR


                            pop     si
                            pop     dx
                            pop     cx
                            pop     bx
                            pop     ax
                            ret
PRINT_CUST          ENDP

CUSTOMER_NUMBERING  PROC    
                        mov         ah, 2h
                        CURSOR      5,  60
                        lea         dx, customerNumberLine
                        call        PRINT_STR
                        COLOUR_CHAR 0,  00001100b, 1d
                        mov         dl, "1"
                        int         21h

                        CURSOR      7,  60
                        lea         dx, customerNumberLine
                        call        PRINT_STR
                        COLOUR_CHAR 0,  00001100b, 1d
                        mov         dl, "2"
                        int         21h

                        CURSOR      9,  60
                        lea         dx, customerNumberLine
                        call        PRINT_STR
                        COLOUR_CHAR 0,  00001100b, 1d
                        mov         dl, "3"
                        int         21h

                        CURSOR      11,  60
                        lea         dx, customerNumberLine
                        call        PRINT_STR
                        COLOUR_CHAR 0,  00001100b, 1d
                        mov         dl, "4"
                        int         21h

                        CURSOR      13,  60
                        lea         dx, customerNumberLine
                        call        PRINT_STR
                        COLOUR_CHAR 0,  00001100b, 1d
                        mov         dl, "5"
                        int         21h

                        ret
CUSTOMER_NUMBERING  ENDP

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
                            mov         al  ,   "$"
                            mov         [si],   al
                            inc         si
                            loop        BCD_INPUT_CLEAR_STR
                mov         ax, dx
                
                pop         si
                ret
BCD_INPUT       ENDP

DISPLAY_BOX     PROC                    ;display box from detials from si
                            push    ax
                            push    bx
                            push    cx
                            push    dx

                            xor     ax, ax
                            xor     bx, bx
                            xor     cx, cx
                            xor     dx, dx

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

                            pop    dx
                            pop    cx
                            pop    bx
                            pop    ax
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

SECRET_INPUT    PROC
                            push        ax
                            push        di

                            xor         ax,ax
                            xor         cx,cx

                            mov         ah,07h
                            mov         dl, "*"
                            SECRET_INPUT_LOOP:
                                        int         21h
                                        
                                        cmp         al, 13d
                                        je          SECRET_INPUT_LOOP_EXIT

                                        call        PRINT_CHAR

                                        mov         [di],al
                                        inc         di

                                        jmp         SECRET_INPUT_LOOP

                            SECRET_INPUT_LOOP_EXIT:

                            pop         di
                            pop         ax
                            ret
SECRET_INPUT    ENDP

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