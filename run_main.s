    //***REMOVED*** Daniel Bronfman

.section .rodata
d:
       .string "%d"
s:
       .string "%s"
print:
        .string "out: = %s\n"


.section .text
.globl run_main
.type run_main, @function
run_main:
        # we will save pointer to pstring1 in r10 and to pstring2 in r11
        pushq %rbp
        movq %rsp, %rbp
        subq $528,%rsp # allocate stack for 2 structs and int
        #initialize first pstring
        #first scanf for ps1
        movq $d,%rdi # put the format into 1st argument
        leaq -8(%rbp),%rsi #allocate bytes for scanf
        subq $16,%rsp #allign the stack before calling
        movq $0,%rax # we shall clear the value of the return register
        call scanf #get length
        pushq -8(%rbp) # push the output of the scanf to the stack
        #second scanf for ps1
        movq $s,%rdi # put the string format into 1st argument
        leaq -256(%rbp),%rsi #allocate bytes for scanf
        subq  $8,%rsp #allign the stack before calling
        movq $0,%rax # we shall clear the value of the return register
        call   scanf #get the string
        pushq -8(%rbp) # push the output of the scanf to the stack
        #initialize second pstring
        #first scanf for ps2
        movq $d,%rdi # put the format into 1st argument
        leaq -8(%rbp),%rsi #allocate bytes for scanf
        subq $8,%rsp #allign the stack before calling
        movq $0,%rax # we shall clear the value of the return register
        call scanf #get length
        pushq -8(%rbp) # push the output of the scanf to the stack
        #second scanf for ps2
        movq $s,%rdi # put the string format into 1st argument
        leaq -256(%rbp),%rsi #allocate bytes for scanf
        subq  $8,%rsp #allign the stack before calling
        movq $0,%rax # we shall clear the value of the return register
        call   scanf #get the string
        pushq -8(%rbp) # push the output of the scanf to the stack
        #scanf for opt
        movq $d,%rdi # put the string format into 1st argument
        leaq -8(%rbp),%rsi #allocate bytes for scanf
        subq  $8,%rsp #allign the stack before calling
        movq $0,%rax # we shall clear the value of the return register
        call   scanf #get the string
        #pushq -8(%rbp) # push the output of the scanf to the stack
        movq -8(%rbp),%rdi
        leaq -265(%rbp),%rsi
        leaq -530(%rbp),%rdx
        call run_func
        # function finish
        addq $528,%rsp
        movq %rbp,%rsp
        popq %rbp
        ret

