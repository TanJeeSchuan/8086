[autoexec]
MOUNT C C:\8086
C:
cls
ECHO 8086 ASSEMBLY...
masm.exe ASMFiles\MCD.ASM built\MCD\MCD built\MCD\MCD built\MCD\MCD;
link.exe built\MCD\MCD.obj built\MCD\MCD;
MCD.exe
pause
exit
