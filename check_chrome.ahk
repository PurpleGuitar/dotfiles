;; =====================================================================
;; Check Chrome command -- new invokation should always be in new window
;; =====================================================================
RegRead, ChromeCmd, HKEY_CLASSES_ROOT, ChromeHTML\shell\open\command
IfNotInString, ChromeCmd, new-window
{
    MsgBox, Chrome's registry startup command needs --new-window.  Use regedit to fix.
    Run, http://superuser.com/questions/166479/force-chrome-to-open-new-pages-in-new-window-not-tab-when-opened-from-a-progr/916978#916978
}
