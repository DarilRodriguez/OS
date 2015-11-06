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
        mov bx, 00h
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
        mov ax, 0E0Dh
        int 10h
        mov al, 0Ah
        int 10h
        ret
