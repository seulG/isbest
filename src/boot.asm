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

xchg bx, bx

mov si, booting
call print

jmp $

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

times 510 - ($ - $$) db 0

dw 0xaa55
