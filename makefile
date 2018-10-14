
all:
	nasm bootstrap.asm -f bin -o boot.bin
clean:
	rm boot.bin
qemu:
	qemu-system-x86_64 -nographic -s -S -drive format=raw,file=floppy.img
debug:
	gdb -q
