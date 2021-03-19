.PHONY: build
build:
	nasm ./src/kernel.asm -f bin -o ./build/kernel.bin
	nasm ./src/boot/bootloader.asm -f bin -o ./build/bootloader.bin
	cat ./build/bootloader.bin ./build/kernel.bin > ./build/maseOS-lite.bin
	python3 to_floppy.py ./build/maseOS-lite.bin ./dist/maseOS-lite.flp 

run:
	sudo qemu-system-x86_64 -fda ./build/maseOS-lite.bin