@echo off
setlocal EnableDelayedExpansion


echo.
echo --- Add some system environment variables
ping -n 2 localhost>nul
if not defined path reg add hkcu\Environment /f /v path /t reg_expand_sz /d d:\usr\bin;d:\lib\mingw\bin;d:\lib\Python27;d:\lib\Python27\Scripts; >nul
if not defined mingw reg add hkcu\Environment /f /v mingw /d d:\lib\mingw >nul
if not defined python reg add hkcu\Environment /f /v python /d d:\lib\Python27 >nul

pause