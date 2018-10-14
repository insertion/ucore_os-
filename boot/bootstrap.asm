	;; bootstrap.asm
	;; CPU start in real mode,and BIOS load code at address 0000��7c00
	org 7c00h		;ָʾ���򽫱����ص�7c00h������������ı��ڴ�Ķ���ƫ��
	xor ax,ax		;��ax�Ĵ�����0
	mov ds,ax		;filled DS with 0

	mov si,msg		;���ַ����ĵ�ַд��si��ַ�Ĵ���
	cld			;����df��־�Ĵ���
	
cg_loop:
	lodsb			;��DS:SI����byteд��AL
	test al,al		;al�ﱣ�����ַ���msg���һ����0
	jz loop
	mov ah,0x0e		;0x0e ���ܺź�0x13���ܺţ��ԼĴ���ʹ�÷�ʽ��һ��
	mov bh,0		;
	int 0x10		;bios�ṩ���жϷ��񣬹��ܺ�13λ��ʾ����
loop:
	jmp loop		;dead loop
msg:	db 'hello world',13,10,0 ;msg is the address of "hello wrld"
	times 510-($-$$) db 0	;fill up 510 bytes with zeros
	db 0x55
	db 0xAA			;boot signature 0xAA55
