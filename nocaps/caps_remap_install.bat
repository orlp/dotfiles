@echo off
setlocal ENABLEDELAYEDEXPANSION

REM install as cmdrc if not already (this only works as administrator)
REM check for administrator by copying a NUL to a random filename into the WINDIR
copy /b/y NUL %WINDIR%\lypuJ1KPr2bdQ7DJYnslS63g4qOMw9rvGcwFGQt6pxV7zhMdN9PeJT6fQmG4UHdI21h6KZ7oHG >NUL 2>&1
if errorlevel 0 (
    del %WINDIR%\lypuJ1KPr2bdQ7DJYnslS63g4qOMw9rvGcwFGQt6pxV7zhMdN9PeJT6fQmG4UHdI21h6KZ7oHG >NUL 2>&1
    goto administrator
)

echo You must be administrator for this script.
pause > nul
echo on
@exit

:administrator
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run" /v vim_caps_remap /t REG_EXPAND_SZ /d "\"%~dp0caps_remap.exe\"" /f
start "%~dp0caps_remap.exe"

pause
echo on