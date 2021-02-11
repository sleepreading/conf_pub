@echo off
setlocal EnableDelayedExpansion


ver | find "5." >nul
if %errorlevel%==0 (
    set osver=1
) else (
    set osver=0
)

echo.
echo -------- Close some unnecessarry service! -----------
ping -n 2 localhost>nul
if %osver%==0 sc config IpOverUsbSvc start= disabled >nul 2>nul
set svrToClose=ALG HomeGroupListener HomeGroupProvider BITS EFS Mcx2Svc swprv CscService WPCSvc ShellHWDetection
set svrToClose=%svrToClose% pla wercplsupport UmRdpService RemoteRegistry srservice SamSs wscsvc SDRSVC WbioSrvc
set svrToClose=%svrToClose% WinDefend WerSvc ehRecvr ehSched WMPNetworkSvc wuauserv MSSEARCH WSearch ERSvc SharedAccess
set svrToDemand=btwdins Browser TrkWks Netlogon napagent SessionEnv TermService WinRM seclogon Schedule Wecsvc MpsSvc
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


pause