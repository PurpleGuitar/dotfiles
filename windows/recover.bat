@echo off

rem Recover from broken hardlinks by copying files back from the home
rem directory

rem Get script dir
set SCRIPT_DIR=%~dp0

rem Get source dir (that is, the parent dir of this script)
rem Adapted from https://stackoverflow.com/questions/34942604/get-parent-directory-of-a-specific-path-in-batch-script#comment57629146_34948844
for %%a in ("%SCRIPT_DIR%\.") do set "SOURCE_DIR=%%~dpa"

rem Get target dir
set TARGET_DIR=%USERPROFILE%

rem Recover dotfiles
echo * * * "In use" errors mean the hardlinks are OK.
echo * * * Successful copies means the hardlinks are broken.
for %%x in (
    vimrc
    vimrc-plugins
    gitconfig
) do (
    echo Recovering %%x...
    copy "%TARGET_DIR%\.%%x" "%SOURCE_DIR%%%x"
)
