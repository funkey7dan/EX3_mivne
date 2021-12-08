.section .text
.global pstrlen
.global swapCase
.global replaceChar
.global pstrijcmp
.global pstrijcpy

# char pstrlen(Pstring* pstr);
pstrlen:
    movq (%rdi,4),%rax
    ret
# Pstring* replaceChar(Pstring* pstr, char oldChar, char newChar);
replaceChar:
    movq $0,%rcx # rcx will be index j , set to zero
    # save register values
    pushq %r11
    pushq %r12
    # clear the value of registers
    xor %r11,%r11
    xor %r12,%r12

    #save string part of pstr
    movq %rdi,%r11
    addq $8,%r11

    movb (%rdi),%r12b # save len to register

    #for loop
    .LOOP_RPLC:
        movzbq (%r11,%rcx,1), %r8 # read pstr[j] into r8
        cmpq %r8,%rsi  # check if the current char is the old one
        jne .L41
        movb %dl,(%r11,%rcx,1) #replace the char
    .L41:
        addq $1,%rcx #increment the index
        cmpq %rcx,%r12
        jne .LOOP_RPLC
    movq %r11,%rax
    popq %r12
    popq %r11
    ret

#Pstring* pstrijcpy(Pstring* dst, Pstring* src, char i, char j);
pstrijcpy:

    # save register values
    pushq %r11
    pushq %r12
    # clear the value of registers
    xor %r11,%r11
    xor %r12,%r12
    #save string part of pstr1
    movq %rdi,%r11
    addq $8,%r11
    #save string part of pstr2
    movq %rsi,%r12
    addq $8,%r12
    #for loop
    .LOOP_CPY:
        movzbq (%r12,%rdx,1), %r8  # read src[i] into temp register
        movb  %r8b,(%r11,%rdx,1)
        addq $1,%rdx #increment the i index
        cmpq %rcx,%rdx #check if index i greater than j
        jle .LOOP_CPY
    movq %r11,%rax
    popq %r12
    popq %r11
    ret

#Pstring* swapCase(Pstring* pstr);
swapCase:
        movq $0,%rcx # rcx will be index j , set to zero
        # save register values
        pushq %r11
        pushq %r12

        # clear the value of registers
        xor %r11,%r11
        xor %r12,%r12

        #save string part of pstr
        movq %rdi,%r11
        addq $8,%r11

        movb (%rdi),%r12b # save len to register
        #for loop
        .LOOP_SWP:
            movzbq (%r11,%rcx,1), %r8 # read pstr[j] into r8
            # check if the current char is upper \ lower \ none
            cmpq $97,%r8 #check if pstr[j] is lower
            jge .LOWER #if bigger, it's lower or none

            cmpq $65,%r8 #check if pstr[j] is lower
            jge .UPPER #if bigger, it's upper or none

            jmp .L61 #it's not a letter, jump to next step

        .LOWER:
            cmpq $122,%r8 #check if pstr[j] is lower
            jg .L61 #if bigger, it's not a letter
            subq $32,%r8
            movb  %r8b,(%r11,%rcx,1) #replace the char with upper
            jmp .L61
        .UPPER:
            cmpq $90,%r8 #check if pstr[j] is lower
            jg .L61 #if bigger, it's not a letter
            addq $32,%r8
            movb  %r8b,(%r11,%rcx,1) #replace the char with lower
            jmp .L61
        .L61:
            addq $1,%rcx #increment the index
            cmpq %rcx,%r12
            jne .LOOP_SWP
        movq %r11,%rax #save result
        #restore registers
        popq %r12
        popq %r11
        ret

#int pstrijcmp(Pstring* pstr1, Pstring* psrt2, char i, char j);
pstrijcmp:

        # save register values
        pushq %r10
        pushq %r11
        pushq %r12
        # clear the value of registers
        xor %r10,%r10
        xor %r11,%r11
        xor %r12,%r12

        # set the counter
        movq $0,%r10

        #save string part of pstr1
        movq %rdi,%r11
        addq $8,%r11
        #save string part of pstr2
        movq %rsi,%r12
        addq $8,%r12
        #for loop
        .LOOP_CMPR:
            movzbq (%r12,%rdx,1), %r8  # read src[i] into temp register
            movzbq (%r12,%rdx,1), %r9 # read dest[i] into temp register
            cmpq %r8,%r9 #compare values
            je .L71 # if they are equal, go to incrementing index
            jg .INCRS # if greater increase counter
            jl .DCRS # if lesser decrease counter
            .INCRS:
            inc %r10 #increment counter and go to next index
            jmp .L71
            .DCRS:
            dec %r10
            jmp .L71
            .L71:
            addq $1,%rdx #increment the i index
            cmpq %rcx,%rdx #check if index i greater than j
            jle .LOOP_CMPR
        cmpq $0,%r10 #check the counter
        jl .L # if less than 0, set return to -1
        movq $0,%r10
        je .EXIT # if zero, return 0
        .G:
            movq $1,%rax
            jmp .EXIT
        .L:
            movq $-1,%rax
            jmp .EXIT
        .EXIT:
            #restore used registers
            popq %r12
            popq %r11
            popq %r10
            ret