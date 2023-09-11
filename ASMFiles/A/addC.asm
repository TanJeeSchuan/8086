.model small
.stack 100h
.data
    
abcLogo         DB "                          **      ******      ******",  10d, 13d
                DB "                         ****    /*////**    **////**", 10d, 13d
                DB "                        **//**   /*   /**   **    // ", 10d, 13d
                DB "                       **  //**  /******   /**       ", 10d, 13d
                DB "                      ********** /*//// ** /**       ", 10d, 13d
                DB "                     /**//////** /*    /** //**    **", 10d, 13d
                DB "                     /**     /** /*******   //****** ", 10d, 13d
                DB "                     //      //  ///////     //////  $"


anyKeyToCont    DB  "Press any key to continue!$"

;------------------------------------------------------------------------------------------------------------


customerMenu                DB "                ",218d, 38 DUP(196d) , 191d, 13d, 10d
                            DB "                ",179d, "   ABC Customer Management Function   ", 179d, 13d, 10d
                            DB "                ",179d, 38 DUP(196d), 179d, 13d, 10d
                            DB "                ",179d, "**       |Functions Available|      **", 179d, 13d, 10d
                            DB "                ",179d, "**       |===================|      **", 179d, 13d, 10d
                            DB "                ",179d, 38 DUP(196d), 179d, 13d, 10d
                            DB "                ",179d, "        ^|  1. Add Customer  |^       ", 179d, 13d, 10d
                            DB "                ",179d, "        ^|  2. Display Cust  |^       ", 179d, 13d, 10d
                            DB "                ",179d, "        ^|  3. Exit to Main  |^       ", 179d, 13d, 10d
                            DB "                ",192d, 38 DUP(196d), 217d, 13d, 10d, "$"

customerMenuStr1            DB  "ABC Customer Management Function$"
customerMenuStr2            DB  "Functions Available$"
customerMenuAdd             DB  "1. Add Customer$"
customerMenuDisplay         DB  "2. Display Cust$"
customerMenuExit            DB  "3. Exit to Main$"

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

CURSOR MACRO row,column
                push    ax
                push    bx
                push    cx
                push    dx

                ;set cursor
                mov dh, row        ;row
                mov dl, column       ;column
                mov bh, 0         
                mov ah, 02h        
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

                mov al, character    
                mov bl, colour       
                mov cx, printNum     
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

.code
MAIN            PROC
                mov ax, @data
                mov ds, ax

                customerMenuLoop:
                            call        CLS
                            call        CUSTOMER_MENU

                            CURSOR      20,  0

                            mov         ah, 01h
                            int         21h
                            
                            cmp         al, "1"
                            je          customerMenu_Add

                            cmp         al, "2"
                            je          customerMenu_Display

                            cmp         al, "3"
                            je          customerMenu_Exit

                            ;;invalid input
                            lea         dx, customerInvalidInput
                            call        PRINT_STR
                            call        ANYPAUSE
                            CURSOR      23,  0
                            jmp         customerMenuLoop

                            customerMenu_Add:
                                        call        cls
                                        call        ADD_CUSTOMER
                                        CURSOR      23,  0
                                        call        ANYPAUSE
                                        jmp         customerMenuLoop
                            
                            customerMenu_Display:
                                        call        cls
                                        call        DISPLAY_ALL_CUST
                                        CURSOR      23,  0
                                        call        ANYPAUSE
                                        jmp         customerMenuLoop
                
                customerMenu_Exit:
                CURSOR      20,  0
                mov         ah,4ch
                int         21h
MAIN ENDP

CUSTOMER_MENU       PROC
                            COLOUR_CHAR 0,  00001011b, 640d
                            lea         dx, abcLogo
                            call        PRINT_STR

                            CURSOR      9,0
                            COLOUR_CHAR 0,  00001101b, 800d
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

                            ;;;offset to address of empty customer (if exists)
                            mov         cl, maxCustNum
                            mov         ch, [customerCount]

                            xor         ax, ax              ;offset to empty customer
                            mov         al, customerSize
                            mul         ch
                            lea         si, customerArr
                            add         si, ax

                            cmp         ch, cl              ;if is full exit "enter details" part
                            jae         customerFull

                            sub         cl, ch              ;get remainding ammount of empty elements
                            xor         ch, ch
                            customerEnter:
                                        call        CUST_DETAIL_INPUT

                                        add         si, customerSize

                                        mov         dl, [customerCount]
                                        inc         dl
                                        mov         [customerCount], dl

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
                                        loop        customerEnter

                            customerFull:
                                        call        CUST_FULL_BOX
                                        CURSOR      20,40
                                        call        ANYPAUSE

                            customerEnterExit:

                            ret
ADD_CUSTOMER        ENDP

DISPLAY_ALL_CUST    PROC
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
                        mov         cl, [customerCount]
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

;;;;;;;;;;;add copy fucntion bellow
CHANGE_COLOUR   PROC
                            push        ax

                            xor         ax  ,ax
                            mov         ah  ,09h
                            int         10h

                            pop         ax
                            ret
CHANGE_COLOUR   ENDP

PRINT_CHAR      PROC                                        ;print cjaracter of value in dl
                            push    ax
                            mov     ah,02h
                            int     21h
                            pop     ax
                            ret
PRINT_CHAR      ENDP

PRINT_STR       PROC
                            push        ax
                            mov         ah,09d
                            int         21h
                            pop         ax
                            ret
PRINT_STR       ENDP

NEWLINE         PROC 

                            push    dx
                            mov     dl,0Ah
                            call PRINT_CHAR
                            pop     dx
                            ret

NEWLINE         ENDP 

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

END MAIN