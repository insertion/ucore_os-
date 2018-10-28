	;; bootstrap.asm
	;; CPU start in real mode,and BIOS load code at address 0000：7c00
section .text			;定义代码段

	org 7c00h		;指示程序将被加载到7c00h处，编译器会改变内存的段内偏移
	xor ax,ax		;将ax寄存器清0
	mov ds,ax		;filled DS with 0
	mov ss,ax
	mov sp,0xc900
	cld			;设置df标志寄存器
	mov ax,0xb800		; text video memory address
	mov es,ax		;设置目标段基地址位显示器内存地址


	call install		;装载驱动键盘
	;; 屏幕的内存映射输入/输出从0xb8000开始，支持25行，每行包含80个ASCII字符
	;; 该存储器中每个元素由两个字节组成，第一个字节表示ASCII码，第二个字表示属性
	;; 属性的前半个字节表示背景色，后半个字节表示前景色
cprint:				;打印一个字符
	mov ah,0x0f		;设置字符显示属性
	mov si,msg		;设置源变址，从源变址内存中拷贝数据到video memory中
	mov di,[pos]		;将DI初始化为0
.loop:
	lodsb			;从DS：SI中移动一个byte到 al，si加1
	test al,al		;检测是否到达末尾，状态寄存器被改变
	jz end
	stosw			;将ax移动到ES：DI中，所有我们需要设置DI，DI控制字符显示的位置
	jmp .loop		;加点表示局部标号，全名应该是全局标号.局部标号
	
end:
	call hex2str
	jmp cprint		
	;; ;; jmp end			;dead loop

	;;下面代码未执行
	
install:			;
	;; 安装中断，BIOS提供的9号中断时键盘中断，现在要把我们的中断处理例程安装进入9号中断的位置
	push es
	cli			;在安装中断程序是首先需要关中断
	mov bx,0x09		;选择中断号
	shl bx,2		;中断处理例程的地址是 中断号*4
	xor ax,ax		;ax清零
	mov es,ax		;中断处理例程的段地址
	mov [es:bx],word keyhandle 	; 首先装载中断处理程序的偏移地址16位，
	mov [es:bx+2],cs		; 然后装载中断处理程序的段地址16位
	sti
	pop es
	ret
	;; 按下键盘会触发硬件中断，下面是中断处理函数
	;; 键盘会发送一个中断信号给CPU,与此同时，键盘会在指定端口(0x60) 输出一个数值，这个数值对应按键的扫描码(make code)，
	;; 当按键弹起时，键盘又给端口输出一个数值，这个数值叫断码(break code).
keyhandle:

	in al,0x60		;按下或者松开键盘，CPU会触发一个中断，然后键盘控制器会向0x60端口输入数据
	mov bx,[index]		;记录buff的位置
	inc bx			;index 累加
	mov [index],bx		;
	mov [buff],al	;将键盘码字移入缓冲区保存
	mov al,0x20
	out 0x20,al 		; 发送EOI给中断控制器，否则不能继续接收中断
	
	iret			;中断返回，会普通的call返回不一样,所以使用iret
hex2str:			;将一个16进制的数转化成str
	mov al,[buff]
	mov ah,al		;保存值
	and al,0x0f		;取低四位
	;; 要判断是否大于9，小于9转化成ascii码需要加48
	;; 大于9转换成ascii码需要加55
	cmp al,0x0A
	jnc .str
	add al,48
	jmp .over
.str:
	add al,55
.over:
	and ah,0xf0
	shr ah,4
	cmp ah,0x0a
	jnc .str1
	add ah,48
	jmp .over1
.str1:
	add ah,55
.over1:
	mov bx,[index]
	shl bx,1
	mov word [msg+bx],ax
	ret
	
buff:	db 0x4b
pos:	db 0			 ;字符显示的位置，即在屏幕内存中偏移
str:	db 0,0,0,0
index:	db 0,0
msg:	db '000000000000000000000000000000000000000000000000000000000000000',13;msg is the address of "hello wrld"
	times 510-($-$$) db 0	;fill up 510 bytes with zeros,$表示指令地址，$$表示当前代码段起始地
	db 0x55
	db 0xAA			;boot signature 0xAA55
	
