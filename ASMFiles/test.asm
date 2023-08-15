.model small
.stack 100h
.data

    data1 db 'MILK', '$'
    data2 db '****', '$'

    var1 db 'data1: ', '$'
    var2 db 'data2: ', '$'

    var3 db 'Initial content', '$'
    var4 db 'After Replacement', '$'
    var5 db 'After Reverse', '$'
    var6 db 'After changed case', '$'

	LEN db 04h



.code

    MAIN PROC

        ;set up data segment
        MOV AX, @DATA
        MOV DS, AX

        MOV ES,AX      
        lea SI, data1
        lea DI, data2


        ;display initial content
        lea dx, var3
        mov ah, 09h
        int 21H
        
        call NEWLINE

        ;print "data1: MILK"
        mov ah, 09h
        lea dx, var1
        int 21H

        lea dx, data1
        int 21H

        call NEWLINE

        ;print "data2: **"
        mov ah, 09h
        lea dx, var2
        int 21H

        lea dx, data2
        int 21h


        call NEWLINE
        call NEWLINE

        ;display after Replacement value
        lea dx, var4
        mov ah, 09h
        int 21H

        call NEWLINE
        
        mov ah, 09h
        lea dx, var1
        int 21H

        lea dx, data1
        int 21H

        call NEWLINE

        mov ah, 09h
        lea dx, var2
        int 21H
        
        CLD         ;clear direction flag
        mov ch, 00h
        mov cl, [LEN]
        rep movsb

        mov ah, 09h
        lea dx, data2
        int 21H

        call NEWLINE
        call NEWLINE

        ;load address of the string 
        lea dx, var5
        mov ah, 09h
        int 21H

        call NEWLINE

        lea dx, var1
        mov ah, 09h
        int 21H

        lea dx, data1
        mov ah, 09h
        int 21H

        call NEWLINE

        lea dx,var2
        mov ah, 09h
        int 21H

        call REVERSE
        lea dx, data2
        mov ah, 09h
        int 21h

        call NEWLINE
        call NEWLINE

        ;After changed case
        lea dx, var6
        mov ah, 09h
        int 21H

        call NEWLINE

        lea dx, var1
        mov ah, 09h
        int 21H

        lea dx, data1
        mov ah, 09h
        int 21H

        call NEWLINE

        lea dx, var2
        mov ah, 09h
        int 21h

        lea si, data1
        lea di, data2

        call LOWERCASE
        
        lea dx, data2
        mov ah, 09h
        int 21H


        call NEWLINE

        MOV AH, 4CH
        INT 21h

    MAIN ENDP

    REVERSE PROC
        ;load the offset of the string 
        mov si, offset data1

        ;count of characters of the string
        mov cx, 00h

        LOOP1:
        xor ax,ax
        ;compare if this is the last character
        mov al, [si]
        cmp al, '$'
        je  LABEL1

        ;else put in the stack
        push ax

        inc si
        inc cx

        jmp LOOP1

        LABEL1:
        ;again load the starting address of the string 
        mov si, offset data2

            LOOP2:
            ;pop the top of stack
            pop dx

            ;make dh, 0
            xor dh, dh

            ;put the character of the reversed string 
            mov [si], dx

            ;increment si and decrement count 
            inc si

            loop LOOP2

        EXIT:
        ;add $ to the end of the string 
        mov al,"$"
        mov [si],al
        ret

    REVERSE ENDP

    NEWLINE PROC
    
        mov ah, 02h
        mov dl, 0ah ;new line
        int 21H
        mov dl, 0dh ;linefeed
        int 21H

        ret         ;return to the calling mode

    NEWLINE ENDP

    LOWERCASE PROC
        xor bx,bx
        mov bl,[LEN]
        mov cx, 00h
        LCASE: 
            mov dl, [si]
            add dl, 32d  ;convert to LOWERCASE

            mov [di], dl

            inc si
            inc di

            inc cx
            cmp cx, bx
            jb LCASE     ;if first operand small than second operand 

            ret 

    LOWERCASE ENDP

END MAIN