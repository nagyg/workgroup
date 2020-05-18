@echo off
cls

set "crt_dir=%~dp0"
for %%I in ("%crt_dir%\..") do set "WGPATH=%%~fI"

echo ===========================================================
echo(
echo WGPATH : [%WGPATH%]
echo(
echo ==================== ExecutionPolicy ======================

powershell -command "& {Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser -Force}"
powershell -command "& {Get-ExecutionPolicy -List}"

echo ===========================================================
echo                        REGEDIT
echo ===========================================================
echo HKEY_CLASSES_ROOT\Directory\shell\SafeDir\command
reg add "HKEY_CLASSES_ROOT\Directory\shell\SafeDir\command" /t REG_SZ /d "C:\Windows\system32\WindowsPowerShell\v1.0\powershell.exe -NoLogo -File %WGPATH%\mpro\context_menu\SafeDir.ps1 \"%%L\""
echo(

echo HKEY_LOCAL_MACHINE\SOFTWARE\Classes\*\shell\Safe\Command
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\*\shell\Safe\Command" /t REG_SZ /d "C:\Windows\system32\WindowsPowerShell\v1.0\powershell.exe -NoLogo -File %WGPATH%\mpro\context_menu\Safe.ps1 \"%%L\""
echo(

echo HKEY_CLASSES_ROOT\Directory\shell\Version\command
reg add "HKEY_CLASSES_ROOT\Directory\shell\Version\command" /t REG_SZ /d "C:\Windows\system32\WindowsPowerShell\v1.0\powershell.exe -NoLogo -File %WGPATH%\mpro\context_menu\Version.ps1 \"%%L\""
echo(

:exit
echo Press any key to EXIT
pause >nul
exit