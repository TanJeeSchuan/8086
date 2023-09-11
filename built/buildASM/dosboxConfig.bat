[cpu]
core=auto
cputype=auto
cycles=auto
cycleup=10
cycledown=20
[autoexec]
MOUNT C C:\8086
C:
cls
ECHO 8086 ASSEMBLY...
masm.exe .vscode\buildASM.bat built\buildASM\buildASM built\buildASM\buildASM built\buildASM\buildASM;
link.exe built\buildASM\buildASM.obj built\buildASM\buildASM;
buildASM.exe
pause
exit
