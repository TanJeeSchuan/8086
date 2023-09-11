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
masm.exe ASMFiles\A\addC.asm built\addC\addC built\addC\addC built\addC\addC;
link.exe built\addC\addC.obj built\addC\addC;
addC.exe
pause
exit
