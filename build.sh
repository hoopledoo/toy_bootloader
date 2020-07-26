# We need to go through multiple stages in our build

# We need to assemble to bootloader
nasm boot/boot.asm -o boot.bin

# We need to compile our kernel
clang -ffreestanding -c kernel.c -o kernel.o 

# We need to convert our kernel into a binary
ld -o kernel.bin -Ttext 0x1000 kernel.o --oformat binary

# We need to generate sufficient padding for the amount of disk we plan to read

# We need to concatenate the boot.bin, kernel.bin and padding together
