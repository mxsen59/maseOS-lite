org 0
bits 16     

section .text
	global _start

call 	clear

clear:
  	pusha
	mov 	ah, 0x00
	mov 	al, 0x03 
	int 	0x10
	mov 	ah, 06h
	xor 	cx, cx
	xor 	al, al
	mov 	dx, 0x184F 
	mov 	bh, 0x1e 
	int 	10h
	mov 	si, header
	call 	print_string
	mov 	si, title
	call 	print_string
 
_start:
	mov 	si, prompt
	call 	print_string
	mov 	di, buffer
	call 	get_string
	mov 	si, buffer
	cmp 	byte [si], 0  
	je 		_start    
	mov 	si, buffer
	mov 	di, cmd_help  
	call 	strcmp
	jc 		.help
	mov 	si, buffer
	mov 	di, cmd_shutdown  
	call 	strcmp
	jc 		.shutdown
	mov 	si, buffer
	mov 	di, cmd_reboot  
	call 	strcmp
	jc 		.reboot
	mov 	si, buffer
	mov 	di, cmd_install  
	call 	strcmp
	jc 		.install
	mov 	si, buffer
	mov 	di, cmd_clear  
	call 	strcmp
	jc 		.clear
	mov 	si, buffer
	mov 	di, cmd_newfile  
	call 	strcmp
	jc 		.new_file
	mov 	si, badcommand
	call 	print_string 
	jmp 	_start 

.help:
	mov 	si, msg_help
	call 	print_string
	jmp 	_start

.shutdown:
	mov 	ax, 0x1000
	mov 	ax, ss
	mov 	sp, 0xf000
	mov 	ax, 0x5307
	mov 	bx, 0x0001
	mov 	cx, 0x0003
	int 	0x15

.reboot:
	mov 	ds, ax
	mov 	ax, 0000
	mov 	[0472], ax
	jmp 	0xffff:000

.install:
	
	.install_kernel:
		mov 	bx, 0x1000
		mov 	es, bx
		mov 	dh, 0x00
		mov 	dl, 0x80
		mov 	ch, 0x00
		mov 	cl, 0x03
		mov 	ah, 0x03
    	mov 	al, 0x01
		int 	0x13
		cmp 	ah, 0x00
		je 		.install_error
		mov 	ah, 0x0e
		mov 	al, "!"
		mov 	bx, 0
		int 	0x10
		jmp 	.reboot

		.install_error:
			mov 	si, msg_error
			call	print_string
			jmp		_start
	
.clear:
  	jmp 	clear

.new_file:
	mov 	si, msg_newfile
	call 	print_string
	mov 	di, buffer
	call 	get_string
	mov 	si, buffer
	cmp 	byte [si], 0
	jmp 	_start

header db "Kernel loaded v0.0.1", 0x0a, 0x0d, 0
title db 'maseOS', 13, 10, 0x0a, 0x0d, 0

badcommand db 'Invalid command.', 0x0a, 0x0d, 0
prompt db '>> ', 0
cmd_help db 'help', 0
cmd_shutdown db "shutdown", 0
cmd_clear db "clear", 0
cmd_reboot db "reboot", 0
cmd_install db "install", 0
cmd_newfile db "nf", 0
msg_newfile db "Filename: ", 0
msg_error db "ERROR", 13, 10, 0
msg_help db 'Commands: help, clear, reboot, shutdown, install, nf', 0x0a, 0x0d, 0
buffer: times 2 db 0

print_string:
	lodsb        
	or 		al, al 
	jz 		.done   
	mov 	ah, 0x0E
	int 	0x10      
	jmp 	print_string

.done:
  	ret

get_string:
  	xor 	cl, cl

.loop:
	mov 	ah, 0
	int 	0x16   
	cmp 	al, 0x08    
	je 		.backspace   
	cmp 	al, 0x0D  
	je 		.done      
	cmp 	cl, 0x3F  
	je 		.loop      
	mov 	ah, 0x0E
	int 	0x10      
	stosb  
	inc 	cl
	jmp 	.loop

.backspace:
	cmp 	cl, 0	
	je 		.loop	
	dec 	di
	mov 	byte [di], 0	
	dec 	cl		
	mov 	ah, 0x0E
	mov 	al, 0x08
	int 	10h		
	mov 	al, ' '
	int 	10h		
	mov 	al, 0x08
	int 	10h		
	jmp 	.loop	

.done:
	mov 	al, 0	
	stosb
	mov 	ah, 0x0E
	mov 	al, 0x0D
	int 	0x10
	mov 	al, 0x0A
	int 	0x10		
	ret

strcmp:

.loop:
	mov 	al, [si]   
	mov 	bl, [di]   
	cmp 	al, bl     
	jne 	.notequal  
	cmp 	al, 0  
	je 		.done   
	inc 	di     
	inc 	si     
	jmp 	.loop 

.notequal:
	clc  
	ret

.done: 	
	stc  
	ret

  times 512-($-$$) db 0
  dw 0xaa55