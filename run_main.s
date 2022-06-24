#    Daniel Bronfman

.section .rodata
d:
       .string "%d"
s:
       .string "%s"
print_s:
        .string "out: = %s\n"
print_d:
        .string "out: = %d\n"
null_terminator:
        .string "\0"

.section .text
.globl run_main
.type run_main, @function
run_main:
        # we will save pointer to pstring1 in r10 and to pstring2 in r11
        pushq %rbp
        movq %rsp, %rbp
        subq $544,%rsp # allocate stack for 2 structs and int

        #initialize first pstring
        #first scanf for ps1
        movq $d,%rdi # put the format into 1st argument
        leaq -544(%rbp),%rsi #allocate bytes for scanf
        ##subq $16,%rsp #allign the stack before calling
        xor %rax,%rax # we shall clear the value of the return register
        call scanf #get length

        #second scanf for ps1
        movq $s,%rdi # put the string format into 1st argument
        leaq -536(%rbp),%rsi #allocate 255+1 bytes for scanf
        #subq  $16,%rsp #allign the stack before calling
        xor %rax,%rax # we shall clear the value of the return register
        call   scanf #get the string

        #initialize second pstring
        #first scanf for ps2
        movq $d,%rdi # put the format into 1st argument
        leaq -280(%rbp),%rsi #allocate bytes for scanf
        ##subq $16,%rsp #allign the stack before calling
        xor %rax,%rax # we shall clear the value of the return register
        call scanf #get length

        #second scanf for ps2
        movq $s,%rdi # put the string format into 1st argument
        leaq -272(%rbp),%rsi #allocate bytes for scanf
        ##subq $16,%rsp #allign the stack before calling
        xor %rax,%rax # we shall clear the value of the return register
        call   scanf #get the string

        #scanf for opt
        movq $d,%rdi # put the string format into 1st argument
        leaq -16(%rbp),%rsi #allocate bytes for scanf
        #subq  $16,%rsp #allign the stack before calling
        xor %rax,%rax # we shall clear the value of the return register
        call   scanf #get the option

        #function call
        movq -16(%rbp),%rdi # put option into 1st argument
        leaq -544(%rbp),%rsi # put the address of the first struct into 2nd argument
        leaq -280(%rbp),%rdx # put the address of the second struct into 3rd argument
        call run_func

        # function finish
        addq $528,%rsp # restore the memory
        movq %rbp,%rsp #restore stack
        popq %rbp
        ret

