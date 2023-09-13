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
masm.exe ASMFiles\test2.asm built\test2\test2 built\test2\test2 built\test2\test2;
link.exe built\test2\test2.obj built\test2\test2;
test2.exe
pause
exit
