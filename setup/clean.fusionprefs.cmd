@echo off
cls

set "crt_dir=%~dp0"
for %%I in ("%crt_dir%\..") do set "WGPATH=%%~fI"
set "rand=%RANDOM%"

set "prefsdir=%APPDATA%\Blackmagic Design\Fusion\Profiles\Default"

echo =================================== FUSION PROFILES DIR ===================================
echo(
echo  %prefsdir% 
echo(
echo ===========================================================================================
echo(
rem ############################################################################
	if exist "%prefsdir%\Fusion.prefs" (
	rename "%prefsdir%\Fusion.prefs" Fusion.prefs_BACKUP%rand%
	echo  BACKUP Fusion.prefs
	) else (
	echo  NOT EXIST Fusion.prefs )
rem ############################################################################
	replace "%WGPATH%\blackmagic\masterprefs\Fusion.prefs" "%prefsdir%" /a
rem ############################################################################
	if exist "%prefsdir%\workgroup.prefs" (
	del "%prefsdir%\workgroup.prefs" 
	echo  REMOVE workgroup.prefs )
rem ############################################################################
echo(
echo ===========================================================================================
goto exit

:exit
echo(
echo Press any key to EXIT
pause >nul
exit