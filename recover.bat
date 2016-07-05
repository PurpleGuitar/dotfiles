@echo off

rem Recover from broken hardlinks by copying files back from the home
rem directory

rem Get script dir
set SCRIPT_DIR=%~dp0

rem Get target dir
set TARGET_DIR=%USERPROFILE%

rem Reover dotfiles
for %%x in (
    vimrc
    vimrc-plugins
    gitconfig
) do (
    echo Recovering %%x...
    copy "%TARGET_DIR%\.%%x" "%SCRIPT_DIR%%%x"
)
