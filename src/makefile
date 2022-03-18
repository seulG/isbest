%.bin: %.asm
	nasm -f bin $< -o $@
master.img: boot.bin
	yes | bximage -q -hd=16 -func=create -sectsize=512 -imgmode=flat master.img
	dd if=boot.bin of=master.img bs=512 count=1 conv=notrunc

.PHONY:clean
clean:
	rm -rf *.bin
	rm -rf *.img
	rm -rf *.ini
.PHONY:bochs
bochs: master.img
	bochs -q