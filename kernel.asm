
_main:
        ;==init==
        mov [buffer_pos] , 00h
        mov [text_buffer], 00h
        mov [write_mode] , 00h
        mov [write_ptr]  , 00h
        ;========

        mov ah, 00h
        mov al, 03h
        int 10h

;        mov si, 5000h
;        mov [si+1], byte 0xb0
;        mov [si+2], byte 0x61
;        mov [si+3], byte 0xb4
;        mov [si+4], byte 0x0E
;        mov [si+5], byte 0xcd
;        mov [si+6], byte 0x10
;        mov [si+7], byte 0xc3
;        call 0000h:5001h

        jmp .prompt
        .loop:
                mov ah, 00h
                int 16h

                cmp al, 08h
                je .bkspc
                cmp al, 0Dh
                je .ret

                cmp [buffer_pos], 4Dh
                je .loop

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
                cmp [write_mode], 00h
                je .code

                .write_mode_prompt:
                
                call write_code
                cmp [write_mode], 00h
		je .prompt

		mov ah, 0Eh
                mov al, 'w'
                int 10h
                mov al, 'm'
                int 10h
                mov al, ':'
                int 10h
                mov al, '>'
                int 10h
                mov al, 0C9h
		
                mov [buffer_pos], 00h

                jmp .loop


                .code:
                call code
                cmp [write_mode], 0FFh
                je .write_mode_prompt
                mov [buffer_pos], 00h
                ;========

                .prompt:
                mov ah, 0Eh
                mov al, ':'
                int 10h
                mov al, '>'
                int 10h
                jmp .loop

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

_readDisk:

        mov si, 800h
        mov [si], byte 'H'
        mov [si+1], byte 'o'
        mov [si+2], byte 'l'
        mov [si+3], byte 'a'
        mov [si+4], byte 00h

        mov ah, 03h
        mov al, 05h
        mov ch, 00h
        mov cl, 02h
        mov dh, 01h
        mov dl, 80h
        mov bx, 800h
        int 13h

        mov ah, 02h
        mov al, 05h
        mov ch, 00h
        mov cl, 02h
        mov dh, 01h
        mov dl, 80h
        mov bx, 1000h
        int 13h

        mov al, [1000h]
        call print

        jmp $

include "commands.asm"
include "print.asm"

buffer_pos dd 00h
text_buffer rb 0Ah
write_mode rb 01h
write_ptr rw 01h
