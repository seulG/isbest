[org 0x1000]

dw 0x55aa; 魔数 

mov si, loading

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

loading:
    db "Loading isBest...", 10, 13, 0 ;10 换行 13\r光标移动到开头 0字符串结束