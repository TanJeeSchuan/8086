[autoexec]
MOUNT C C:\8086
C:
cls
ECHO 8086 ASSEMBLY...
masm.exe ASMFiles\A\STRNUMv1.asm built\STRNUMv1\STRNUMv1 built\STRNUMv1\STRNUMv1 built\STRNUMv1\STRNUMv1;
link.exe built\STRNUMv1\STRNUMv1.obj built\STRNUMv1\STRNUMv1;
STRNUMv1.exe
pause
exit
