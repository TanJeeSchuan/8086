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
masm.exe ASMFiles\A\HF.asm built\HF\HF built\HF\HF built\HF\HF;
link.exe built\HF\HF.obj built\HF\HF;
HF.exe
pause
exit
