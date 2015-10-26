@echo off
fasm bootloader.asm
fasm kernel.asm
dd if=kernel.bin of=./cdiso/boot.flp
dd if=bootloader.bin of=./cdiso/kernel.flp
mkisofs -no-emul-boot -boot-load-size 4 -o OS.iso -b boot.flp cdiso/ cdiso/kernel.flp 

del bootloader.bin
del kernel.bin
