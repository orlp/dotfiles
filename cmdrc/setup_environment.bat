@echo off

REM always use pushd
REM doskey dirs=pushd
REM doskey pd=popd $*
REM doskey cd="%~dp0pushd_cd_alias" $*

REM set up msls
doskey ls="%~dp0msls"\ls.exe $*

REM emulate a bit of linux
doskey cat=type $*
doskey mv=move $*

REM environment variables
endlocal
if NOT "%1" == "" set CONSOLE_NR=%1

REM startup dir
cd c:\

REM run clink (this HAS to be the last command, that's why we already put echo to on)
echo on
@"%~dp0clink\clink.bat" inject --quiet --profile "%~dp0clink_profile"

:exit
@echo on
