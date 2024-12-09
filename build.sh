#!/usr/bin/env bash

set -ex

cargo build

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

cp target/target/os-rust isodir/boot/myos.bin
cp grub.cfg isodir/boot/grub/grub.cfg
grub-mkrescue -o myos.iso isodir

