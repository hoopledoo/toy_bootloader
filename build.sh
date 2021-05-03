# We need to go through multiple stages in our build

# We need to assemble to bootloader
cd boot
nasm boot.asm -o boot.bin
mv boot.bin ../
cd ..

# We need to compile our kernel
clang -ffreestanding -c kernel/kernel.c -o kernel.o -m32

# We need to convert our kernel into a binary
ld -o kernel.bin -Ttext 0x1000 kernel.o --oformat binary -m elf_i386

# We need to generate sufficient padding for the amount of disk we plan to read
dd of=padding.bin if=/dev/zero count=4

# We need to concatenate the boot.bin, kernel.bin and padding together
cat boot.bin kernel.bin padding.bin > builds/bootable.0.0.1
