@echo off
color b
::Option conditional for backing up or restoring file
:init
	IF EXIST C:\Users\%USERNAME%\Documents\ERBACKUP\ (goto proceed) ELSE (mkdir C:\Users\%USERNAME%\Documents\ERBACKUP\ & goto proceed)
	:proceed
		SET /p option="backup (b), restore (r), or clean (c)?: "
		IF /i "%option%" == "b" GOTO backup
		IF /i "%option%" == "r" GOTO restore
		IF /i "%option%" == "c" GOTO clean
		echo Unknown Option & GOTO init
::backup code chunk

:backup
	cd C:\Users\%USERNAME%\Documents\ERBACKUP\
	::(1)copy file to backup folder (2)user choice of renaming file (3)execute the rename (4)go to end of script
	xcopy /s %APPDATA%\EldenRing\76561198061163030\ER0000.sl2 C:\Users\%USERNAME%\Documents\ERBACKUP
	set /p name="What would you like to call your backup?: "
	tar -czvf %name%.tar ER0000.sl2 & del /Q ER0000.sl2
	rename %name%.tar %name%
	GOTO end

::restore code chunk

:restore
	cd C:\Users\%USERNAME%\Documents\ERBACKUP\
	::(1)display backup folder directory (2)user choice which file to restore (3)rename select file to restore format
	::(4)rename old save file to OLD format (5)copy restore file to game save directory (6)delete reformatted restore file from backup directory
	dir /OD C:\Users\%USERNAME%\Documents\ERBACKUP\
	SET /p file="Which file would you like to restore?: "
	IF EXIST C:\Users\%USERNAME%\Documents\ERBACKUP\%file% (goto cont) ELSE (echo ERROR & goto end)	
	:cont 
		cd C:\Users\%USERNAME%\Documents\ERBACKUP\
		rename %file% %file%.tar
		tar -xzvf %file%.tar
		rename %APPDATA%\EldenRing\76561198061163030\ER0000.sl2 ER0000.OLD
		move %APPDATA%\EldenRing\76561198061163030\ER0000.OLD C:\Users\%USERNAME%\Documents\ERBACKUP\
		tar -czvf %random%.tar ER0000.OLD
		del /Q ER0000.OLD
		xcopy /s C:\Users\%USERNAME%\Documents\ERBACKUP\ER0000.sl2 %APPDATA%\EldenRing\76561198061163030\
		del C:\Users\%USERNAME%\Documents\ERBACKUP\ER0000.sl2
		rename %file%.tar %file%
		GOTO end

::clean code chunk

:clean
	set /p cleanchoice="Are you sure you want to clean your save directory? (y)es or (n)o: "
	IF /i "%cleanchoice%" == "n" GOTO end
	IF /i "cleanchoice%" == "Y" GOTO doclean
	
:doclean
	del /Q C:\Users\%USERNAME%\Documents\ERBACKUP\*.tar

:end
	echo Operation Complete, Press Any Key to Continue...
	pause > nul
