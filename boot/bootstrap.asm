	;; bootstrap.asm
	;; CPU start in real mode,and BIOS load code at address 0000：7c00
	org 7c00h		;指示程序将被加载到7c00h处，编译器会改变内存的段内偏移
hang:
	jmp hang		;dead loop
	times 510-($-$$) db 0	;fill up 510 bytes with zeros
	db 0x55
	db 0xAA			;boot signature 0xAA55
