[cpu]
core=auto
cputype=auto
cycles=max
cycleup=10
cycledown=20
[autoexec]
MOUNT C C:\8086
C:
cls
ECHO 8086 ASSEMBLY...
masm.exe ASMFiles\A\exitPROC.asm built\exitPROC\exitPROC built\exitPROC\exitPROC built\exitPROC\exitPROC;
link.exe built\exitPROC\exitPROC.obj built\exitPROC\exitPROC;
exitPROC.exe
pause
exit
