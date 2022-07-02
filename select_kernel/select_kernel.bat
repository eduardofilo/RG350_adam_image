@echo off

:again
   echo     1: RG280V
   echo     2: RG280M
   echo     3: RG350/P
   echo     4: RG350M
   echo     5: PocketGo2 v2
   echo     6: RG300X
   set /p answer=Select your console model:
   if /i "%answer:~,1%" EQU "1" (
	set dir=rg280v
	goto install_kernel
   )
   if /i "%answer:~,1%" EQU "2" (
    set dir=rg280m
	goto install_kernel
   )
   if /i "%answer:~,1%" EQU "3" (
    set dir=rg350
	goto install_kernel
   )
   if /i "%answer:~,1%" EQU "4" (
    set dir=rg350m
	goto install_kernel
   )
   if /i "%answer:~,1%" EQU "5" (
    set dir=pocketgo2v2
	goto install_kernel
   )
   if /i "%answer:~,1%" EQU "6" (
    set dir=rg300x
	goto install_kernel
   )
   echo Please type 1, 2, 3, 4, 5 or 6
   goto again

:install_kernel
	copy %dir%\uzImage.bin .
	copy %dir%\uzImage.bin.sha1 .

echo Done.
echo Now eject the card safelly from your computer and insert in your %dir%.
pause
exit /b
