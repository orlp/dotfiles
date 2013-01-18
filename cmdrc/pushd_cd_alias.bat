@echo off

REM if no arguments were passed be have like the normal CD
if [%1]==[] (
    chdir
    goto end
)

REM replace forward slashes with backward slashes
set args=%1
shift
:start
if [%1] == [] goto done
set args=%args% %1
shift
goto start

:done
pushd %args:/=\%
set args=

:end
echo on