.section .data
code1: .ascii "000111\0\0\0"
a1: .long 512
b1: .long -1023
c1: .long 1265
f1: .long 0
code2: .ascii "000222\0\0\0"
a2: .long 256809
b2: .long -1023
c2: .long 2780
f2: .long 0
code3: .ascii "000333\0\0\0"
a3: .long 2513
b3: .long 1265
c3: .long 1023
f3: .long 0
code4: .ascii "000444\0\0\0"
a4: .long 512
b4: .long -1023
c4: .long 1265
f4: .long 0
code5: .ascii "555555\0\0\0"
a5: .long 2513
b5: .long 1265
c5: .long 1023
f5: .long 0
code6: .ascii "666666\0\0\0"
a6: .long 256800
b6: .long -2000
c6: .long 1000
f6: .long 0
.equ num,6
highf: .fill 75,1,0
midf: .fill 75,1,0
lowf: .fill 75,1,0
tol_cnt: .byte 0,0,0,0

.section .text
.global main
main:
    mov $a1,%esi
    first:
        cmpb $num,tol_cnt
        je next
        call calculate
        movslq %esi,%rcx
        sub $9,%rcx
        push %rcx
        cmp $0,%eax
        jz to_z
        jl to_l
        jg to_g
        to_z:
            movzbq tol_cnt+2,%rcx
            addb $25,tol_cnt+2
            add $midf,%rcx
            jmp second
        to_l:
            movzbq tol_cnt+3,%rcx
            addb $25,tol_cnt+3
            add $lowf,%rcx
            jmp second
        to_g:
            movzbq tol_cnt+1,%rcx
            addb $25,tol_cnt+1
            add $highf,%rcx
    second:
        push %rcx
        push $25
        call copy_data
        pop %rcx
        pop %rcx
        pop %rcx
        mov tol_cnt,%cl
        inc %cl
        mov %cl,tol_cnt
        add $25,%esi
        jmp first
    next:
    mov $1,%eax
    mov $0,%ebx
    int $0x80

.type calculate @function
calculate:
    mov (%esi),%eax
    mov $5,%ebx
    imul %ebx
    shl $32,%rdx
    mov %eax,%edx
    mov $0,%rbx
    movslq 4(%esi),%rbx
    add %rbx,%rdx
    movslq 8(%esi),%rbx
    sub %rbx,%rdx
    mov $100,%rbx
    add %rbx,%rdx
    sar $7,%rdx
    mov %edx,12(%esi)
    cmp $100,%edx
    jz assz
    jg assg
    jl assl
    assz:
        mov $0,%eax
        ret
    assg:
        mov $1,%eax
        ret
    assl:
        mov $-1,%eax
        ret
.type copy_data @function
copy_data:
    mov %rsp,%rbp
    mov 8(%rbp),%ecx
    mov 16(%rbp),%ebx # dst
    mov 24(%rbp),%eax # src
    m4:
        cmp $4,%ecx
        jl m1
        sub $4,%ecx
        mov (%eax,%ecx),%edx
        mov %edx,(%ebx,%ecx)
        jmp m4
    m1:
        cmp $1,%ecx
        jl rt
        sub $1,%ecx
        mov (%eax,%ecx),%dl
        mov %dl,(%ebx,%ecx)
        jmp m1
    rt:
        ret
