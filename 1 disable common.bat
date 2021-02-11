@echo off
setlocal EnableDelayedExpansion


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

echo --- delete 'home group' on the left pane of Explorer
ping -n 2 localhost>nul
setacl.exe -on HKEY_CLASSES_ROOT\CLSID\{B4FB3F98-C1EA-428d-A78A-D1F5659CBA93}\ShellFolder -ot reg -actn setowner -ownr "n:%username%" >nul 2>nul
setacl.exe -on HKEY_CLASSES_ROOT\CLSID\{B4FB3F98-C1EA-428d-A78A-D1F5659CBA93}\ShellFolder -ot reg -actn ace -ace "n:%username%;p:full;i:sc,so" >nul 2>nul
reg add HKEY_CLASSES_ROOT\CLSID\{B4FB3F98-C1EA-428d-A78A-D1F5659CBA93}\ShellFolder /f /v Attributes /t reg_dword /d 0xb094010c >nul
::echo --- delete 'Favorite' on the left pane of Explorer
::setacl.exe -on HKEY_CLASSES_ROOT\CLSID\{323CA680-C24D-4099-B94D-446DD2D7249E}\ShellFolder -ot reg -actn setowner -ownr "n:%username%" >nul 2>nul
::setacl.exe -on HKEY_CLASSES_ROOT\CLSID\{323CA680-C24D-4099-B94D-446DD2D7249E}\ShellFolder -ot reg -actn ace -ace "n:%username%;p:full;i:sc,so" >nul 2>nul
::reg add HKEY_CLASSES_ROOT\CLSID\{323CA680-C24D-4099-B94D-446DD2D7249E}\ShellFolder /f /v Attributes /t reg_dword /d 0xa9400100 >nul
echo.
echo --- delete 'Library' on the left pane of Explorer
ping -n 2 localhost>nul
setacl.exe -on HKEY_CLASSES_ROOT\CLSID\{031E4825-7B94-4dc3-B131-E946B44C8DD5}\ShellFolder -ot reg -actn setowner -ownr "n:%username%" >nul 2>nul
setacl.exe -on HKEY_CLASSES_ROOT\CLSID\{031E4825-7B94-4dc3-B131-E946B44C8DD5}\ShellFolder -ot reg -actn ace -ace "n:%username%;p:full;i:sc,so" >nul 2>nul
reg add HKEY_CLASSES_ROOT\CLSID\{031E4825-7B94-4dc3-B131-E946B44C8DD5}\ShellFolder /f /v Attributes /t reg_dword /d 0xb090010d >nul
echo.

echo.
echo --- delete 'Security Centre Action' icon from taskbar
ping -n 2 localhost>nul
reg add HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\Explorer /v HideSCAHealth /t reg_dword /d 1 /f >nul

echo --- turn off UAC
ping -n 2 localhost>nul
reg add HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System /v EnableLUA /t reg_dword /d 0 /f >nul
echo.
echo --- Turn off hibenate and change power options.
ping -n 2 localhost>nul
powercfg /h off >nul 2>nul

echo.
echo --- delete teredo 6to4 isatap net-interface
ping -n 2 localhost>nul
netsh interface teredo set state disable >nul
netsh interface 6to4 set state disable >nul
netsh interface isatap set state disable >nul
netsh int tcp set global autotuninglevel=disable >nul



pause