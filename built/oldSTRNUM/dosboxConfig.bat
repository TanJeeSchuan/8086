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
masm.exe ASMFiles\A\oldSTRNUM.asm built\oldSTRNUM\oldSTRNUM built\oldSTRNUM\oldSTRNUM built\oldSTRNUM\oldSTRNUM;
link.exe built\oldSTRNUM\oldSTRNUM.obj built\oldSTRNUM\oldSTRNUM;
oldSTRNUM.exe
pause
exit
