;; =====================================
;; Remap Logitech Wireless Mouse buttons
;; =====================================
;; On Logitech wireless mouse, XButton2 is top button, XButton1 is bottom botton

; Regular buttons -- page up, page down
XButton2::PgUp
XButton1::PgDn

; Shift-buttons -- close doc (ctrl-w), minimize window
+XButton2:: Send {Control Down}w{Control Up}
+XButton1:: WinMinimize, A

; Alt-buttons -- Back (Alt-left) and Forward (Alt-right)
!XButton2:: Send {Alt Down}{Left}{Alt Up}
!XButton1:: Send {Alt Down}{Right}{Alt Up}

; Control buttons -- (unmapped for now, ctrl-PgUp/Dn is useful in many apps)
; ^XButton2::
; ^XButton1::

