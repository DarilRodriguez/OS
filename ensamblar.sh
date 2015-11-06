#!/bin/sh

fasm boot.asm boot.bin
fasm kernel.asm kernel.bin
dd if=kernel.bin of=./cdiso/boot.flp
dd if=boot.bin of=./cdiso/kernel.flp
mkisofs -no-emul-boot -boot-load-size 4 -o OS.iso -b boot.flp cdiso/ cdiso/kernel.flp 
qemu-system-x86_64 -cdrom OS.iso

rm boot.bin
rm kernel.bin
