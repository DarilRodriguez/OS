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
             jmp .end

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
             jmp .end

        .nex2:
             cmp [text_buffer], 'c'
             cmp [text_buffer+1], 'a'
             cmp [text_buffer+2], 'l'
             cmp [text_buffer+3], 'l'
             jne .nex3

             mov dx, 0000h
             mov al, [text_buffer+5]
             call chartobin
             mov dh, al
             shl dh, 4
             mov al, [text_buffer+6]
             call chartobin
             add dh, al
             mov al, [text_buffer+7]
             call chartobin
             mov dl, al
             shl dl, 4
             mov al, [text_buffer+8]
             call chartobin
             add dl, al
             mov ax, 00h
             mov es, ax
             mov bx, dx
             mov si, dx
             call dx

             jmp .end

        .nex3:
             cmp [text_buffer], 'r'
             cmp [text_buffer+1], 'e'
             cmp [text_buffer+2], 'a'
             cmp [text_buffer+3], 'd'
             jne .nex4

             mov dx, 0000h
             mov al, [text_buffer+5]
             call chartobin
             mov dh, al
             shl dh, 4
             mov al, [text_buffer+6]
             call chartobin
             add dh, al
             mov al, [text_buffer+7]
             call chartobin
             mov dl, al
             shl dl, 4
             mov al, [text_buffer+8]
             call chartobin
             add dl, al
             ;dl -> pointer

             mov al, [text_buffer+10]
             call chartobin
             mov bl, al
             shl bl, 4
             mov al, [text_buffer+11]
             call chartobin
             add bl, al
             ;bl -> long of read

             mov ecx, ebx
             mov si, dx
             .loopNex3:
                 mov al, [si]
                 call printhex
                 mov al, ' '
                 call printc
             inc si
             loop .loopNex3
             call print_endl

             jmp .end

        .nex4:
             mov si, 5000h
             mov [si+0], byte 'w'
             mov [si+1], byte 'r'
             mov [si+2], byte 'i'
             mov [si+3], byte 't'
             mov [si+4], byte 'e'
             mov [si+5], byte 00h
             mov di, text_buffer
             call cmpstr
             jnc .nex5
             mov [write_mode], 0FFh
             jmp .end

        .nex5:
             cmp [text_buffer], "c"
             jne .end
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

write_code:
        cmp [buffer_pos], 00h
        je .end
        
        mov ecx, [buffer_pos]
        mov [text_buffer+ecx], 00h
                mov si, 5000h
                mov [si], byte 'e'
                mov [si+1], byte 'x'
                mov [si+2], byte 'i'
                mov [si+3], byte 't'
                mov [si+4], byte 00h
                mov di, text_buffer
                call cmpstr
                jnc .next1
                mov [write_mode], 00h
                jmp .end

        .next1:
                cmp [text_buffer], 'P'
                jne .next2
                mov dx, 0000h
                mov al, [text_buffer+1]
                call chartobin
                mov dh, al
                shl dh, 4
                mov al, [text_buffer+2]
                call chartobin
                add dh, al
                mov al, [text_buffer+3]
                call chartobin
                mov dl, al
                shl dl, 4
                mov al, [text_buffer+4]
                call chartobin
                add dl, al
                mov [write_ptr], dx
                mov ax, [write_ptr]
                mov al, ah
                call printhex
                mov ax, [write_ptr]
                call printhex
                jmp .end
        .next2:

        .hexcod:
                mov al, [text_buffer]
                call chartobin
                mov dl, al
                shl dl, 4
                mov al, [text_buffer+1]
                call chartobin
                add dl, al
                mov si, [write_ptr]
                mov [si], byte dl
                inc [write_ptr]
                mov ax, [write_ptr]
                mov al, ah
                call printhex
                mov ax, [write_ptr]
                call printhex
                jmp .end
        .end:
        ret

