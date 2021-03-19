org 0x7c00

boot:
    mov 	bx, 0x1000
    mov 	es, bx
    mov 	bx, 0x00
    mov 	dh, 0x00
    mov 	dl, 0x00
    mov 	ch, 0x00
    mov 	cl, 0x02           

read_disk_1:
    mov 	ah, 0x02
    mov 	al, 0x01
    int 	0x13
    jc 		read_disk_1
    mov 	ax, 0x1000
    cmp     ax, 0x1000
    jne     disk_error
    mov 	ds, ax
    mov 	es, ax
    mov 	fs, ax
    mov 	gs, ax
    mov 	ss, ax
    mov     ah, 0x0e
    mov     al, "$"
    mov     bx, 0
    int     0x10
    mov 	cx, 36

    .delay:
        hlt
        loop 	.delay

    jmp 	0x1000:0x00

disk_error:
    mov     ah, 0x0e
    mov     al, "!"
    mov     bx, 0
    int     0x10
    hlt

times 510 - ($-$$) db 0
dw 0xaa55