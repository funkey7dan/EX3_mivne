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
    #rdx holds i, rcx holds j

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
        #cmpq %r8,%rsi  # check if the current char is the old one
        #jne .L51
        #movb %dl,(%r11,%rcx,1) #replace the char
        addq $1,%rdx #increment the i index
        cmpq %rcx,%rdx #check if index i greater than j
        jle .LOOP_CPY
    movq %r11,%rax
    popq %r12
    popq %r11
    ret
#Pstring* swapCase(Pstring* pstr);
swapCase:

    ret
#int pstrijcmp(Pstring* pstr1, Pstring* psrt2, char i, char j);
pstrijcmp:
    ret