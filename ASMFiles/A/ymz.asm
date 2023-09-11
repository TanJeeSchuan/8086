.model small
.stack 100
.data
     
     NL          db 10d, 13d, "$"
     
     
      
     
     ;---------------------------------------------------------------------------------------------------------
     ;                                           Menu & Function Design
     ;--------------------------------------------------------------------------------------------------------- 
                                 
     menu_title    db "            **      ******      ******",  10d, 13d
                   db "           ****    /*////**    **////**", 10d, 13d
                   db "          **//**   /*   /**   **    // ", 10d, 13d
                   db "         **  //**  /******   /**       ", 10d, 13d
                   db "        ********** /*//// ** /**       ", 10d, 13d
                   db "       /**//////** /*    /** //**    **", 10d, 13d
                   db "       /**     /** /*******   //****** ", 10d, 13d
                   db "       //      //  ///////     //////  $"
     
     first_line    db 218d, 38 DUP(196d) , 191d, 13d, 10d, "$" 
     topic_design  db 179d, "   ABC Customer Management Function   ", 179d, 13d, 10d, "$"
     menu          db 179d, 38 DUP(196d), 179d, 13d, 10d, "$"
     menu1         db 179d, "**       |Functions Available|      **", 179d, 13d, 10d, "$"
     menu2         db 179d, "**       |===================|      **", 179d, 13d, 10d, "$"
     menu3         db 179d, 38 DUP(196d), 179d, 13d, 10d, "$"
     menu4         db 179d, "        ^|  1. Add Customer  |^       ", 179d, 13d, 10d, "$"
     menu5         db 179d, "        ^|  2. Exit to Main  |^       ", 179d, 13d, 10d, "$"
     end_line      db 192d, 38 DUP(196d), 217d, 13d, 10d, "$"
                
     ;----------------------------------------------------------------------------------------------------------
     ;                                                PROMPT                                        
     ;---------------------------------------------------------------------------------------------------------- 
     
     msg1          db "Please select the function [1 or 2 only!]: ", "$"
     
     error_Msg     db "Invalid Input! Bodoh! Please enter again!", "$"
     
     ;customer functions:
     
     confirm_Msg   db 10, 13,"Do you want to add more customers? [Y / N]: $" 
     wrong_msg     db 10, 13,"Please enter the valid input [Y or N only] !$" 
     choice        db ?
     
     cf1           db 10, 13, "Please enter the customer id: $"
     cf2           db "Please enter the customer name: $"
     cf3           db "Please enter the customer age: $"
     cf4           db "Please enter the customer phone number: $"
     
     infoTopic     db "                     [Customer Information]$"
     
     info          db "  ID            CustName            Age          Phone$"
     info1         db "======    =====================     ===       =============$"
     
     adding        db 13, 10,"Customer Info adding.....$"  
     successful    db "[The information sucessfully added]$" 
     
     ;----------------------------------------------------------------------------------------------------------
     ;                                                INPUT STORE
     ;---------------------------------------------------------------------------------------------------------- 
     
     menu_choice   db ?
     
     ;customer functions:
     
     customerCount db 0
     customerSize  EQU 60
     max_customers   EQU 10        ; Maximum number of customers
     
     ID            EQU 0
     custName      EQU 11
     Age           EQU 37
     Phone         EQU 46
     
     customerArr   db  500 dup("$")
     
     ;----------------------------------------------------------------------------------------------------------
     ;                                               MACRO FUNCTIONS
     ;----------------------------------------------------------------------------------------------------------
     
     COLOUR_CHAR MACRO character, colour, printNum
                push    ax
                push    bx
                push    cx
                push    dx

                mov al, character        ;row
                mov bl, colour           ;column
                mov cx, printNum         ;column * row
                mov ah, 09h       
                int 10h

                pop    dx
                pop    cx
                pop    bx
                pop    ax
ENDM
     
.code

    MAIN PROC
         
         mov ax, @data
         mov ds, ax

         call   clear
         
	; Initialize customer count
    	mov byte ptr [customerCount], 0

         ;print function menu
         call PRINT_TITLE
         
         call NEWLINE
         
         call PRINT_MENU
         
         ;prompt user input
         call PROMPT_USER_CHOOSE         
   
    
         call EXIT
         
    MAIN ENDP
    

PRINT_TITLE PROC
     
    
    COLOUR_CHAR 0, 00001011b, 1080d
    
   
    lea dx, menu_title
    mov ah, 09h
    int 21h
    
   
    
    call WHITE
     
     
     ret
PRINT_TITLE ENDP

PRINT_MENU PROC
    
     mov ah, 09h
     lea dx, first_line
     int 21h
     
     call YELLOW
     mov ah, 09h
     lea dx, topic_design
     int 21h
     
     call WHITE
     mov ah, 09h
     lea dx, menu
     int 21h  
     
     mov ah, 09h
     lea dx, menu1
     int 21h
     
     mov ah, 09h
     lea dx, menu2
     int 21h
     
     mov ah, 09h
     lea dx, menu3
     int 21h
     
     mov ah, 09h
     lea dx, menu4
     int 21h
     
     mov ah, 09h
     lea dx, menu5
     int 21h
     
     mov ah, 09h
     lea dx, end_line
     int 21h
         
     ret
     
PRINT_MENU ENDP 

PROMPT_USER_CHOOSE PROC
    
choose:

     ;print msg1
     mov ah, 09h
     lea dx, msg1
     int 21h
     
     ;store user input
     mov ah, 01h
     int 21h
     sub al, 30h
     mov [menu_choice], al
     
     
     ;Validate user input
     cmp al, 1
     je valid_choice
     cmp al, 2
     je valid_choice
     
     ; If not 1 or 2, display an error message
     call NEWLINE
     call RED
     
     mov ah, 09h
     lea dx, error_Msg
     int 21h  
     
     call WHITE
     call NEWLINE
     call NEWLINE
     jmp choose
     
     
     ;conditional  

valid_choice:
     
     cmp [menu_choice], 1
     je  f1_checkPoint 
    
     cmp [menu_choice], 2
     je  exit_function
     
     
f1_checkPoint:
        
        lea  si, customerArr
        
        mov  dl, [customerCount]
        mov  al, customerSize
        mul  dl
        add  si,ax
        
        call ADD_CUSTOMER
     
exit_function:
     
        
        call EXIT
        ret 
  
exit_prompt:         
     
     ret

PROMPT_USER_CHOOSE ENDP 

ADD_CUSTOMER PROC                          ;add customer to address in SI
       
       call NEWLINE
       call CLEAR
        
       mov dx, offset adding
       mov ah, 09h
       int 21h
       
       call NEWLINE

begin:

       mov dx, offset cf1
       mov ah, 09h
       int 21h
                 
       PUSH SI                              ;store starting address of array element
        
       mov cx, 10d 
       ;store the ID
       L1:
       
        mov ah, 01h
        int 21h
        
        cmp al, 13d   ;until user press enter
        je  L1END 
        
          
        
        mov [si], al
        
        inc si
        
        loop L1
        
       
      L1END:
      
        POP     SI                            ;copy starting address of array element
        PUSH    SI
        
        ADD     SI, custName
        
        mov bl, "$"
        mov [si], bx
      
        call NEWLINE

        mov dx, offset cf2
        mov ah, 09h
        int 21h
       
        mov cx, 20d
          
       L2:
       
          mov ah, 01h
          int 21h
          
          cmp al, 13d
          je  L2END
           
          mov [si], al       
          
          inc si
          
          loop L2 
          
          L2END:
          
            POP     SI
            PUSH    SI
            ADD     SI, AGE
            
          
            mov bl, "$"
            mov [si], bx
            
            call NEWLINE

            mov dx, offset cf3
            mov ah, 09h
            int 21h
           
            mov cx, 9d
            
            L3:
            
              mov ah, 01h
              int 21h
              
              cmp al, 13d
              je  L3END
              
              mov [si], al
              
              inc si
              
              loop L3
              
              L3END:     
              
                POP     SI
                PUSH    SI
                ADD     SI, phone
              
                mov bl, "$"
                mov [si], bx

                call NEWLINE
              
                mov dx, offset cf4
                mov ah, 09h
                int 21h
                
                mov cx, 15d
                
                L4:
                
                  mov ah, 01h                              
                  int 21h
                  
                  cmp al, 13d
                  je  L4END
                  
                  mov [si], al
                  
                  inc si
                  
                  loop L4
                  
                  L4END:
                  
                    mov bl, "$"
                    mov [si], bx
                  
                    call NEWLINE
                    
                    mov ah, 09h
                    lea dx, successful
                    int 21h
                    
                    inc customerCount   
                 
                 
                L5:    
                   
                   call NEWLINE
                    
                   lea si, customerArr
                   mov cx, 1d
                    
                     
                   POP SI
                    
                L5_END:
                   

                   call PRINT_CUST
                   
                   loop L5_END                 
              
                 
       ret
    
ADD_CUSTOMER ENDP



PRINT_ARR_ELEMENT   PROC
    
                    push    ax
                    push    bx
                    push    cx
                    push    dx
                    PUSH    SI
    
                    MOV     CX,60D
    
 PRINT_ARR_ELEMENT_LOOP:    MOV     DL,[SI]
                            CMP     DL,"$"
                            JE      PRINT_EMPTY
                            JMP     PRINT_EMPTY_END
                            
                            PRINT_EMPTY:
                                    MOV DL,32d
                                    
                            PRINT_EMPTY_END:
                    
                            MOV     AH,02H
                            INT     21H       
                            
                            INC     SI
                    
                            LOOP    PRINT_ARR_ELEMENT_LOOP
                            
                    
                    POP    SI
                    pop    dx
                    pop    cx
                    pop    bx
                    pop    ax
                    
                    RET        
                    
          
PRINT_ARR_ELEMENT   ENDP 

PRINT_CUST          PROC

                   mov ah, 09h
                   lea dx, infoTopic
                   int 21h

                   call NEWLINE

                   mov ah, 09h
                   lea dx, info
                   int 21h

                   call NEWLINE 


                   mov ah, 09h
                   lea dx, info1
                   int 21h

                   call NEWLINE
                   call PRINT_ARR_ELEMENT
                    
                 
                   add si, customerSize
       
               ret    
                   
PRINT_CUST          ENDP     

WHITE PROC
         
     xor ax, ax
     mov ah, 09h
     mov bx, 00000111b
     int 10h
     
     ret    
    
WHITE ENDP



LIGHTRED PROC
    
    xor ax, ax
    mov ah, 09h
    mov bx, 00001100b
    int 10h

     
    ret
     
LIGHTRED ENDP

RED PROC
    
    xor ax, ax
    mov ah, 09h
    mov bx, 10000100b
    int 10h

    ret
    
RED ENDP   

YELLOW PROC
   
    
    xor ax, ax
    mov ah, 09h
    mov bx, 00001110b
    int 10h
    
    ret
    
YELLOW ENDP 
    
LIGHTGREEN PROC
    
    xor ax, ax
    mov ah, 09h
    mov bx, 00001010b
    int 10h
    
    ret
LIGHTGREEN ENDP

GREEN PROC
    
    xor ax, ax
    mov ah, 09h
    mov bx, 00000010b
    int 10h
    
    ret
GREEN ENDP

LIGHTBLUE PROC
    
    xor ax, ax
    mov ah, 09h
    mov bx, 00001011b 
    int 10h
    
    ret
    
LIGHTBLUE ENDP   

BLUE PROC
    
    xor ax, ax
    mov ah, 09h
    mov bx, 00000001b
    int 10h
    
    ret
BLUE ENDP

LIGHTMAGENTA PROC
    
    xor ax, ax
    mov ah, 09h
    mov bx, 00001101b
    int 10h
    
    ret
LIGHTMAGENTA ENDP    


MAGENTA PROC
    
    xor ax, ax
    mov ah, 09h
    mov bx, 00000101b
    int 10h   
    
    ret 
    
MAGENTA ENDP


NEWLINE PROC
    
    
    mov ah, 09h
    lea dx, NL 
    int 21h
    
    ret
    
NEWLINE ENDP

EXIT PROC
    
         
         ;exit
         mov ah, 4ch
         int 21h
    
    ret
EXIT ENDP 

CLEAR PROC   
        
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

        ret
     
CLEAR ENDP
END MAIN