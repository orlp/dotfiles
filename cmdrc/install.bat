reg add "HKCU\Software\Microsoft\Command Processor" /V AutoRun /T REG_EXPAND_SZ /F /D "\"%~dp0setup_environment.bat\""
pause