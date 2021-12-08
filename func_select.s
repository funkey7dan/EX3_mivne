#   ***REMOVED*** Daniel Bronfman

.section .rodata

.align #8 Align address to multiple of 8
.VALUES:
    .quad .L3 #Case 50 pstrlen
    .quad .L8 #Case 51 fall through
    .quad .L4 #Case 52
    .quad .L5 #Case 53
    .quad .L6 #Case 54
    .quad .L7 #Case 55
    .quad .L8 #Case 56 fall through
    .quad .L8 #Case 57 fall through
    .quad .L8 #Case 58 fall through
    .quad .L8 #Case 58 fall through
    .quad .L3 #Case 60
    .quad .L8 # Default
#scanf formats
d:
       .string "%d"
s:
       .string " %s"
c:
       .string " %c"
#printf formats
print:
        .string "out: = %s\n"
default_format:
        .string "invalid option!\n"
invalid_format:
        .string "invalid input!\n"
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

        # swith case
        subq $50,%rdi #check index
        cmpq $10,%rdi #check if out of bounds
        ja .L8 # jump using table
        jmp *.VALUES(,%rdi,8)
#case 50 or 60 length
.L3:
    # save registers
    pushq %r10
    pushq %r11
    movq %rsi,%rdi # move the pointer to pstring1 from the 2nd arg to the 1st
    call pstrlen
    movq %rax,%r10 # save the returned size of pstring1
    movq %rdx,%rdi # move the pointer to pstring2 from the 3rd arg to the 1st
    call pstrlen
    movq %rax,%r11 # save the returned size of pstring2

    #print
    xor %rax,%rax # we shall clear the value of the return register
    movq $len_print,%rdi # put the format into 1st argument
    leaq (%r10),%rsi #put the len of pstring1 to the 2nd arg
    leaq (%r11),%rdx #put the len of pstring2 to the 3rd arg
    call printf
    popq %r11
    popq %r10
    jmp .END

#Case 52 replace chars
.L4:
    #save stack
    pushq %rbp
    movq %rsp, %rbp
    subq $32,%rsp #get stack space

    #save registers
    pushq %r10
    pushq %r11
    pushq %r12
    pushq %r13
    pushq %r14
    pushq %r15

    #save passed args
    movq %rdx,%r13 #save pstr2
    movq %rsi,%r12 #save pstr1

    #first scanf
    mov $s,%rdi # put the format into 1st argument
    leaq -8(%rbp),%rsi #allocate bytes for scanf
    xor %rax,%rax # we shall clear the value of the return register
    call scanf #get the old char
    movzbq -8(%rbp),%r14 #save the old char to temp register to move to 2nd arg afterwards padded with zeros to prevent clutter

    #second scanf
    movq $s,%rdi # put the format into 1st argument
    leaq -17(%rbp),%rsi #allocate bytes for scanf
    xor %rax,%rax # we shall clear the value of the return register
    call scanf 
    movzbq -17(%rbp),%r15 #move the new char to 3rd arg padded with zeros to prevent clutter

    # replace chars in both strings
    movq %r14,%rsi # put the old char to 2nd arg
    movq %r15,%rdx # put the new char to 3rd arg
    movq %r12,%rdi #move the first pstr to the 1st to call replaceChar
    call replaceChar
    movq %rax,%r10 # save the pointer returned from replace
    movq %r13,%rdi #move the second pstr to the first arg to call replaceChar
    call replaceChar
    movq %rax,%r11 # save the pointer returned from replace on stack

    #print the result
    movq $rplc_print,%rdi # put the format into 1st argument
    subq  $16,%rsp #allign the stack before calling
    movq %r11,%r8 # put changed pstr2 to 5th argument
    movq %r10,%rcx # put changed pstr1 to 4th argument
    # 1st arg format 2nd old char 3rd new char 4th pstr1 5th pstr2
    xor  %rax,%rax # we shall clear the value of the return register
    call  printf #print the string

    # restore saved registers
    popq %r15
    popq %r14
    popq %r13
    popq %r12
    popq %r11
    popq %r10
    movq %rbp,%rsp #restore stack
    popq %rbp
    jmp .END
#Case 53 copy
.L5:
        #save stack
        pushq %rbp
        movq %rsp, %rbp
        subq $32,%rsp #get stack space

        #save registers
        pushq %r12
        pushq %r13
        pushq %r14
        pushq %r15

        #save passed args
        movq %rsi,%r12 #save pstr1
        movq %rdx,%r13 #save pstr2


        #first scanf
        mov $d,%rdi # put the format into 1st argument
        leaq -8(%rbp),%rsi #allocate bytes for scanf
        xor %rax,%rax # we shall clear the value of the return register
        call scanf #get i from user
        movzbq -8(%rbp),%r14 # save i to register

        #second scanf
        movq $d,%rdi # put the format into 1st argument
        leaq -17(%rbp),%rsi #allocate bytes for scanf
        xor %rax,%rax # we shall clear the value of the return register
        call scanf #get j from user
        movzbq -17(%rbp),%r15 #save j to register

        #check passed values
        cmpq %r15,%r14 #check if i greater than j
        jg .INVALID_CPY
        # we count indexes from zero, and length from 1, so we decrease the real length by 1 to get bounds
        movq (%r12),%r8
        movq (%r13),%r9
        dec %r8
        dec %r9
        # check if passed indices greater than length
        cmpq %r8,%r14
        jg .INVALID_CPY
        cmpq %r8,%r15
        jg .INVALID_CPY
        cmpq %r9,%r14
        jg .INVALID_CPY
        cmpq %r9,%r15
        jg .INVALID_CPY

        #function
        movq %r12,%rdi # move first string to 1st arg, as dest
        movq %r13,%rsi # move second string to 2nd arg, as src
        movq %r14, %rdx #move i to 3rd arg
        movq %r15, %rcx #move j to 4th arg

        call pstrijcpy
        movq %rax,%r14 #save the returned pointer

        #get len of pstr1
        call pstrlen #on the pstr1 which is in %rdi
        movq %r14,%rdx # move pstr1 to 3rd arg
        movq %rax,%rsi # save the returned size of pstring1 in 2nd arg

        #printf the changed string
        movq $cpy_print,%rdi # move the format for printf to 1st arg
        movq  $0,%rax # we shall clear the value of the return register
        call  printf #print the string

        #get len of pstr2
        movq %r13,%rdi
        addq $8,%r13
        movq %r13,%rdx # move pstr2 to 3rd arg
        call pstrlen #on the pstr2
        movq %rax,%rsi # save the returned size of pstring1 in 2nd arg

        #printf the result
        movq $cpy_print,%rdi # move the format for printf to 1st arg
        movq  $0,%rax # we shall clear the value of the return register
        call  printf #print the string

        # restore saved registers
        popq %r15
        popq %r14
        popq %r13
        popq %r12

        movq %rbp,%rsp #restore stack
        popq %rbp
        jmp .END
#Case 54 swapCase
.L6:
    #save registers
    pushq %r10
    pushq %r11
    pushq %r12
    pushq %r13
    pushq %r14

    #save passed args
    movq %rsi,%r12 #save pstr1
    movq %rdx,%r13 #save pstr2

    #function
    movq %r12,%rdi # pop pstr1 to 1st arg
    call swapCase
    movq %rax,%r10 #save the returned string1
    movq %r13,%rdi # pop pstr2 to 1st arg
    call swapCase
    movq %rax,%r14 #save the returned string2

    ##print result

    #print for str 1
    #get len of pstr1
    movq %r12,%rdi
    call pstrlen #on the original pstr1 which is in %rdi
    movq %r10,%rdx # move changed pstr1 to 3rd arg
    movq %rax,%rsi # save the returned size of pstring1 in 2nd arg

    #printf the result
    movq $swp_print,%rdi # move the format for printf to 1st arg
    #subq  $16,%rsp #allign the stack before calling
    xor  %rax,%rax # we shall clear the value of the return register
    call   printf #print the string

    #print for str 2
    #get len of pstr1
    movq %r13,%rdi #put old psrt2 to 1st arg
    #call pstrlen #on the old pstr2 which is in %rdi
    movq %r14,%rdx # move changed pstr2 to 3rd arg
    #movq %rax,%rsi # save the returned size of pstring1 in 2nd arg
    movq (%r13),%rsi

    #printf the result
    movq $swp_print,%rdi # move the format for printf to 1st arg
    #subq  $16,%rsp #allign the stack before calling
    xor  %rax,%rax # we shall clear the value of the return register
    call   printf #print the string

    # restore saved registers
    popq %r14
    popq %r13
    popq %r12
    popq %r11
    popq %r10

    jmp .END
#Case 55 compare
.L7:
    #save stack
    pushq %rbp
    movq %rsp, %rbp
    subq $32,%rsp #get stack space

    #save registers
    pushq %r12
    pushq %r13
    pushq %r14
    pushq %r15

    #save passed args
    movq %rdx,%r13 #save pstr2
    movq %rsi,%r12 #save pstr1

    #first scanf
    mov $d,%rdi # put the format into 1st argument
    leaq -8(%rbp),%rsi #allocate bytes for scanf
    xor %rax,%rax # we shall clear the value of the return register
    call scanf #get i from user
    movzbq -8(%rbp),%r14 # save i to register

    #second scanf
    movq $d,%rdi # put the format into 1st argument
    leaq -17(%rbp),%rsi #allocate bytes for scanf
    xor %rax,%rax # we shall clear the value of the return register
    call scanf #get j from user
    movzbq -17(%rbp),%r15 #save j to register

    # we count indexes from zero, and length from 1, so we decrease the real length by 1 to get bounds
    movq (%r12),%r8
    movq (%r13),%r9
    dec %r8
    dec %r9
    #check passed values
    cmpq %r15,%r14 #check if i greater than j
    jg .INVALID_CMP
    # check if passed indices greater than length
    cmpq %r8,%r14
    jg .INVALID_CMP
    cmpq %r8,%r15
    jg .INVALID_CMP
    cmpq %r9,%r14
    jg .INVALID_CMP
    cmpq %r9,%r15
    jg .INVALID_CMP

    #function
    movq %r12,%rdi # move first string to 1st arg, as dest
    movq %r13,%rsi # move second string to 2nd arg, as src
    movq %r14, %rdx #move i to 3rd arg
    movq %r15, %rcx #move j to 4th arg

    call pstrijcmp
    movq %rax,%rsi #save the returned value to second arg

    #printf the compare result
    movq $cmpr_print,%rdi # move the format for printf to 1st arg
    movq  $0,%rax # we shall clear the value of the return register
    call  printf #print the string

    # restore saved registers
    popq %r15
    popq %r14
    popq %r13
    popq %r12

    movq %rbp,%rsp #restore stack
    popq %rbp
    jmp .END
.INVALID_CMP:
    movq $invalid_format,%rdi # put the format into 1st argument
    #subq  $16,%rsp #allign the stack before calling
    movq  $0,%rax # we shall clear the value of the return register
    call   printf #get the string
    movq $-2,%rsi #save the returned value to second arg
    #printf the compare result
    movq $cmpr_print,%rdi # move the format for printf to 1st arg
    movq  $0,%rax # we shall clear the value of the return register
    call  printf #print the string
    # restore saved registers
    popq %r15
    popq %r14
    popq %r13
    popq %r12

    movq %rbp,%rsp #restore stack
    popq %rbp
    jmp .END


# default case
.L8:
    movq $default_format,%rdi # put the format into 1st argument
    #subq  $16,%rsp #allign the stack before calling
    movq  $0,%rax # we shall clear the value of the return register
    call   printf #get the string
    jmp .END
#invalid input
.INVALID_CPY:
    # pstr1 is in %r12 pstr2 is in %r13

    #print invalid message
    movq $invalid_format,%rdi # put the format into 1st argument
    #subq  $16,%rsp #allign the stack before calling
    movq  $0,%rax # we shall clear the value of the return register
    call   printf #print the string

    ## print len and string of both pstr
    #get len of pstr1
    movq %r12,%rdi
    call pstrlen #on the pstr1 which is in %rdi
    addq $8,%r12
    movq %r12,%rdx # move pstr1 to 3rd arg
    movq %rax,%rsi # save the returned size of pstring1 in 2nd arg

    #printf the first string and len
    movq $cpy_print,%rdi # move the format for printf to 1st arg
    movq  $0,%rax # we shall clear the value of the return register
    call  printf #print the string

    #get len of pstr2
    movq %r13,%rdi
    addq $8,%r13
    movq %r13,%rdx # move pstr2 to 3rd arg
    call pstrlen #on the pstr2
    movq %rax,%rsi # save the returned size of pstring1 in 2nd arg

    #printf the result
    movq $cpy_print,%rdi # move the format for printf to 1st arg
    movq  $0,%rax # we shall clear the value of the return register
    call  printf #print the string

    # restore saved registers
    popq %r15
    popq %r14
    popq %r13
    popq %r12

    movq %rbp,%rsp #restore stack
    popq %rbp
    jmp .END

.END:
        #function end
        ret
        
    