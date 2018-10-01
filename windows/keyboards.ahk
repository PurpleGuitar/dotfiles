;; Online keyboard tester: http://www.keyboardtester.com/tester.html

; Disable capslock by itself
SetCapsLockState, Off
SetCapsLockState, AlwaysOff

SendWithModifiers(keycode)
{
    if GetKeyState("Shift", "P") {
        Send {Shift Down}%keycode%{Shift Up}
    } else if GetKeyState("Control", "P") {
        Send {Control Down}%keycode%{Control Up}
    } else if GetKeyState("Alt", "P") {
        Send {Alt Down}%keycode%{Alt Up}
    } else {
        Send %keycode%
    }
    return
}

;; =================================================================
;; Key shortcuts from POK3R using Capslock as virtual Fn key
;; =================================================================

Capslock & Esc::SendWithModifiers("``")
Capslock & z::SendWithModifiers("{Appskey}")
Capslock & i::SendWithModifiers("{Up}")
;;Capslock & j::SendWithModifiers("{Left}")
;;Capslock & k::SendWithModifiers("{Down}")
;;Capslock & l::SendWithModifiers("{Right}")
;;Capslock & u::SendWithModifiers("{PgUp}")
Capslock & o::SendWithModifiers("{PgDn}")
Capslock & q::SendWithModifiers("{Media_Prev}")
Capslock & w::SendWithModifiers("{Media_Play_Pause}")
Capslock & e::SendWithModifiers("{Media_Next}")
Capslock & s::SendWithModifiers("{Volume_Down}")
Capslock & d::SendWithModifiers("{Volume_Up}")
Capslock & f::SendWithModifiers("{Volume_Mute}")
Capslock & y::Run "C:\Windows\System32\calc.exe"
Capslock & h::SendWithModifiers("{Home}")
Capslock & n::SendWithModifiers("{End}")
Capslock & p::SendWithModifiers("{PrintScreen}")
Capslock & [::SendWithModifiers("{ScrollLock}")
Capslock & ]::SendWithModifiers("{Pause}")
Capslock & 1::SendWithModifiers("{F1}")
Capslock & 2::SendWithModifiers("{F2}")
Capslock & 3::SendWithModifiers("{F3}")
Capslock & 4::SendWithModifiers("{F4}")
Capslock & 5::SendWithModifiers("{F5}")
Capslock & 6::SendWithModifiers("{F6}")
Capslock & 7::SendWithModifiers("{F7}")
Capslock & 8::SendWithModifiers("{F8}")
Capslock & 9::SendWithModifiers("{F9}")
Capslock & 0::SendWithModifiers("{F10}")
Capslock & -::SendWithModifiers("{F11}")
Capslock & +::SendWithModifiers("{F12}")
Capslock & SC027::SendWithModifiers("{Insert}") ; Semicolon
Capslock & SC028::SendWithModifiers("{Delete}") ; Single quote
Capslock & SC00E::SendWithModifiers("{Delete}") ; Backspace

;; =================================================================
;; Key shortcuts from Chromebook
;; =================================================================

; Cursor movement
Capslock & Left::SendWithModifiers("{Home}")
Capslock & Right::SendWithModifiers("{End}")
Capslock & Up::SendWithModifiers("{PgUp}")
Capslock & Down::SendWithModifiers("{PgDn}")

; Window movement and docking
![::Send {LWin Down}{Left}{LWin Up}
!]::Send {LWin Down}{Right}{LWin Up}
!=::Send {LWin Down}{Up}{LWin Up}
!-::Send {LWin Down}{Down}{LWin Up}

;; =================================================================
;; Graveyard
;; =================================================================

; EXPERIMENTAL: Turn capslock off: Ctrl-Alt-Shift-Capslock
; ^!+CapsLock::
; SetCapsLockState, Off
; SetCapsLockState, AlwaysOff
; return

; +Esc::Send ~

; The "Find" key on the Chromebook is where CapsLock is on most keyboards
; CapsLock::Send {LWin}
