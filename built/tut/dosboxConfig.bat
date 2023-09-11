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
masm.exe ASMFiles\tut.asm built\tut\tut built\tut\tut built\tut\tut;
link.exe built\tut\tut.obj built\tut\tut;
tut.exe
pause
exit
