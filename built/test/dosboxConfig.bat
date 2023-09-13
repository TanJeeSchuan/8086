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
masm.exe ASMFiles\test.asm built\test\test built\test\test built\test\test;
link.exe built\test\test.obj built\test\test;
test.exe
pause
exit
