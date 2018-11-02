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

rem Check links
for %%x in (
    gvimrc
    vimrc
    vimrc-plugins
    gitconfig
) do (
    echo Checking %%x...
    diff "%TARGET_DIR%\.%%x" "%SOURCE_DIR%%%x"
)
