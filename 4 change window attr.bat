@echo off
setlocal EnableDelayedExpansion

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

pause