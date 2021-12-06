.section .rodata
d:
       .string "%d"
s:
       .string "%s"
print:
        .string "out: = %s\n"

.section .text
.globl run_func
.type run_func, @function
run_func:
        pushq %rbp
        movq %rsp, %rbp
        
    