.model medium
.stack 100h

clears macro

    MOV AH, 00H     ; Set video mode
    MOV AL, 03H     ; Set text 80x25 for comp,rgb,enh
    INT 10H
    

	mov ax,0600h
	mov bh,07h
	mov cx,0000h
	mov dx,154fh
	int 10h
endm

setcur macro
	mov ah,02h
	mov dx,0c19h
	int 10h
endm

.data
	temp 			db ?
	arrowup			db "sdfsdf$"
	arrow 			db 60,45,"            ",186,'$'
	continue 		db 13,10,17 dup(" "),"Press any button to continue..$"
	newline   		db 13,10,"$"
	
	sixline			db 13,10,13,10,13,10,13,10,13,10,13,10,"$"
	invalidinput 	db 13,10,17 dup(" "),44 dup('*')
					db 13,10,17 dup(" "),"*              Invalid Input!              *"
					db 13,10,17 dup(" "),44 dup('*'),"$"
;----------------------------------------------main menu--------------------------------------------------------
	
	mainMenu 		DB 13,10,17 dup(" ")," USE ARROW KEY TO MOVE$	"
					db 13,10,17 dup(" "),201,42 dup(205),187
					db 13,10,17 dup(" "),186,"                                          ",186
					db 13,10,17 dup(" "),186,"                 Main Menu                ",186
					db 13,10,17 dup(" "),186,"                                          ",186
					db 13,10,17 dup(" "),204,42 dup(205),185
					db 13,10,17 dup(" "),186,"  1  ",177,"  Product Menu         $	      "
					DB 186
					db 13,10,17 dup(" "),186,"  2  ",177,"  Order Module        $             ",186
					db 13,10,17 dup(" "),186,"  3  ",177,"  Summary Report      $               ",186
					db 13,10,17 dup(" "),186,"  4  ",177,"  Exit                $              ",186
					db 13,10,17 dup(" "),200,42 dup(205),188,'$','$'
					
					
	mainMenuf 		db 13,10,17 dup(" "),201,42 dup(205),187
					db 13,10,17 dup(" "),186,"                                          ",186
					db 13,10,17 dup(" "),186,"                 Main Menu                ",186
					db 13,10,17 dup(" "),186,"                                          ",186
					db 13,10,17 dup(" "),204,42 dup(205),185
					db 13,10,17 dup(" "),186,"  1  ",177,"  Product Menu                      ",186
					db 13,10,17 dup(" "),186,"  2  ",177,"  Order Module                      ",186
					db 13,10,17 dup(" "),186,"  3  ",177,"  Summary Report                    ",186
					db 13,10,17 dup(" "),186,"  4  ",177,"  Exit                              ",186
					db 13,10,17 dup(" "),200,42 dup(205),188,'$'				
	
	mmchoice   		db ?

	
;--------------------------------------------product menu-------------------------------------------------------
	productMenu		db 13,10,17 dup(" "),201,42 dup(205),187
					db 13,10,17 dup(" "),186,"                                          ",186
					db 13,10,17 dup(" "),186,"               Product Menu               ",186
					db 13,10,17 dup(" "),186,"                                          ",186
					db 13,10,17 dup(" "),204,42 dup(205),185
					db 13,10,17 dup(" "),186,"     ",177,"                       ",177,"            ",186
					db 13,10,17 dup(" "),186," NO. ",177,"        Product        ",177," Unit Price ",186
					db 13,10,17 dup(" "),186,"     ",177,"                       ",177,"            ",186
					db 13,10,17 dup(" "),204,42 dup(205),185
					
					db 13,10,17 dup(" "),186,"  1  ",177," Brown Sugar Milk Tea  ",177,"   RM5.00   ",186
					db 13,10,17 dup(" "),186,"  2  ",177," Mixue Ice Cream       ",177,"   RM3.00   ",186
					db 13,10,17 dup(" "),186,"  3  ",177," Boba Mi-Shake         ",177,"   RM9.00   ",186
					db 13,10,17 dup(" "),186,"  4  ",177," Ice Cream Jasmine Tea ",177,"   RM6.00   ",186
					db 13,10,17 dup(" "),200,42 dup(205),188
					db 13,10,"$"
	
;--------------------------------------------Order Module-------------------------------------------------------		
	;product price per unit
	PBSMT 			db 5
	PMIC			db 3
	PBMS			db 9
	PICJT			db 6
	
	;product quantity	
	QBSMT			db 0
	QMIC			db 0
	QBMS			db 0
	QICJT			db 0
	
	;Ordermenu
	OrderMenu		db 13,10,17 dup(" "),201,42 dup(205),187
					db 13,10,17 dup(" "),186,"                                          ",186
					db 13,10,17 dup(" "),186,"                Order Menu                ",186
					db 13,10,17 dup(" "),186,"                                          ",186
					db 13,10,17 dup(" "),204,42 dup(205),185
					db 13,10,17 dup(" "),186,"     ",177,"                       ",177,"            ",186
					db 13,10,17 dup(" "),186," NO. ",177,"        Product        ",177," Unit Price ",186
					db 13,10,17 dup(" "),186,"     ",177,"                       ",177,"            ",186
					db 13,10,17 dup(" "),204,42 dup(205),185
					
					db 13,10,17 dup(" "),186,"  1  ",177," Brown Sugar Milk Tea  ",177,"   RM5.00   ",186
					db 13,10,17 dup(" "),186,"  2  ",177," Mixue Ice Cream       ",177,"   RM3.00   ",186
					db 13,10,17 dup(" "),186,"  3  ",177," Boba Mi-Shake         ",177,"   RM9.00   ",186
					db 13,10,17 dup(" "),186,"  4  ",177," Ice Cream Jasmine Tea ",177,"   RM6.00   ",186
					db 13,10,17 dup(" "),200,42 dup(205),188
					db 13,10,"$"
					
	;select product
	msgselect       db 13,10,13,10,17 dup(" "),"Select the product (1~4): $"
	productopt		db ?
	
	;product quantity
	msgqty 			db 13,10,17 dup(" "),"Enter product quantity (1~20): $"
	productqty		db ?
	
	;addmore
	msgadd 			db 13,10,17 dup(" "),"Add more product? (Y = YES / N = No) : $"
	addselect		db ?
	
	count db 0
	numl	db ?
.code

do_menu proc

	clears
	xor ax,ax
	mov ah,09h
	lea dx,mainMenu			;print product list
	int 21h
	
	mov al,5
	sub al,count
	mov numl,al
	 mov ah,02h
	mov dl,numl 
	add dl,30h
	int 21h
	
	
	 mov ah,02h
	mov dl,count 
	add dl,30h
	int 21h
	
	LEA SI,mainMenu
	xor cx,cx
	mov cl,count
    LOOP1:

    FIND_STR:
        MOV AL,[SI]
        CMP AL,'$'  
        JE STR_FOUND
        INC SI
        JMP FIND_STR
		
	STR_FOUND:
        INC SI
		mov ah,09h
		mov dx,si			;print product list
		int 21h
        LOOP LOOP1
		
		mov ah,09h
		lea dx,arrow			;print product list
		int 21h
		
	
	
		xor cx,cx
		mov cl,numl
		
	 FIND_STR2:
        MOV AL,[SI]
        CMP AL,'$'  
        JE STR_FOUND2
        INC SI
        JMP FIND_STR2
		
	STR_FOUND2:
        INC SI
		mov ah,09h
		mov dx,si			;print product list
		int 21h
        LOOP FIND_STR2

		


	ret 
do_menu endp


main_menu_ proc
	; mov cx,10
	clears
	 xor ax,ax
	 mov count,al
	 
	 mov ah,09h
	 lea dx,mainMenuf			;print product list
	 int 21h	

	inc count
	
	
test23:	

	MOV AH,00h
	INT 16h
	mov temp,ah
	
	mov ah,temp
	
	cmp ah,'H'
	je count_sub1
	
	cmp ah,'P'
	je count_add2
	
	cmp ah,1CH
	je enterkey
	
	jmp INPUTPASS_DONE
	
count_sub1:
	mov al,1
	cmp count,al
	jng INPUTPASS_DONE

sub_:
	dec count
	jmp INPUTPASS_DONE
	
	
count_add2:
	mov al,4
	cmp count,al
	jge INPUTPASS_DONE

add_:
	inc count
	jmp INPUTPASS_DONE	
	
	INPUTPASS_DONE:
	mov ah,02h
	mov dl,count 
	add dl,30h
	int 21h
	; MOV AH,09H
	; LEA DX,INPUT_EN
	; INT 21H
	call do_menu 		;
	
	jmp test23
	
enterkey:	
	; cmp each condition 
	RET

	
main_menu_ endp


; up down settle 
ARROW_KEY_SD PROC 

	; mov cx,0010
	; xor al,al
	; mov count,al
	; inc count
	
	
; test23:	

	; MOV AH,00h
	; INT 16h
	; mov temp,ah
	
	; mov ah,02h
	; mov dl,temp 
	; int 21h
	
	; mov ah,temp
	
	; cmp ah,'H'
	; je count_sub1
	
	; cmp ah,'P'
	; je count_add2
	
	; cmp ah,1CH
	; je enterkey
	
	; jmp INPUTPASS_DONE
	
; count_sub1:
	; mov al,1
	; cmp count,al
	; jng INPUTPASS_DONE

; sub_:
	; dec count
	; jmp INPUTPASS_DONE
	
	
; count_add2:
	; mov al,4
	; cmp count,al
	; jge INPUTPASS_DONE

; add_:
	; inc count
	; jmp INPUTPASS_DONE	

	
	;CMP AL, 13					;If enter key
	;JE	INPUTPASS_DONE
	
	
	
; INPUTPASS_DONE:
	; mov ah,02h
	; mov dl,count 
	; add dl,30h
	; int 21h
	; ; MOV AH,09H
	; ; LEA DX,INPUT_EN
	; ; INT 21H
	; loop test23
	
; enterkey:	
	; RET
ARROW_KEY_SD ENDP


main proc
	; set up data segment
	mov ax,@data
	mov ds,ax
	
	call main_menu_
	
	
	;CALL ARROW_KEY_SD
	
	;exitprogram
	exitp:	 						
		mov ah,4ch							
		int 21h       

	

main endp

end main