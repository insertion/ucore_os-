	;; bootstrap.asm
	;; CPU start in real mode,and BIOS load code at address 0000��7c00
	org 7c00h		;ָʾ���򽫱����ص�7c00h������������ı��ڴ�Ķ���ƫ��
hang:
	jmp hang		;dead loop
	times 510-($-$$) db 0	;fill up 510 bytes with zeros
	db 0x55
	db 0xAA			;boot signature 0xAA55
