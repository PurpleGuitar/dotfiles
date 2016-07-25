@echo off

rem Check for administrative priveleges.
rem From: https://stackoverflow.com/questions/4051883/batch-script-how-to-check-for-admin-rights#11995662
net session >nul 2>&1
if NOT %errorLevel% == 0 (
    echo This script must be run with administrative privileges.
    goto end
)

rem remember current dir
set OLDDIR=%CD%

rem Get script dir
set SCRIPT_DIR=%~dp0

rem Get target dir
set TARGET_DIR=%USERPROFILE%

rem Process parameters
set SETUP_VIM=true
rem Modified from: http://stackoverflow.com/questions/14286457/using-parameters-in-batch-files-at-dos-command-line
:parse
IF "%~1"=="" GOTO endparse
IF "%~1"=="--help" (
    echo Usage: install.bat
    echo Options:
    echo   --help: Print this help and exit
    echo   --no-vim: Don't setup vim
    goto end
)
IF "%~1"=="--no-vim" (
    set SETUP_VIM=false
)
SHIFT
GOTO parse
:endparse


rem Link to dotfiles
cd %TARGET_DIR%
for %%x in (
    vimrc
    vimrc-plugins
    gitconfig
) do (
    rem Delete old file if it exists
    del .%%x >nul 2>&1
    rem Create hardlink to new file
    mklink /H ".%%x" %SCRIPT_DIR%%%x"
)


if "%SETUP_VIM%"=="true" (
    cd %TARGET_DIR%
    rem Create new .vim directory
    rmdir /s /q .vim
    mkdir .vim

    rem Install plugins
    mkdir .vim\bundle
    cd .vim\bundle
    git clone https://github.com/VundleVim/Vundle.vim.git
    git clone https://github.com/PurpleGuitar/vim-croz-colorscheme.git
    cd %TARGET_DIR%
    vim "+PluginInstall" "+qall"
)

rem Restore old current directory
chdir /d %OLDDIR%

:end

