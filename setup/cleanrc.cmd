@echo off
cls

set "crt_dir=%~dp0"
for %%I in ("%crt_dir%\..") do set "WGPATH=%%~fI"
set "rand=%RANDOM%"

echo ======================= SET WGPATH ========================
echo(
echo WGPATH : [%WGPATH%]
echo(
echo ===========================================================
echo                        BASH PROFILE
echo ===========================================================
echo(
rem ############################################################################
	if exist %USERPROFILE%\.bash_profile (
		rename %USERPROFILE%\.bash_profile .bash_profile_BACKUP%rand%
		echo BACKUP %USERPROFILE%\.bash_profile_BACKUP%rand% )
	replace %WGPATH%\setup\.rcfiles\.bash_profile %USERPROFILE% /a
rem ############################################################################
	if exist %USERPROFILE%\.bash_userfile (
		rename %USERPROFILE%\.bash_userfile .bash_userfile_BACKUP%rand%
		echo BACKUP %USERPROFILE%\.bash_userfile_BACKUP%rand% )
rem ############################################################################
	if exist %USERPROFILE%\.bashrc (
		rename %USERPROFILE%\.bashrc .bashrc_BACKUP%rand%
		echo BACKUP %USERPROFILE%\.bashrc_BACKUP%rand% )
rem ############################################################################
echo(
echo ===========================================================
goto exit

:exit
echo(
echo Press any key to EXIT
pause >nul
exit