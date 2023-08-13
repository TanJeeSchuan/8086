.model small
.stack 100
.data

str1 DB "Please enter a digit: $"
str2 DB " times $"
str3 DB " returns: $"

.code
main proc

mov ax,@data
mov ds,ax
mov ax,4c00h

; start

lea dx,str1
mov ah,09h
int 21h

mov ah,0001h    ;input
int 21h
mov bl,al

mov ah,02h      ;print \n
mov dl, 10d
int 21h

mov dl,bl       ;print input
int 21h

lea dx,str2     ;print times
mov ah,09h  
int 21h

mov ah,02h      ;print input
mov dl,bl
int 21h

mov ah,09h      ;print returns:
lea dx,str3
int 21h

sub bl,48d      ;multiply
mov al,bl
mul bl

; mov ah,02h      ;print result (single digit only)
; mov dl,al
; add dl,48d
; int 21h

;;METHOD 1
; mov bl,0Ah
; div bl          ;divide ax by bl, al will be quotient, ah is remainder

; mov cl,ah       ;save AH because remainder is last

; mov ah,02h      ;print quotient
; mov dl,al
; add dl,"0"
; int 21h

; mov dl,cl       ;print remainder
; add dl,"0"
; int 21h

mov bl,10d      ;
div bl          ;ax = 00xy

push dx         ;save remainder (y) First In Last Out, only x remains in ax

div bl          ;
push dx         ;

mov ah,02h

pop dx
int 21h

pop dx
int 21h

;end

mov ah,4ch
int 21h

main endp
end main