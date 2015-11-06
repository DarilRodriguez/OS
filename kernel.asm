
_main:
        ;==init==
        mov [buffer_pos], 00000000h
        mov [text_buffer], 00h
        ;========

        mov ah, 00h
        mov al, 03h
        int 10h

        jmp .prompt
        .loop:
                mov ah, 00h
                int 16h

                cmp al, 08h
                je .bkspc
                cmp al, 0Dh
                je .ret

                mov ah, 0Eh
                int 10h
                mov ah, al
                mov ecx, [buffer_pos]
                mov [text_buffer+ecx], al

                inc [buffer_pos]

                jmp .end
                .bkspc:
                        cmp [buffer_pos], 00h
                        je .end
                        mov ah, 0Eh
                        mov al, 08h
                        int 10h
                        mov al, 00h
                        int 10h
                        mov al, 08h
                        int 10h
                        mov ah, byte [buffer_pos]
                        dec ah
                        mov byte [buffer_pos], ah
                        jmp .end
                .ret:
                        call print_endl
                        jmp .endcode

                .end:

                jmp .loop
                .endcode:

                ;==code==

                call code
                mov [buffer_pos], 00h

                ;========

                .prompt:
                mov ah, 0Eh
                mov al, ':'
                int 10h
                mov al, '>'
                int 10h
                jmp .loop

code:
        cmp [buffer_pos], 00h
        je .end

        mov ecx, [buffer_pos]
        mov [text_buffer+ecx], 00h

        ;==========inicio============
             mov si, 5000h
             mov [si+0], byte 's'
             mov [si+1], byte 't'
             mov [si+2], byte 'd'
             mov [si+3], byte 'w'
             mov [si+4], byte 00h
             mov di, text_buffer
             call cmpstr
             jnc .nex1
             mov ax, 5307h
             mov cx, 0003h
             int 15h

        .nex1:
             mov si, 5000h
             mov [si+0], byte 'c'
             mov [si+1], byte 'l'
             mov [si+2], byte 'e'
             mov [si+3], byte 'a'
             mov [si+4], byte 'r'
             mov [si+5], byte 00h
             mov di, text_buffer
             call cmpstr
             jnc .nex2
             mov ah, 00h
             mov al, 03h
             int 10h

        .nex2:
             cmp [text_buffer], "p"
             jne .nex3
             mov al, 'A'
             call printc
             mov al, [text_buffer+1]
             call chartobin
             mov dl, al
             shl dl, 4
             mov al, [text_buffer+2]
             call chartobin
             add dl, al
             mov al, dl
             call printc

        .nex3:
             cmp [text_buffer], "p"
             jne .nex3
             mov al, 'A'
             call printc
             mov al, [text_buffer+1]
             call chartobin
             mov dl, al
             shl dl, 4
             mov al, [text_buffer+2]
             call chartobin
             add dl, al
             mov al, dl
             call printc

        .end:
        ret

chartobin:
        ;al
        cmp al, 00h
        je .end
        cmp al, 65
        jge .a
        sub al, 48
        jmp .end
        .a:
        sub al, 55
        .end:
        ret

cmpstr:
        ;di si
        mov al, 01h
        mov ah, al
        mov dl, 0fh
        .loop:
                cmp al, ah
                jne .endf
                cmp ah, 00h
                je .endt

                mov ah, [di]
                mov al, [si]

                inc si
                inc di

        jmp .loop
        .endf:
        shl dl, 1
        jmp .end
        .endt:
        shr dl, 1
        .end:
        ret

include "print.asm"

;_readDisk:
;
;        mov ah, 02h
;        mov al, 01h
;        mov ch, 00h
;        mov cl, 02h
;        mov dh, 01h
;        mov dl, 80h
;        mov bx, 800h
;        int 13h
;
;        mov al, [800h]
;        call printc
;
;        jmp $

buffer_pos dd 00h
text_buffer db 00h
