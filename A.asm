.model small  ;mingzhe
.stack 100
.data

log1        DB "                          LOGIN SCREEN                                $"
log2        DB "Username: $"
log3        DB "Password: $"

stringBuff  DB 127                              ;Max number of chars
            DB 0                                ;Length of input
            DB 127 DUP(0)                       ;Allocate space

;last data
desString   DB 5
            DB 5 DUP(0)

wrongInput  DB "INPUT EXCEEDS LENGTH, TRY AGAIN: $"

newline EQU 10

discount    DW 2 DUP (0)                   ;discount format

.code
main proc

mov ax,@data
mov ds,ax
mov ax,4c00h

; start

lea dx,log1                             ;print log1
call print_str

mov dx,newline                          ;print 2 newlines
call print_char
call print_char

lea dx,log2                             ;print log2
call print_str

jmp firstInput              
inputStart:     
                call clear_scr
                lea dx, wrongInput
                call print_str
firstInput:
                mov     di, offset desString
                call    input_str
                jc      inputStart





mov dx,newline                            ;print 2 newlines
call print_char
call print_char 

lea dx, desString + 1
call print_str

;end


mov ah,4ch
int 21h

;function start

strcmp:                                             ;compares strings in SI and DI

input_str:                                          ;gets string from user input into address in DI
            mov dx, offset stringBuff               ;input string
            mov ah,0Ah
            int 21h

            mov ax,0h                               ;reset ax
            mov al, stringBuff + 1                  ;put length of string input in al

            mov bx,[di]                             ;move value of di (the max number of characters in string variable)
            cmp ax,bx                               ;compares if ax is smaller than bx
            jg  error                               ;if true jump to error

            mov si, offset stringBuff + 2           ;put address of the start of the input string into si(only si can do addresses)
            add si, al                              ;add length of the string into the address 好像 c 的 array int arr[1] 是 &arr + 1*sizeof(int) 的 value
            mov ah, "$"                             ;
            mov [si], ah                            ;改最后的char 变 $

            mov cl,al                               ;number of times to loop is the amount of characters inputted
            
            strcpyLoop:
                        mov si,offset stringBuff+1  ;address of the bufferString
                        add si, cx                  ;add CX so that all characters will be read 

                        push di                     ;save di for future use
                        add di,cx                   ;add CX so that all character is written

                        mov ax,[si]                 ;move value of address in SI to ax
                        mov [di],ax                 ;move AX to the location of the address in DI pointed to

                        pop di                      ;get DI

                        loop strcpyLoop             ;loop until CX is finished


            CLC                                     ;clear Carry Flag
            ret

            error:      
                        STC                         ;set Carry Flag
                        ret
                        



print_str:  ;print value from address in dx
            push ax
            mov ah,09h      
            int 21h
            pop ax
            ret

print_num:  ;print from ax 
                            push    ax             ;preserves original ax value
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
            IntPrint:       pop     dx
                            add     dx,48d
                            int     21h
                            loop    IntPrint

            pop dx                              ;restore original ax value
            pop cx
            pop bx
            pop ax
            ret

print_char: ;print from dl
            push ax                             
            mov ah,02h
            int 21h
            pop ax
            ret

clear_scr:  
            push ax
            mov ah,0h
            int 10h
            pop ax
            ret

main endp
end main
