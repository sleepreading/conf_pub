@echo off
setlocal EnableDelayedExpansion


set vimpath=c:\usr\Vim\gvim.exe
if exist d:\usr\Vim\gvim.exe set vimpath=d:\usr\Vim\gvim.exe
ping -n 2 localhost>nul
reg add hkcu\Software\Classes\Applications\gvim.exe\shell\open\command /f /ve /d "%vimpath% --remote-silent \"%%1\"" >nul
set ext=. txtfile .text .md .markdown .ini .inf .nfo .log .cnf .conf .config .xml .srt .sub .idx .tex .ltx
set ext=!ext! .cmd .jam .qbk .stx .ctl .acp .tlx .dic .rdf
set ext=!ext! .s .i .c .h .cc .cs .hh .sh .vb .rc .rc2 .js .pl .py .v2 .vbs .sed .dsm .css .php .asp
set ext=!ext! .sql .asm .cpp .cxx .hxx .hpp .inc .idl .def .vim .user .java .json .tlog .files .filters
set ext=!ext! .zshrc .vimrc .bashrc .manifest .vssettings
for %%i in (!ext!) do ftype %%i=%vimpath% --remote-silent "%%1">nul

pause