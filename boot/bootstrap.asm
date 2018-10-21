	;; bootstrap.asm
	;; CPU start in real mode,and BIOS load code at address 0000��7c00
section .text			;��������

	org 7c00h		;ָʾ���򽫱����ص�7c00h������������ı��ڴ�Ķ���ƫ��
	xor ax,ax		;��ax�Ĵ�����0
	mov ds,ax		;filled DS with 0

	mov ss,ax		;call need use stack,so we should set ss and sp
	mov sp,0x9c00		;stack is down grown

	cld			;����df��־�Ĵ���
	mov ax,0xb800		; text video memory address
	mov es,ax		;����Ŀ��λ���ַλ��ʾ���ڴ��ַ
	mov si,msg		;����Դ��ַ����Դ��ַ�ڴ��п������ݵ�video memory��
	mov di,[pos]		;��DI��ʼ��Ϊ0

	;; ��Ļ���ڴ�ӳ������/�����0xb8000��ʼ��֧��25�У�ÿ�а���80��ASCII�ַ�
	;; �ô洢����ÿ��Ԫ���������ֽ���ɣ���һ���ֽڱ�ʾASCII�룬�ڶ����ֱ�ʾ����
	;; ���Ե�ǰ����ֽڱ�ʾ����ɫ�������ֽڱ�ʾǰ��ɫ
cprint:				;��ӡһ���ַ�
	mov ah,0x0f		;�����ַ���ʾ����
.loop:
	lodsb			;��DS��SI���ƶ�һ��byte�� al��si��1
	test al,al		;����Ƿ񵽴�ĩβ��״̬�Ĵ������ı�
	jz end
	stosw			;��ax�ƶ���ES��DI�У�����������Ҫ����DI��DI�����ַ���ʾ��λ��
	jump .loop		;�ӵ��ʾ�ֲ���ţ�ȫ��Ӧ����ȫ�ֱ��.�ֲ����

	
	;; �������������BIOS�ṩ�Ĺ�����ʵ���ַ�����ӡ
	;; 
ch_loop:
	mov si,msg		;���ַ����ĵ�ַд��si��ַ�Ĵ���
ch_loop_j:	
	lodsb			;��DS:SI����byteд��AL
	test al,al		;al�ﱣ�����ַ���msg���һ����0
	jz end
	mov ah,0x0e		;0x0e ���ܺź�0x13���ܺţ��ԼĴ���ʹ�÷�ʽ��һ��
	mov bh,0		;
	int 0x10		;bios�ṩ���жϷ��񣬹��ܺ�13λ��ʾ����
	jmp ch_loop_j
end:
	jmp end		;dead loop

section .data			 ;�������ݶ�
msg:	db 'hello world',13,10,0 ;msg is the address of "hello wrld"
pos:	db  0			 ;�ַ���ʾ��λ�ã�������Ļ�ڴ���ƫ��
	times 510-($-$$) db 0	;fill up 510 bytes with zeros,$��ʾָ���ַ��$$��ʾ��ǰ�������ʼ��ַ
	db 0x55
	db 0xAA			;boot signature 0xAA55

	
	
