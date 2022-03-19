[org 0x1000]

dw 0x55aa; 魔数 

mov si, loading
call print

xchg bx, bx

;检测内存
detect_memory:
    ;清空ebx
    xor ebx, ebx
    mov ax, 0
    ; [es:di] 结构体的缓存位置
    mov es, ax
    mov edi, ards_buffer
    mov edx, 0x534d4150 ; 固定签名

.next:
    ; 子功能号
    mov eax, 0xe820
    mov ecx, 20


    ; 0x15系统调用  
    int 0x15

    ;CF置位表示出错
    jc error
    ; 将缓存指针指向下一个结构体
    add di, cx

    ; 计数
    inc word [ards_count]

    cmp ebx, 0
    jnz .next
    
    mov si, detecting
    call print
    xchg bx, bx

    mov cx, [ards_count]
    mov si, 0
.show:
    mov eax, [ards_buffer + si]
    mov ebx, [ards_buffer + si + 8]
    mov edx, [ards_buffer + si + 16]
    add si, 20
    xchg bx, bx
    loop .show

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

detecting:
    db "Detecting Memory Success...", 10, 13, 0 ;10 换行 13\r光标移动到开头 0字符串结束


error:
    mov si, .msg
    call print
    hlt
    jmp $
    .msg db "Loading Error...", 10, 13, 0

ards_count:
    dw 0
ards_buffer:
    

