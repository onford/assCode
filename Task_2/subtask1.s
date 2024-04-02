.section .data
buf1: .byte 0,1,2,3,4,5,6,7,8,9
buf2: .fill 10,1,0
buf3: .fill 10,1,0
buf4: .fill 10,1,0
message: .ascii "Press any key to begin!\n"
length = . - message



.section .text
.global main
main:
mov $buf1,%esi
mov $buf2,%edi
mov $buf3,%ebx
mov $buf4,%edx
mov $10,%ecx

mov $4,%eax
mov $1,%ebx
mov $message,%ecx
mov $length,%edx
int $0x80

mov $3,%eax
mov $0,%ebx
mov $message,%ecx
mov $length,%edx
int $0x80

mov $buf4,%edx
mov $10,%ecx
mov $buf3,%ebx

lopa: mov (%esi),%al
mov %al,(%edi)
inc %al
mov %al,(%ebx)
add $3,%al
mov %al,(%edx)
inc %esi
inc %edi
inc %ebx
inc %edx
dec %ecx
jnz lopa
mov $1,%eax
movl $0,%ebx
int $0x80
