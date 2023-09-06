.model small
.stack 100
.data
     
     NL          db 13d, 10d, "$"
     
     
      
     
     ;---------------------------------------------------------------------------------------------------------
     ;                                           Menu & Function Design
     ;--------------------------------------------------------------------------------------------------------- 
     
     first_line    db "|--------------------------------------|", 13d, 10d, "$" 
     topic_design  db "|   ABC Customer Management Function   |", 13d, 10d, "$"
     menu          db "|--------------------------------------|", 13d, 10d, "$"
     menu1         db "|**       |Functions Available|      **|", 13d, 10d, "$"
     menu2         db "|**       |===================|      **|", 13d, 10d, "$"
     menu3         db "|--------------------------------------|", 13d, 10d, "$"
     menu4         db "|        ^|  1. Add Customer  |^       |", 13d, 10d, "$"
     menu5         db "|        ^|  2. Exit to Main  |^       |", 13d, 10d, "$"
     end_line      db "|======================================|", 13d, 10d, "$"
                
     ;----------------------------------------------------------------------------------------------------------
     ;                                                 prompt message                                          
     ;---------------------------------------------------------------------------------------------------------- 
     
     msg1          db "Please select the function [1 or 2 only!]: ", "$"
     
     error_Msg     db "Invalid Input! Bodoh! Please enter again!", "$"
     
     ;customer functions:
     
     cf1           db 13, 10, "Please enter the customer id: $"
     cf2           db 13, 10, "Please enter the customer name: $"
     cf3           db 13, 10, "Please enter the customer age: $"
     cf4           db 13, 10, "Please enter the customer phone number: $"
     
     infoTopic     db "                Customer Information$"
     
     info          db "CustID---------CustName------------CustAge------Phone$"
       
     successful    db "[The information sucessfully added]$" 
     
     ;----------------------------------------------------------------------------------------------------------
     ;                                                 input store
     ;---------------------------------------------------------------------------------------------------------- 
     
     menu_choice   db ?
     
     ;customer functions:
     
     customerArr db 100 dup("$")
     
     ;----------------------------------------------------------------------------------------------------------
     
     
.code

    MAIN PROC
         
         mov ax, @data
         mov ds, ax
         
         ;print function menu
         call PRINT_MENU
         
         ;prompt user input
         call PROMPT_USER_CHOOSE         
        
         ;exit
         call EXIT
    
    MAIN ENDP
    
    
    

YELLOW PROC
    
     xor ax, ax
     mov ah, 09h
     mov bx, 10001110b
     int 10h
     
     ret
    
    
YELLOW ENDP

WHITE PROC
         
     xor ax, ax
     mov ah, 09h
     mov bx, 00000111b
     int 10h
     
     ret    
    
WHITE ENDP

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
    
     ;print msg1
     mov ah, 09h
     lea dx, msg1
     int 21h
     
     ;store user input
     mov ah, 01h
     int 21h
     sub al, 30h
     mov [menu_choice], al
     
     
     ;conditional
     cmp [menu_choice], 1
     je  f1_checkPoint
     
     cmp [menu_choice], 2
     je  exit_Function
     
     f1_checkPoint:
        
        call ADD_CUSTOMER
        
     exit_Function:

        call EXIT

     ret

PROMPT_USER_CHOOSE ENDP 

ADD_CUSTOMER PROC
    
       call NEWLINE
       mov si, offset customerArr
       mov dx, offset cf1
       mov ah, 09h
       int 21h
       
       L1_ID:
        
            mov ah, 01h
            int 21h
            
            cmp al, 13d ;until user press enter
            je  L2
            mov [si], al
            inc si
            jmp L1_ID
            
            L2:
            
                mov ah, 32
                mov [si], al
                inc si
               
                
                mov dx, offset cf2
                mov ah, 09h
                int 21h
                jmp L3_NAME
                
                L3_NAME:
                
                    mov ah, 01h
                    int 21h
                    
                    cmp al, 13d   ;until user press enter
                    je  L4
    
                    
                    mov [si], al
                    inc si
                    jmp L3_NAME
                    
                    L4:
                        mov al, 32
                        mov [si], al
                        inc si
                        
                        
                        mov dx, offset cf3
                        mov ah, 09h
                        int 21h
                        jmp L5_AGE
                        
                        L5_AGE:
                        
                            mov ah, 01h
                            int 21h
                            
                            cmp al, 13d  ;until user press enter 
                            je  L6
                            mov [si], al
                            inc si
                            jmp L5_AGE
                            
                            L6: 
                                
                                mov al, 32
                                mov [si], al
                                inc si
                                
                                mov dx, offset cf4
                                mov ah, 09h
                                int 21h
                                jmp L7_PHONE
                                
                                L7_PHONE:
                                
                                    mov ah, 01h
                                    int 21h
                                    
                                    cmp al, 13d   ;until user press enter
                                    je  L8
                                    mov [si], al
                                    inc si
                                    jmp L7_PHONE                      
                                    
                                
                                    
                                     L8:
                                                
                                        call NEWLINE        
                                        mov dx, offset successful
                                        mov ah, 09h
                                        int 21h
                                        
                                        call PRINT_CUSTDETAILS
                            
                     
       ret
    
ADD_CUSTOMER ENDP


PRINT_CUSTDETAILS  PROC
    
              call NEWLINE
              call NEWLINE
              call NEWLINE
              
              mov dx, offset infoTopic
              mov ah, 09h
              int 21h
              
              call NEWLINE
              call NEWLINE
              
              mov dx, offset info
              mov ah, 09h
              int 21h
              
              call NEWLINE
              call NEWLINE
              
              lea dx, customerArr
              mov ah, 09h
              int 21h
              
              
              ret 
    

PRINT_CUSTDETAILS  ENDP



NEWLINE PROC
    
    xor ax, ax
    xor dx, dx
    
    mov ah, 09h
    lea dx, NL 
    int 21h
    
    ret
    
NEWLINE ENDP

EXIT  PROC
         ;exit
         mov ah, 4ch
         int 21h
         
         ret
EXIT ENDP 


END MAIN