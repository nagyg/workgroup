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
	del %WGPATH%\.licenses 2>nul
	replace %WGPATH%\setup\.rcfiles\.licenses %WGPATH% /a
rem ############################################################################
echo(
echo ===========================================================
goto exit

:exit
echo(
echo Press any key to EXIT
pause >nul
exit