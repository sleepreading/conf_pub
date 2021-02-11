@echo off
setlocal EnableDelayedExpansion


ver | find "5." >nul
if %errorlevel%==0 (
    echo Your System is XP, it's really too old!
    ping -n 2 localhost>nul
    set osver=1
) else (
    set osver=0
)

echo.
echo --- show some icons on desktop: 'My Compute' 'Network' ....
ping -n 2 localhost>nul
:: My Computer
reg add hkcu\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel /f /v {20D04FE0-3AEA-1069-A2D8-08002B30309D} /t reg_dword /d 0 >nul
:: User's Files or My Documents
if %osver%==0 (
    reg add hkcu\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel /f /v {59031a47-3f72-44a7-89c5-5595fe6b30ee} /t reg_dword /d 0 >nul
) else (
    reg add hkcu\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel /f /v {450D8FBA-AD25-11D0-98A8-0800361B1103} /t reg_dword /d 0 >nul
)
:: Network
if %osver%==0 (
    reg add hkcu\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel /f /v {F02C1A0D-BE21-4350-88B0-7367FC96EF3C} /t reg_dword /d 0 >nul
) else (
    reg add hkcu\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel /f /v {208D2C60-3AEA-1069-A2D7-08002B30309D} /t reg_dword /d 0 >nul
)
:: Control Panel
if %osver%==0 (
    reg add hkcu\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel /f /v {5399E694-6CE5-4D6C-8FCE-1D8870FDCBA0} /t reg_dword /d 0 >nul
)

echo.
echo --- Customize Taskbar: 'Use small icon' 'direction' ....
ping -n 2 localhost>nul
set v1=Start_SearchPrograms Start_SearchFiles Start_ShowMyGames Start_ShowMyPics Start_ShowHelp Start_ShowUser Start_TrackDocs Start_TrackProgs HideFileExt
for %%i in (%v1%) do reg add hkcu\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /f /v %%i /t reg_dword /d 0 >nul
reg add hkcu\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /f /v Start_PowerButtonAction /t reg_dword /d 2 >nul
reg add hkcu\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /f /v TaskbarSmallIcons /t reg_dword /d 1 >nul
reg add hkcu\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /f /v Start_ShowRun /t reg_dword /d 1 >nul

echo.
echo --- black wallpaper ...
ping -n 2 localhost>nul
reg add "hkcu\Control Panel\Desktop" /v Wallpaper /t reg_sz /d "" /f >nul
Bginfo.exe "%myfiles%\bginfo.bgi" /timer:0 /silent /NOLICPROMPT

echo.
echo --- Add 'Empty Recycle' to the right menu...
ping -n 2 localhost>nul
if %osver%==1 (
    reg add hkcr\Directory\Background\shellex\ContextMenuHandlers\Delete_File /v "" /t reg_sz /d {645FF040-5081-101B-9F08-00AA002F954E} /f >nul 2>nul
) else (
    reg add hklm\Software\Classes\Directory\Background\shell\Trash /v CommandStateHandler /t reg_sz /d {c9298eef-69dd-4cdd-b153-bdbc38486781} /f >nul 2>nul
    reg add hklm\Software\Classes\Directory\Background\shell\Trash /v Description /t reg_sz /d @shell32.dll,-31332 /f >nul 2>nul
    reg add hklm\Software\Classes\Directory\Background\shell\Trash /v Icon /t reg_sz /d shell32.dll,-254 /f >nul 2>nul
    reg add hklm\Software\Classes\Directory\Background\shell\Trash /v MUIVerb /t reg_sz /d @shell32.dll,-10564 /f >nul 2>nul
    reg add hklm\Software\Classes\Directory\Background\shell\Trash\command /v DelegateExecute /t reg_sz /d {48527bb3-e8de-450b-8910-8c4099cb8624} /f >nul 2>nul
)

echo.
echo --- add .lnk to exec ...
ping -n 2 localhost>nul
reg query "hklm\System\CurrentControlSet\Control\Session Manager\Environment" /v pathext 2>nul | find /i ".lnk" >nul || (
    reg add "hklm\System\CurrentControlSet\Control\Session Manager\Environment" /f /v pathext /t reg_expand_sz /d %pathext%;.lnk >nul 2>nul
)


pause