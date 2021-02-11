@ECHO OFF
REM  QBFC Project Options Begin
REM  HasVersionInfo: Yes
REM  Companyname: zhanglei
REM  Productname: wincfg
REM  Filedescription: Windows Optimization
REM  Copyrights: zhanglei
REM  Trademarks: zhanglei
REM  Originalname: wincfg
REM  Comments: QQ:847088355
REM  Productversion:  1. 0. 0. 0
REM  Fileversion:  1. 0. 0. 0
REM  Internalname: wincfg
REM  Appicon: bat2exe_x86_0.ico
REM  AdministratorManifest: Yes
REM  Embeddedfile: bginfo.bgi
REM  Embeddedfile: Bginfo.exe
REM  Embeddedfile: Everything.exe
REM  Embeddedfile: nircmdc.exe
REM  Embeddedfile: Pin.vbs
REM  Embeddedfile: SetACL.exe
REM  Embeddedfile: shellstyle.dll
REM  QBFC Project Options End
ECHO ON
@echo off
title Zhanglei System Config by sleepreading.top
color 2
echo       #######################
echo             %date%
echo       #######################
echo.
cd /d "%~dp0"
ping -n 3 localhost>nul
setlocal EnableDelayedExpansion
color 3

ver | find "5." >nul
if %errorlevel%==0 (
    echo Your System is XP, it's really too old!
    ping -n 2 localhost>nul
    set osver=1
) else (
    set osver=0
)

echo.
set ack=n
if %osver%==0 (
    choice /t 12 /d n /m "Are You Sure To Initialize?"
    if not !errorlevel!==1 exit
) else (
    set /p ack=Confirm to Initialize Please Input 'y':
    if /i not "!ack!"=="y" exit
)
echo ---------------------------------------------------^>
echo.

echo --- find out how many partitions do we have:
set /a part=0
set vdrv=D: E: F: G: H: I: J: K: L: M: N: O: P: Q: R: S: T: U: V: W: X: Y: Z:
for %%i in (%vdrv%) do if exist %%i wmic logicaldisk where "drivetype='3'" get deviceid | find /i "%%i" >nul && echo you have drive %%i&& set /a part+=1

md d:\usr\bin d:\lib d:\opt d:\tmp >nul 2>nul
set homedsk=%userprofile%
if %part% GEQ 2 (
    set homedsk=e:
) else if %part% GEQ 1 (
    set homedsk=d:
)
md "%homedsk%\demo" "%homedsk%\misc" "%homedsk%\work" "%homedsk%\soft" >nul 2>nul
md "%homedsk%\home\Contacts" "%homedsk%\home\Links" "%homedsk%\home\Favorites" "%homedsk%\home\Searches" "%homedsk%\home\Videos" >nul 2>nul
md "%homedsk%\home\Documents" "%homedsk%\home\Music" "%homedsk%\home\Downloads" "%homedsk%\home\Pictures" "%homedsk%\home\Saved Games" >nul 2>nul

if %osver%==0 (
    md "%homedsk%\home\Desktop\Godmode.{ED7BA470-8E54-465E-825C-99712043E01C}" >nul 2>nul
    cscript //nologo "%myfiles%\Pin.vbs" /taskbar /item:"%systemroot%\explorer.exe"
    "%myfiles%\nircmdc.exe" shortcut "%systemroot%\explorer.exe" "%appdata%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar" "Windows Explorer" , >nul 2>nul
) else (
    md "%homedsk%\home\Desktop\Administrative Tools.{D20EA4E1-3957-11D2-A40B-0C5020524153}" >nul 2>nul
    xcopy /e /i /y /c /k "%userprofile%\..\All Users\Start Menu\Programs\Administrative Tools\*" "%homedsk%\home\Desktop\Administrative Tools.{D20EA4E1-3957-11D2-A40B-0C5020524153}" >nul 2>nul
    "%myfiles%\nircmdc.exe" shortcut "%systemroot%\regedit.exe" "%homedsk%\home\Desktop\Administrative Tools.{D20EA4E1-3957-11D2-A40B-0C5020524153}" "regedit" 2>nul
)

set every=%systemroot%
where everything >nul 2>nul
if not %errorlevel% == 0 (
    if %part% GEQ 1 set every=d:\usr\bin
    xcopy /i /y /c /k "%myfiles%\Everything.exe" "!every!" >nul 2>nul
    cscript //nologo "%myfiles%\Pin.vbs" /item:"!every!\Everything.exe"
    if %osver%==1 "%myfiles%\nircmdc.exe" shortcut "!every!\Everything.exe" "~$folder.desktop$" "Finder" 2>nul
)

reg add "hkcu\Control Panel\Desktop" /v Wallpaper /t reg_sz /d "" /f >nul
"%myfiles%\Bginfo.exe" "%myfiles%\bginfo.bgi" /timer:0 /silent /NOLICPROMPT

if exist d:\usr\Vim\gvim.exe (
echo.
echo --- Add default open attribute to gvim
ping -n 2 localhost>nul
reg add hkcu\Software\Classes\Applications\gvim.exe\shell\open\command /f /ve /d "d:\usr\Vim\gvim.exe --remote-silent \"%%1\"" >nul
set ext=. txtfile .text .md .markdown .ini .inf .nfo .log .cnf .conf .config .xml .srt .sub .idx .tex .ltx
set ext=!ext! .cmd .jam .qbk .stx .ctl .acp .tlx .dic .rdf
set ext=!ext! .s .i .c .h .cc .cs .hh .sh .vb .rc .rc2 .js .pl .py .v2 .vbs .sed .dsm .css .php .asp
set ext=!ext! .sql .asm .cpp .cxx .hxx .hpp .inc .idl .def .vim .user .java .json .tlog .files .filters
set ext=!ext! .zshrc .vimrc .bashrc .manifest .vssettings
for %%i in (!ext!) do ftype %%i=d:\usr\Vim\gvim.exe --remote-silent "%%1">nul
)

echo.
echo --- Change time display format
ping -n 2 localhost>nul
reg add "hkcu\Control Panel\International" /f /v sShortDate /t reg_sz /d M/d >nul 2>nul
reg add "hkcu\Control Panel\International" /f /v LocaleName /t reg_sz /d zh-CN >nul 2>nul

echo.
echo --- disable ip$ share
ping -n 2 localhost>nul
reg add hklm\SYSTEM\CurrentControlSet\services\LanmanServer\Parameters /f /v AutoShareServer /t reg_dword /d 0 >nul
reg add hklm\SYSTEM\CurrentControlSet\services\LanmanServer\Parameters /f /v AutoShareWks /t reg_dword /d 0 >nul

echo.
echo --- disable autodetect domain name
ping -n 2 localhost>nul
reg add hklm\SYSTEM\CurrentControlSet\services\NlaSvc\Parameters\Internet /f /v EnableActiveProbing /t reg_dword /d 0 >nul

echo.
echo --- disable suggenstions of searchbox
ping -n 2 localhost>nul
reg add hkcu\Software\Policies\Microsoft\Windows\Explorer /f /v DisableSearchBoxSuggestions /t reg_dword /d 1 >nul

echo.
echo --- disable System Restore
ping -n 2 localhost>nul
reg query "hklm\Software\Microsoft\Windows NT\CurrentVersion\SystemRestore" /v DisableSR >nul 2>nul
if not %errorlevel%==0 reg add "hklm\Software\Microsoft\Windows NT\CurrentVersion\SystemRestore" /v DisableSR /t reg_dword /d 1 /f >nul
reg query "hklm\Software\Policies\Microsoft\Windows NT\SystemRestore" /v DisableSR >nul 2>nul
if not %errorlevel%==0 reg add "hklm\Software\Policies\Microsoft\Windows NT\SystemRestore" /v DisableSR /t reg_dword /d 1 /f >nul

echo.
echo --- disable CD AutoRun
ping -n 2 localhost>nul
reg query hkcu\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer /v NoDriveTypeAutoRun >nul 2>nul
if not %errorlevel%==0 reg add hkcu\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer /f /v NoDriveTypeAutoRun /t reg_dword /d 255 >nul

echo.
echo --- change window background and metrics
ping -n 2 localhost>nul
set vwm=CaptionWidth CaptionHeight MinWidth MinHeight MenuWidth MenuHeight
for %%i in (%vwm%) do (
    reg add "hkcu\Control Panel\Desktop\Windowmetrics" /v %%i /t reg_sz /d -270 /f >nul
    reg add "hku\.DEFAULT\Control Panel\Desktop\Windowmetrics" /v %%i /t reg_sz /d -270 /f >nul
    reg add "hku\S-1-5-18\Control Panel\Desktop\Windowmetrics" /v %%i /t reg_sz /d -270 /f >nul
)
reg add "hkcu\Control Panel\Desktop\WindowMetrics" /v PaddedBorderWidth /t reg_sz /d 0 /f >nul
reg add "hkcu\Control Panel\Desktop\Windowmetrics" /v MinAnimate /t reg_sz /d 0 /f >nul
reg add "hkcu\Control Panel\Desktop" /v WaitToKillAppTimeout /t reg_sz /d 2000 /f >nul
reg add "hkcu\Control Panel\Colors" /v Window /t reg_sz /d "204 232 207" /f >nul

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
if exist "Quick Launch" (
    "%myfiles%\nircmdc.exe" shellcopy "Quick Launch" "%appdata%\Microsoft\Internet Explorer\" yestoall noerrorui silent 2>nul
)
if %osver%==0 (
    echo.
    echo --- crack the system theme: shellstyle.dll
    ping -n 2 localhost>nul
    takeown /f "%windir%\Resources\Themes\Aero\Shell\NormalColor\shellstyle.dll" >nul 2>nul && icacls "%windir%\Resources\Themes\Aero\Shell\NormalColor\shellstyle.dll" /c /grant %username%:F >nul 2>nul
    "%myfiles%\setacl.exe" -on "%windir%\Resources\Themes\Aero\Shell\NormalColor\shellstyle.dll" -ot file -actn ace -ace "n:%username%;p:full" >nul 2>nul
    del /f /q "%windir%\Resources\Themes\Aero\Shell\NormalColor\shellstyle.dll" >nul 2>nul
    "%myfiles%\nircmdc.exe" shellcopy "%myfiles%\shellstyle.dll" "%windir%\Resources\Themes\Aero\Shell\NormalColor" yestoall noerrorui silent 2>nul
)

if %osver%==0 (
    if exist UnxUtils (
        "%myfiles%\nircmdc.exe" shellcopy UnxUtils\* d:\usr\bin yestoall noerrorui silent 2>nul
        rd /s /q UnxUtils >nul 2>nul
    )
    if exist vimperator (
        cp -rfp vimperator _vimperatorrc "%homedsk%\home" >nul 2>nul
        "%myfiles%\nircmdc.exe" shellcopy vimperator "%homedsk%\home" silent yestoall noerrorui 2>nul
        "%myfiles%\nircmdc.exe" shellcopy _vimperator "%homedsk%\home" silent yestoall noerrorui 2>nul
    )
    echo.
    echo --- delete 'home group' on the left pane of Explorer
    ping -n 2 localhost>nul
    "%myfiles%\setacl.exe" -on HKEY_CLASSES_ROOT\CLSID\{B4FB3F98-C1EA-428d-A78A-D1F5659CBA93}\ShellFolder -ot reg -actn setowner -ownr "n:%username%" >nul 2>nul
    "%myfiles%\setacl.exe" -on HKEY_CLASSES_ROOT\CLSID\{B4FB3F98-C1EA-428d-A78A-D1F5659CBA93}\ShellFolder -ot reg -actn ace -ace "n:%username%;p:full;i:sc,so" >nul 2>nul
    reg add HKEY_CLASSES_ROOT\CLSID\{B4FB3F98-C1EA-428d-A78A-D1F5659CBA93}\ShellFolder /f /v Attributes /t reg_dword /d 0xb094010c >nul
    ::echo --- delete 'Favorite' on the left pane of Explorer
    "%myfiles%\setacl.exe" -on HKEY_CLASSES_ROOT\CLSID\{323CA680-C24D-4099-B94D-446DD2D7249E}\ShellFolder -ot reg -actn setowner -ownr "n:%username%" >nul 2>nul
    "%myfiles%\setacl.exe" -on HKEY_CLASSES_ROOT\CLSID\{323CA680-C24D-4099-B94D-446DD2D7249E}\ShellFolder -ot reg -actn ace -ace "n:%username%;p:full;i:sc,so" >nul 2>nul
    ::reg add HKEY_CLASSES_ROOT\CLSID\{323CA680-C24D-4099-B94D-446DD2D7249E}\ShellFolder /f /v Attributes /t reg_dword /d 0xa9400100 >nul
    echo.
    echo --- delete 'Library' on the left pane of Explorer
    ping -n 2 localhost>nul
    "%myfiles%\setacl.exe" -on HKEY_CLASSES_ROOT\CLSID\{031E4825-7B94-4dc3-B131-E946B44C8DD5}\ShellFolder -ot reg -actn setowner -ownr "n:%username%" >nul 2>nul
    "%myfiles%\setacl.exe" -on HKEY_CLASSES_ROOT\CLSID\{031E4825-7B94-4dc3-B131-E946B44C8DD5}\ShellFolder -ot reg -actn ace -ace "n:%username%;p:full;i:sc,so" >nul 2>nul
    reg add HKEY_CLASSES_ROOT\CLSID\{031E4825-7B94-4dc3-B131-E946B44C8DD5}\ShellFolder /f /v Attributes /t reg_dword /d 0xb090010d >nul
    echo.
    echo --- turn off UAC
    ping -n 2 localhost>nul
    reg add HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System /v EnableLUA /t reg_dword /d 0 /f >nul
    echo.
    echo --- delete 'Security Centre Action' icon from taskbar
    ping -n 2 localhost>nul
    reg add HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\Explorer /v HideSCAHealth /t reg_dword /d 1 /f >nul
)

if %osver%==0 (
    echo.
    echo --- delete teredo 6to4 isatap net-interface
    ping -n 2 localhost>nul
    netsh interface teredo set state disable >nul
    netsh interface 6to4 set state disable >nul
    netsh interface isatap set state disable >nul
    netsh int tcp set global autotuninglevel=disable >nul
)
ping -n 2 localhost>nul

echo.
echo --- Add 'Empty Recycle' to the right menu
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
echo --- Turn off hibenate and change power options.
ping -n 2 localhost>nul
powercfg /h off >nul 2>nul
set v2=-disk-timeout-ac -disk-timeout-dc -standby-timeout-ac -standby-timeout-dc -hibernate-timeout-ac -hibernate-timeout-dc -monitor-timeout-ac -monitor-timeout-dc
if %osver%==0 (
    for %%i in (!v2!) do powercfg /x %%i 0 >nul 2>nul
) else (
    powercfg /c leiz >nul 2>nul
    powercfg /s leiz >nul 2>nul
    for %%i in (!v2!) do powercfg /x leiz %%i 0 >nul 2>nul
)

echo.
echo --- Add some system environment variables
ping -n 2 localhost>nul
if not defined path reg add hkcu\Environment /f /v path /t reg_expand_sz /d d:\usr\bin;d:\lib\mingw\bin;d:\lib\Python27;d:\lib\Python27\Scripts; >nul 2>nul
if not defined home reg add hkcu\Environment /f /v home /d "%homedsk%\home" >nul 2>nul
if not defined mingw reg add hkcu\Environment /f /v mingw /d d:\lib\mingw >nul 2>nul
if not defined python reg add hkcu\Environment /f /v python /d d:\lib\Python27 >nul 2>nul
reg query "hklm\System\CurrentControlSet\Control\Session Manager\Environment" /v pathext 2>nul | find /i ".lnk" >nul || (
    reg add "hklm\System\CurrentControlSet\Control\Session Manager\Environment" /f /v pathext /t reg_expand_sz /d %pathext%;.lnk >nul 2>nul
)
ping -n 2 localhost>nul

echo.
echo -------- Close some unnecessarry service! -----------
ping -n 2 localhost>nul
if %osver%==0 sc config IpOverUsbSvc start= disabled >nul 2>nul
set svrToClose=ALG HomeGroupListener HomeGroupProvider BITS EFS Mcx2Svc swprv CscService WPCSvc ShellHWDetection
set svrToClose=%svrToClose% pla wercplsupport UmRdpService RemoteRegistry srservice SamSs wscsvc SDRSVC WbioSrvc
set svrToClose=%svrToClose% WinDefend WerSvc ehRecvr ehSched WMPNetworkSvc wuauserv MSSEARCH WSearch ERSvc SharedAccess
set svrToDemand=btwdins bthserv Browser TrkWks Netlogon napagent SessionEnv TermService WinRM seclogon Schedule Wecsvc MpsSvc
for %%j in (%svrToClose%) do sc config %%j start= disabled >nul 2>nul
for %%k in (%svrToDemand%) do sc config %%k start= demand >nul 2>nul
echo -------- Close unnecessarry service done! -----------

if %osver%==0 (
echo.
ping -n 2 localhost>nul
echo -------- Close some unnecessarry Features! -----------
set dism="%WINDIR%\system32\dism.exe"
if exist %WINDIR%\SysNative\dism.exe set dism="%WINDIR%\SysNative\dism.exe"
set vFeatures=WindowsGadgetPlatform InboxGames MediaPlayback MediaCenter OpticalMediaDisc TabletPCOC MSRDC-Infrastructure
set vFeatures=!vFeatures! Printing-XPSServices-Features Xps-Foundation-Xps-Viewer SearchEngine-Client-Package
for %%i in (!vFeatures!) do !dism! /Online /Disable-Feature /FeatureName:%%i /NoRestart 2>nul
echo -------- Close unnecessarry Features done! -----------
)

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
echo done!


echo.&& echo All done!
echo You need to ^<REBOOT^> to take effect!
echo.

if %osver%==0 (
    choice /t 12 /d y /m "Reboot Computer?"
    if !errorlevel!==1 (
        ::taskkill /f /im explorer.exe >nul
        ::reg add hkcu\Software\Microsoft\Windows\CurrentVersion\Explorer\StuckRects2 /f /v Settings /t reg_binary /d 28000000ffffffff02000000000000003e0000003000000000000000000000003e00000000030000 >nul 2>nul
        shutdown -r -t 0
    )
) else (
    set /p ack=To Reboot Input 'r':
    if /i "!ack!"=="r" shutdown -r -t 0
)
