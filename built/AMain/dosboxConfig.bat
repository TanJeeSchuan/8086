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
masm.exe ASMFiles\A\AMain.asm built\AMain\AMain built\AMain\AMain built\AMain\AMain;
link.exe built\AMain\AMain.obj built\AMain\AMain;
AMain.exe
pause
exit
