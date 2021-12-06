.section .rodata

.align #8 Align address to multiple of 8
.VALUES:
    .quad .L3 #Case 50 pstrlen
    .quad .L4 #Case 52
    .quad .L5 #Case 53
    .quad .L6 #Case 54
    .quad .L7 #Case 55
    .quad .L3 #Case 60
    .quad .L8 # Default
d:
       .string "%d"
s:
       .string "%s"
print:
        .string "out: = %s\n"
default_format:
        .string "invalid option!\n"

.section .text
.globl run_func
.type run_func, @function
run_func:
        #function start
        pushq %rbp
        movq %rsp, %rbp
        # swith case
        subq $51,%rdi #check index
        cmpq $10,%rdi #check if out of bounds
        ja .L8
        jmp *.VALUES(,%rdi,8)
#case 50 or 60
.L3:
    jmp .END
#Case 52
.L4:
    jmp .END
#Case 53
.L5:
    jmp .END
#Case 54
.L6:
    jmp .END
#Case 55
.L7:
    jmp .END
.L8:
    movq $default_format,%rdi # put the format into 1st argument
    subq  $8,%rsp #allign the stack before calling
    movq  $0,%rax # we shall clear the value of the return register
    call   printf #get the string
.END:
        #function end
        movq %rbp,%rsp
        popq %rbp
        ret
        
    