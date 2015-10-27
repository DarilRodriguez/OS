
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

                mov eax, [buffer_pos]
                call printhex
                call code

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

        cmp [buffer_pos], 04h
        jnge .nex1
             cmp [text_buffer], 's'
             jne .nex1
             cmp [text_buffer+1], 't'
             jne .nex1
             cmp [text_buffer+2], 'd'
             jne .nex1
             cmp [text_buffer+3], 'w'
             jne .nex1
             mov ax, 5307h
             mov cx, 0003h
             int 15h
        .nex1:

        .end:
        mov [buffer_pos], 00h
        ret

print:
        .loop:
                mov al, [si]
                cmp al, 00h
                je .end
                mov ah, 0Eh
                int 10h
                inc si
                jmp .loop
        .end:
        ret

printc:
        mov bh, 0
        mov bl, 0
        mov ah, 0Eh
        int 10h
        ret

printhex:
        mov dl, al
        shr al, 4
        shl dl, 4
        shr dl, 4

        cmp al, 0Ah
        jl .lowa
        add al, 55
        jmp .enda
        .lowa:
        add al, 48
        .enda:
        mov ah, 0Eh
        int 10h

        mov al, dl
        cmp al, 0Ah
        jl .lowb
        add al, 55
        jmp .endb
        .lowb:
        add al, 48
        .endb:
        mov ah, 0Eh
        int 10h
        ret

print_endl:
        mov ah, 0Eh
        mov al, 0Dh
        int 10h
        mov al, 0Ah
        int 10h
        ret

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
