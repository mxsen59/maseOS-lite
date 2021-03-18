org 0x7c00

boot:
    mov 	bx, 0x1000
    mov 	es, bx
    mov 	bx, 0x00
    mov 	dh, 0x00
    mov 	dl, 0x00
    mov 	ch, 0x00
    mov 	cl, 0x02

load_kernel:
    mov 	ah, 0x02
    mov 	al, 0x01
    int 	0x13
    jc 		load_kernel
    mov 	ax, 0x1000
    mov 	ds, ax
    mov 	es, ax
    mov 	fs, ax
    mov 	gs, ax
    mov 	ss, ax
    mov 	cx, 18

    .delay:
        hlt
        loop 	.delay

    jmp 	0x1000:0x00

times 510 - ($-$$) db 0
dw 0xaa55