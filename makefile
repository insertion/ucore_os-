
all:
	nasm boot/bootstrap.asm -f bin -o boot.bin
	dd if=boot.bin of=floppy.img
clean:
	rm *.bin
qemu:
	qemu-system-x86_64 -nographic -s -S -drive format=raw,file=floppy.img
debug:
	gdb -q
log:
	git log --graph
status:
	git status
pull:	
	git pull
push:
	git push
