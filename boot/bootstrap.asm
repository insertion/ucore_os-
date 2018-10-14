	;; bootstrap.asm
	;; CPU start in real mode,and BIOS load code at address 0000：7c00
	org 7c00h		;指示程序将被加载到7c00h处，编译器会改变内存的段内偏移
	xor ax,ax		;将ax寄存器清0
	mov ds,ax		;filled DS with 0

	mov si,msg		;将字符串的地址写入si变址寄存器
	cld			;设置df标志寄存器
	
cg_loop:
	lodsb			;将DS:SI处的byte写入AL
	test al,al		;al里保存着字符，msg最后一个是0
	jz loop
	mov ah,0x0e		;0x0e 功能号和0x13功能号，对寄存器使用方式不一样
	mov bh,0		;
	int 0x10		;bios提供的中断服务，功能号13位显示服务
loop:
	jmp loop		;dead loop
msg:	db 'hello world',13,10,0 ;msg is the address of "hello wrld"
	times 510-($-$$) db 0	;fill up 510 bytes with zeros
	db 0x55
	db 0xAA			;boot signature 0xAA55
