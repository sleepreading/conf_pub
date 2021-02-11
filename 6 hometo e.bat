@echo OFF
setlocal EnableDelayedExpansion

set homedsk=D:

echo.
echo --- Change Default User Home to "%homedsk%\home"
ping -n 2 localhost>nul
set v3={374DE290-123F-4565-9164-39C4925E467B};{4C5C32FF-BB9D-43B0-B5B4-2D72E54EAAA4};{56784854-C6CB-462B-8169-88E350ACB882}
set v3=!v3!;{7D1D3A04-DEBB-4115-95CF-2F29DA2920DA};{BFB9D5E0-C6A9-404C-B2B2-AE6DB6AF4968}
set v3=!v3!;Desktop;Favorites;My Music;My Pictures;My Video;Personal
set d[0]="%homedsk%\home\Downloads"& set d[1]="%homedsk%\home\Saved Games"& set d[2]="%homedsk%\home\Contacts"&set d[3]="%homedsk%\home\Searches"
set d[4]="%homedsk%\home\Links"& set d[5]="%homedsk%\home\Desktop"&set d[6]="%homedsk%\home\Favorites"& set d[7]="%homedsk%\home\Music"
set d[8]="%homedsk%\home\Pictures"& set d[9]="%homedsk%\home\Videos"& set d[10]="%homedsk%\home\Documents"
for /l %%i in (0 1 10) do (
    for /f "tokens=1* delims=;" %%a in ("!v3!") do (
        call rd /s /q "%userprofile%\%%d[%%i]%%" >nul 2>nul
        call reg add "hkcu\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v "%%a" /d "%%d[%%i]%%" /f >nul 2>nul
        call reg add "hkcu\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v "%%a" /d "%%d[%%i]%%" /f >nul 2>nul
        set v3=%%b
    )
)
md "%homedsk%\demo" "%homedsk%\misc" "%homedsk%\work" "%homedsk%\soft" >nul 2>nul
md "%homedsk%\home\Contacts" "%homedsk%\home\Links" "%homedsk%\home\Favorites" "%homedsk%\home\Searches" "%homedsk%\home\Videos" >nul 2>nul
md "%homedsk%\home\Documents" "%homedsk%\home\Music" "%homedsk%\home\Downloads" "%homedsk%\home\Pictures" "%homedsk%\home\Saved Games" >nul 2>nul

echo done!


pause