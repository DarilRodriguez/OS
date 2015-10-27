use16
org 0x7C00

_start:
        jmp _loadkernel

_loadkernel:
        mov dl, 00h
        mov dh, 00h
        mov ch, 00h
        mov dh, 02h
        mov bx, 100h
        mov es, bx
        mov bx, 00h

        mov ah, 02h
        mov al, 01h
        int 13
        jc _loadkernel

        mov ax, 100h
        mov ds, ax
        mov es, ax
        mov fs, ax
        mov gs, ax
        mov ss, ax

        jmp 100h:00h

times 510-($-$$) db 0
dw 0xAA55
