@echo off

REM don't bother setting up a nice environment if we're not interactive
echo %CMDCMDLINE% | C:\Windows\System32\find.exe /i "/c" >nul
if not errorlevel 1 goto exit

REM set up environment/commands

REM always use pushd
doskey dirs=pushd
doskey pd=popd $*
doskey cd="%~dp0pushd_cd_alias" $*

REM set up msls
doskey ls="%~dp0msls"\ls.exe $*

REM emulate a bit of linux
doskey cat=type $*
doskey mv=move $*

REM git
doskey gm=git commit -am "$*" ^&^& git push

REM sublime text 2 shortcut
doskey subl="C:\Program Files (x86)\Sublime Text 2\sublime_text.exe" $*

REM gvim shortcut
doskey vim="C:\Program Files (x86)\Vim\vim74\gvim.exe" $*

REM enable ansi colors
if "%PROCESSOR_ARCHITECTURE%"=="x86" (
    "%~dp0ansicon"\x86\ansicon.exe -p
) else (
    "%~dp0ansicon"\x64\ansicon.exe -p
)

REM environment variables
endlocal
if NOT "%1" == "" set CONSOLE_NR=%1

REM startup dir
cd c:\

REM run clink (this HAS to be the last command, that's why we already put echo to on)
echo on
@"%~dp0clink\clink.bat" inject --quiet --profile "%~dp0clink_profile" --scripts "%~dp0clink_scripts"

:exit
@echo on