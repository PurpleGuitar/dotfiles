;; =====================================
;; Remap Logitech Wireless Mouse buttons
;; =====================================
;; On Logitech wireless mouse, XButton2 is top button, XButton1 is bottom botton

; Regular buttons -- page up, page down
XButton2::PgUp
XButton1::PgDn

; Shift-buttons -- Home and End
+XButton2::Send {Home}
+XButton1::Send {End}

; Ctrl-Shift-buttons -- close doc (ctrl-w), Done with Email (C-S-9)
^+XButton2:: Send {Control Down}w
^+XButton1:: Send {Control Down}{Shift Down}9

; Alt-buttons -- Back (Alt-left) and Forward (Alt-right)
!XButton2:: Send {Alt Down}{Left}
!XButton1:: Send {Alt Down}{Right}

; Ctrl-Alt-buttons -- close window (Alt-F4), minimize window
^!XButton2:: Send {Alt Down}{F4}
^!XButton1:: WinMinimize, A

; Control buttons -- (unmapped for now, ctrl-PgUp/Dn is useful in many apps)
; ^XButton2::
; ^XButton1::

