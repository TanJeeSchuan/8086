[autoexec]
MOUNT C C:\8086
C:
cls
ECHO 8086 ASSEMBLY...
masm.exe ASMFiles\P2\P2Q1.asm built\P2Q1\P2Q1 built\P2Q1\P2Q1 built\P2Q1\P2Q1;
link.exe built\P2Q1\P2Q1.obj built\P2Q1\P2Q1;
P2Q1.exe
pause
exit
