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
    pushq %r12 # save register value
    movq (%rdi),%r12 # save len to register
    #for loop
    .LOOP_RPLC:
        movb (%rdi,%rcx,1), %r8b # read pstr[j] into r8b
        cmpb %r8b,%sil  # check if the current char is the old one
        jne .L41
        movb %dl,(%rdi,%rcx,1) #replace the char
    .L41:
        addq $1,%rcx #increment the index
        cmpq %rcx,%r12
        jne .LOOP_RPLC
    movq %rdi,%rax
    popq %r12
    ret
#Pstring* pstrijcpy(Pstring* dst, Pstring* src, char i, char j);
pstrijcpy:
    ret
#Pstring* swapCase(Pstring* pstr);
swapCase:
    ret
#int pstrijcmp(Pstring* pstr1, Pstring* psrt2, char i, char j);
pstrijcmp:
    ret