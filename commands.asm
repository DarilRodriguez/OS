
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
             cmp [text_buffer], "c"
             jne .nex3
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
             mov si, 5000h
             mov [si+0], byte 'w'
             mov [si+1], byte 'r'
             mov [si+2], byte 'i'
             mov [si+3], byte 't'
             mov [si+4], byte 'e'
             mov [si+5], byte 00h
             mov di, text_buffer
             call cmpstr
             jnc .end
             mov [write_mode], 0FFh
             jmp .end

        .end:
        ret

write_code:
        mov al, [text_buffer]
        call print
        mov al, [text_buffer+1]
        call print
        ret

