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
c:
       .string "%c"
print:
        .string "out: = %s\n"
default_format:
        .string "invalid option!\n"
len_print:
        .string "first pstring length: %d, second pstring length: %d\n"
rplc_print:
        .string "old char: %c, new char: %c, first string: %s, second string: %s\n"
cpy_print:
swp_print:
        .string "length: %d, string: %s\n"
cmpr_print:
        .string "compare result: %d\n"

.section .text
.globl run_func
.type run_func, @function
run_func:
        #function start
        pushq %rbp
        #save registers
        pushq %r10
        pushq %r11
        #save passed args
        pushq %rdx #push pstr2 to stack
        pushq %rsi #push pstr1 to stack
        movq %rsp, %rbp
        # swith case
        subq $51,%rdi #check index
        cmpq $10,%rdi #check if out of bounds
        ja .L8
        jmp *.VALUES(,%rdi,8)
#case 50 or 60 length
.L3:
    movq %rsi,%rdi # move the pointer to pstring1 from the 2nd arg to the 1st
    call pstrlen
    movq %rax,%r10 # save the returned size of pstring1
    movq %rdx,%rdi # move the pointer to pstring2 from the 3rd arg to the 1st
    call pstrlen
    movq %rax,%r10 # save the returned size of pstring2
    subq $8,%rsp #allign the stack before calling
    movq $0,%rax # we shall clear the value of the return register
    movq $len_print,%rdi # put the format into 1st argument
    movq %r10,%rsi #put the len of pstring1 to the 2nd arg
    movq %r11,%rdx #put the len of pstring2 to the 3rd arg
    call printf
    jmp .END
#Case 52 replace
.L4:
    #first scanf
    movq $c,%rdi # put the format into 1st argument
    lea -1(%rbp),%rsi #allocate bytes for scanf
    subq $16,%rsp #allign the stack before calling
    movq $0,%rax # we shall clear the value of the return register
    call scanf #get the old char
    movb -1(%rbp),%sil #move the old char to 2nd arg
    #second scanf
    movq $c,%rdi # put the format into 1st argument
    lea -1(%rbp),%rsi #allocate bytes for scanf
    subq $16,%rsp #allign the stack before calling
    movq $0,%rax # we shall clear the value of the return register
    call scanf #get the new char
    movb -1(%rbp),%sil #move the new char to 3rd arg
    # replace chars in both strings
    popq %rdi #pop the first pstr to the first arg to call replaceChar
    call replaceChar
    popq %rdi #pop the second pstr to the first arg to call replaceChar
    pushq %rax # save the pointer returned from replace on stack
    call replaceChar
    pushq %rax # save the pointer returned from replace on stack
    #print the result
    movq $rplc_print,%rdi # put the format into 1st argument
    subq  $16,%rsp #allign the stack before calling
    movq  $0,%rax # we shall clear the value of the return register
    popq %r8 # put pstr2 to 5th argument
    popq %rcx # put pstr1 to 4th argument
    # 1st arg format 2nd old char 3rd new char 4th pstr1 5th pstr2
    call  printf #print the string
    jmp .END
#Case 53 copy
.L5:
    jmp .END
#Case 54
.L6:
    jmp .END
#Case 55
.L7:
    jmp .END
# default case
.L8:
    movq $default_format,%rdi # put the format into 1st argument
    #subq  $16,%rsp #allign the stack before calling
    movq  $0,%rax # we shall clear the value of the return register
    call   printf #get the string
    jmp .END
.END:
        #function end
        movq %rbp,%rsp
        popq %rbp
        subq  $8,%rsp
        ret
        
    