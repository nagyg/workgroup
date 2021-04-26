@echo off
cls

set "crt_dir=%~dp0"
for %%I in ("%crt_dir%\..") do set "WGPATH=%%~fI"
set "rand=%RANDOM%"

set "prefsdir=%APPDATA%\Blackmagic Design\Fusion\Profiles\Default"

echo ===================================     SET WGPATH      ===================================
echo(
echo WGPATH : [%WGPATH%]
echo(
rem ############################################################################
	copy %WGPATH%\setup\.rcfiles\FIX2021\.bash_profile %USERPROFILE% /a
rem ############################################################################
echo(
echo =================================== FUSION PROFILES DIR ===================================
echo(
echo  %prefsdir% 
echo(
echo ===========================================================================================
echo(
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