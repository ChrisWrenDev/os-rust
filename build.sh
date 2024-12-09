#!/usr/bin/env bash

set -ex

CROSS_COMPILE=~/opt/cross/bin/i686-elf-

# Assemble boot.s
"${CROSS_COMPILE}"as boot.s -o boot.o

# Compile kernal
"${CROSS_COMPILE}"gcc -c kernel.c -o kernel.o -std=gnu99 -ffreestanding -O2 -Wall -Wextra

# Link kernal
"${CROSS_COMPILE}"gcc -T linker.ld -o myos.bin -ffreestanding -O2 -nostdlib boot.o kernel.o -lgcc

if grub-file --is-x86-multiboot myos.bin; then
  echo multiboot confirmed
else
  echo the file is not multiboot
fi

FOLDER="isodir"
if [ -d "$FOLDER" ]; then
    rm -r isodir
fi

mkdir -p isodir/boot/grub

cp myos.bin isodir/boot/myos.bin
cp grub.cfg isodir/boot/grub/grub.cfg
grub-mkrescue -o myos.iso isodir

