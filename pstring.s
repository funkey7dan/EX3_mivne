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