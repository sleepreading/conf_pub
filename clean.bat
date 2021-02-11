@echo off
echo #######################
echo #  %date%  #
echo #######################
echo.

echo.
echo --- 清理不必要系统文件
if exist "%windir%\Help" (
	takeown /r /f "%windir%\Help" && icacls "%windir%\Help" /t /c /grant %username%:F
	setacl.exe -on "%windir%\Help" -ot file -actn setowner -ownr "n:%username%" -rec cont_obj >nul
	setacl.exe -on "%windir%\Help" -ot file -actn ace -ace "n:%username%;p:full;i:sc,so" -rec cont_obj >nul
)
if exist "%windir%\winsxs\backup" (
	takeown /r /f "%windir%\winsxs\backup" && icacls "%windir%\winsxs\backup" /t /c /grant %username%:F
	setacl.exe -on "%windir%\winsxs\backup" -ot file -actn setowner -ownr "n:%username%" -rec cont_obj >nul
	setacl.exe -on "%windir%\winsxs\backup" -ot file -actn ace -ace "n:%username%;p:full;i:sc,so" -rec cont_obj >nul
)
if exist "%windir%\Downloaded Program Files" (
	takeown /r /f "%windir%\Downloaded Program Files" && icacls "%windir%\Downloaded Program Files" /t /c /grant %username%:F
	setacl.exe -on "%windir%\Downloaded Program Files" -ot file -actn setowner -ownr "n:%username%" -rec cont_obj >nul
	setacl.exe -on "%windir%\Downloaded Program Files" -ot file -actn ace -ace "n:%username%;p:full;i:sc,so" -rec cont_obj >nul
)
if exist "%windir%\Downloaded Installations" (
	takeown /r /f "%windir%\Downloaded Installations" && icacls "%windir%\Downloaded Installations" /t /c /grant %username%:F
	setacl.exe -on "%windir%\Downloaded Installations" -ot file -actn setowner -ownr "n:%username%" -rec cont_obj >nul
	setacl.exe -on "%windir%\Downloaded Installations" -ot file -actn ace -ace "n:%username%;p:full;i:sc,so" -rec cont_obj >nul
)
if exist "%windir%\ime\pchealth" (
	takeown /r /f "%windir%\ime\pchealth" && icacls "%windir%\ime\pchealth" /t /c /grant %username%:F
	setacl.exe -on "%windir%\ime\pchealth" -ot file -actn setowner -ownr "n:%username%" -rec cont_obj >nul
	setacl.exe -on "%windir%\ime\pchealth" -ot file -actn ace -ace "n:%username%;p:full;i:sc,so" -rec cont_obj >nul
)
if exist "%windir%\ime\imejp10" (
	takeown /r /f "%windir%\ime\imejp10" && icacls "%windir%\ime\imejp10" /t /c /grant %username%:F
	setacl.exe -on "%windir%\ime\imejp10" -ot file -actn setowner -ownr "n:%username%" -rec cont_obj >nul
	setacl.exe -on "%windir%\ime\imejp10" -ot file -actn ace -ace "n:%username%;p:full;i:sc,so" -rec cont_obj >nul
)
if exist "%windir%\ime\imetc10" (
	takeown /r /f "%windir%\ime\imetc10" && icacls "%windir%\ime\imetc10" /t /c /grant %username%:F
	setacl.exe -on "%windir%\ime\imetc10" -ot file -actn setowner -ownr "n:%username%" -rec cont_obj >nul
	setacl.exe -on "%windir%\ime\imetc10" -ot file -actn ace -ace "n:%username%;p:full;i:sc,so" -rec cont_obj >nul
)
if exist "%windir%\ime\imekr8" (
	takeown /r /f "%windir%\ime\imekr8" && icacls "%windir%\ime\imekr8" /t /c /grant %username%:F
	setacl.exe -on "%windir%\ime\imekr8" -ot file -actn setowner -ownr "n:%username%" -rec cont_obj >nul
	setacl.exe -on "%windir%\ime\imekr8" -ot file -actn ace -ace "n:%username%;p:full;i:sc,so" -rec cont_obj >nul
)
if exist "%windir%\ime\imesc5" (
	takeown /r /f "%windir%\ime\imesc5" && icacls "%windir%\ime\imesc5" /t /c /grant %username%:F
	setacl.exe -on "%windir%\ime\imesc5" -ot file -actn setowner -ownr "n:%username%" -rec cont_obj >nul
	setacl.exe -on "%windir%\ime\imesc5" -ot file -actn ace -ace "n:%username%;p:full;i:sc,so" -rec cont_obj >nul
)

del /s /f /q %windir%\Help\*.*
del /s /f /q %windir%\winsxs\backup\*.*
rd /s /q "%windir%\Downloaded Program Files"
md "%windir%\Downloaded Program Files"
rd /s /q "%windir%\Downloaded Installations"
md "%windir%\Downloaded Installations"
rd /s /q %windir%\pchealth
rd /s /q %windir%\ime\imejp10
rd /s /q %windir%\ime\imetc10
rd /s /q %windir%\ime\imekr8
rd /s /q %windir%\ime\imesc5
rd /s /q %windir%\temp
md %windir%\temp
del /f /s /q %systemdrive%\*.tmp
del /f /s /q %systemdrive%\*._mp
del /f /s /q %systemdrive%\*.gid
del /f /s /q %systemdrive%\*.chk
del /f /s /q %systemdrive%\*.old
del /f /s /q %windir%\*.bak
del /f /s /q %windir%\prefetch\*.*
del /f /s /q "%userprofile%\recent\*.*"

echo. & echo !!! -- clean work done! --!!!
exit