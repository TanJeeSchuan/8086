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
masm.exe ASMFiles\A\bcdInput.asm built\bcdInput\bcdInput built\bcdInput\bcdInput built\bcdInput\bcdInput;
link.exe built\bcdInput\bcdInput.obj built\bcdInput\bcdInput;
bcdInput.exe
pause
exit
