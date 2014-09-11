; #IfWinActive ahk_class Vim
#NoTrayIcon
#SingleInstance force
#NoEnv

Capslock::
SetCapsLockState, Off
Send {Esc}
Return