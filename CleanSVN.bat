@echo off
cd /d "%~dp0"
for /r . %%X in (.svn) do (rd /s /q "%%X" 2>nul)
exit
echo done!