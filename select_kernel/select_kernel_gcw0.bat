@echo off

:again
   echo     1: PocketGo2 v1
   echo     2: GCW-Zero
   set /p answer=Select your console model:
   if /i "%answer:~,1%" EQU "1" (
	set dir=pocketgo2v1
	goto install_kernel
   )
   if /i "%answer:~,1%" EQU "2" (
    set dir=gcw0
	goto install_kernel
   )
   echo Please type 1 or 2
   goto again

:install_kernel
	copy %dir%\uzImage.bin .
	copy %dir%\uzImage.bin.sha1 .

echo Done.
echo Now eject the card safely from your computer and insert in your %dir%.
pause
exit /b
