	;; bootstrap.asm
	;; CPU start in real mode,and BIOS load code at address 0000：7c00
section .text			;定义代码段

	org 7c00h		;指示程序将被加载到7c00h处，编译器会改变内存的段内偏移
	xor ax,ax		;将ax寄存器清0
	mov ds,ax		;filled DS with 0

	mov ss,ax		;call need use stack,so we should set ss and sp
	mov sp,0x9c00		;stack is down grown

	cld			;设置df标志寄存器
	mov ax,0xb800		; text video memory address
	mov es,ax		;设置目标段基地址位显示器内存地址
	mov si,msg		;设置源变址，从源变址内存中拷贝数据到video memory中
	mov di,[pos]		;将DI初始化为0

	;; 屏幕的内存映射输入/输出从0xb8000开始，支持25行，每行包含80个ASCII字符
	;; 该存储器中每个元素由两个字节组成，第一个字节表示ASCII码，第二个字表示属性
	;; 属性的前半个字节表示背景色，后半个字节表示前景色
cprint:				;打印一个字符
	mov ah,0x0f
	;; 0 - Black, 1 - Blue, 2 - Green, 3 - Cyan, 4 - Red, 5 - Magenta, 6 - Brown,
	;; 7 - Light Grey, 8 - Dark Grey, 9 - Light Blue, 10/a - Light Green,
	;; 11/b - Light Cyan, 12/c - Light Red, 13/d - Light Magenta, 14/e - Light Brown,
	;; 15/f – White.
.loop:
	lodsb			;从DS：SI中移动一个byte到 al，si加1
	stosw			;将ax移动到ES：DI中，所有我们需要设置DI，DI控制字符显示的位置
	jump .loop		;加点表示局部标号，全名应该是全局标号.局部标号
	
	
ch_loop:
	mov si,msg		;将字符串的地址写入si变址寄存器
ch_loop_j:	
	lodsb			;将DS:SI处的byte写入AL
	test al,al		;al里保存着字符，msg最后一个是0
	jz loop
	mov ah,0x0e		;0x0e 功能号和0x13功能号，对寄存器使用方式不一样
	mov bh,0		;
	int 0x10		;bios提供的中断服务，功能号13位显示服务
	jmp ch_loop_j
loop:
	jmp loop		;dead loop

section .data			 ;定义数据段
msg:	db 'hello world',13,10,0 ;msg is the address of "hello wrld"
pos:	db  0			 ;字符显示的位置，即在屏幕内存中偏移
	times 510-($-$$) db 0	;fill up 510 bytes with zeros,$表示指令地址，$$表示当前代码段起始地址
	db 0x55
	db 0xAA			;boot signature 0xAA55

	
	
