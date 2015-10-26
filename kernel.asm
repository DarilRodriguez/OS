org 1000h


_main:
        ;==init==
        mov [buffer_pos], 00000000h
        mov [text_buffer], 00h
        ;========

        mov ah, 00h
        mov al, 03h
        int 10h

        jmp _readDisk

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
                        mov ah, 0Eh
                        mov al, 0Dh
                        int 10h
                        mov al, 0Ah
                        int 10h
                        jmp .endcode

                .end:

                jmp .loop
                .endcode:

                ;==code==
                cmp [buffer_pos], 00h
                je .prompt
                mov ecx, 00h
                mov ah, 0Eh
                .looPcode:

                mov al, [text_buffer+ecx]
                int 10h

                inc ecx
                cmp cl, byte [buffer_pos]
                jne .looPcode
                mov [buffer_pos], 00h

                ;========

                .prompt:
                mov ah, 0Eh
                mov al, ':'
                int 10h
                mov al, '>'
                int 10h
                jmp .loop

print:
        mov dx, 0
        mov ah, 0Eh
        .loop:
        lodsb
        cmp al, 00h
        je .end
        int 10h
        .end:
        ret

printc:
        mov bh, 0
        mov bl, 0
        mov ah, 0Eh
        int 10h
        ret

_readDisk:

        mov ah, 02h
        mov al, 01h
        mov ch, 00h
        mov cl, 02h
        mov dh, 01h
        mov dl, 80h
        mov bx, 800h
        int 13h

        mov al, [800h]
        call printc

        jmp $

buffer_pos dd 00h
text_buffer db 00h
