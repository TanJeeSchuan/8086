[autoexec]
MOUNT C C:\8086
C:
cls
ECHO 8086 ASSEMBLY...
masm.exe ASMFiles\P5\P5Q1.asm built\P5Q1\P5Q1 built\P5Q1\P5Q1 built\P5Q1\P5Q1;
link.exe built\P5Q1\P5Q1.obj built\P5Q1\P5Q1;
P5Q1.exe
pause
exit
