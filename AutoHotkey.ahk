;=====================================================================o
;                   zhanglei email:847088355@qq.com                   |
;                   telephone: 15043125186                            |
;---------------------------------------------------------------------o
;-----------------------------------o
; map CapsLock to LeftCtrl
SetCapsLockState, AlwaysOff
Capslock::
   Gui, 93:+Owner ; prevent display of taskbar button
   Gui, 93:Show, y-99999 NA, Enable nav-hotkeys: hjkl
   Send {LCtrl Down}
   KeyWait, Capslock ; wait until the Capslock button is released
   Gui, 93:Cancel
   Send, {LCtrl Up}
Return

;-----------------------------------o
; double RCtrl to invoke Launchy
~RControl::
if (A_PriorHotkey <> "~RControl" or A_TimeSincePriorHotkey > 400) {
    KeyWait, RControl  ; Too much time between presses, so this isn't a double-press.
    return
}
Run "%A_ScriptDir%/Launchy/LaunchyPortable.exe"
return

;-----------------------------------o
; F12 or alt + t : set curwindow topmost
SetWindowTopMost()
{
    WinGetActiveTitle, varWinTitle
    WinSet, AlwaysOnTop, Toggle, %varWinTitle%
}
;!t::SetWindowTopMost()
!F12::SetWindowTopMost()


;-----------------------------------o
; similate vim
;-----------------------------------o
#IfWinNotActive ahk_class Vim

; alt + q : exit app
;!q::send !{F4}

; alt + d = delete
!d::Send, {Delete}

; open everything
::,f::
Run "%A_ScriptDir%/bin/Everything.exe"
return

; open url google
::,g::
Run www.google.com/ncr
return

; navigation left
!h::Send, {Left}
!+h::Send, +{Left}

; navigation Right
!l::Send, {Right}
!+l::Send, +{Right}

; navigation Up
!k::Send, {Up}
!+k::Send, +{Up}

; navigation down
!j::Send, {Down}
!+j::Send, +{Down}

; alt + i = home
!,::Send, {Home}
!+,::Send, +{Home}

; alt + o = end
!.::Send, {End}
!+.::Send, +{End}

; alt + p = PageUp
!p::Send, {PgUp}
!+p::Send, +{PgUp}

; alt + n = PageDown
!n::Send, {PgDn}
!+n::Send, +{PgDn}

#IfWinNotActive

; double comma to ESC
;#IfWinNotActive ahk_class TXGuiFoundation
;::,::{Esc}
;#IfWinNotActive

; ctrl + f/b/h : unix style shortcut
#IfWinNotActive ahk_class TTOTAL_CMD
^h::send {Backspace}
#IfWinNotActive

