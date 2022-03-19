[org 0x7c00]

; 将屏幕设置为文本模式
mov ax, 3
int 0x10

; 初始化寄存器
mov ax, 0
mov ds, ax
mov es, ax
mov ss, ax
; 栈初始化到0x7c00
mov sp, 0x7c00

mov si, booting
call print

mov edi, 0x1000; 读取到目标内存
mov ecx, 2 ; 起始扇区
mov bl, 4 ; 读取扇区个数

call read_disk

cmp word [0x1000], 0x55aa
jnz error

jmp 0:0x1002

jmp $

read_disk:
    ;设置读取扇区
    ;设置读取扇区个数
    mov dx, 0x1f2
    mov al, bl
    out dx, al

    ; 设置起始扇区0-7位
    inc dx
    mov al, cl
    out dx, al

    inc dx
    shr ecx, 8
    mov al, cl
    out dx, al

    inc dx
    shr ecx, 8
    mov al, cl
    out dx, al

    inc dx
    shr ecx, 8
    and cl, 0b0000_1111 ; 高四位扇区地址
    mov al, 0b1110_0000 ; lbr 模式
    or al, cl
    out dx, al

    inc dx
    mov al, 0x20 ; 读
    out dx, al

    ; 清空ecx
    xor ecx, ecx
    ; 读写扇区数量
    mov cl, bl

    .read:
        push cx
        call .waits
        call .reads
        pop cx
        loop .read

    ret

    .waits:
        mov dx, 0x1f7
        .check:
            in al, dx
            jmp $+2
            jmp $+2
            jmp $+2
            and al, 0b_1000_1000
            cmp al, 0b_0000_1000
            jnz .check ; 硬盘繁忙或者数据未准备完毕
        ret

    .reads:
        mov dx, 0x1f0
        mov cx, 256; 一个扇区256word，需要in的次数
        .readw:
            in ax, dx
            jmp $+2
            jmp $+2
            jmp $+2

            mov [edi], ax
            add edi, 2

            loop .readw
        ret


print:
    mov ah, 0x0e
.next:
    mov al, [si]
    cmp al, 0
    jz .done
    int 0x10
    inc si
    jmp .next
.done:
    ret

booting:
    db "Booting isBest...", 10, 13, 0 ;10 换行 13\r光标移动到开头 0字符串结束

error:
    mov si, .msg
    call print
    hlt
    jmp $
    .msg db "Booting Error...", 10, 13, 0

times 510 - ($ - $$) db 0

dw 0xaa55
