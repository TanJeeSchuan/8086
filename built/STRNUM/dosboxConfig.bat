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
masm.exe ASMFiles\A\STRNUM.asm built\STRNUM\STRNUM built\STRNUM\STRNUM built\STRNUM\STRNUM;
link.exe built\STRNUM\STRNUM.obj built\STRNUM\STRNUM;
STRNUM.exe
pause
exit
