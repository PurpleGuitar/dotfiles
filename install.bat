rem @echo off

rem Check for administrative priveleges.
rem From: https://stackoverflow.com/questions/4051883/batch-script-how-to-check-for-admin-rights#11995662
net session >nul 2>&1
if NOT %errorLevel% == 0 (
    echo This script must be run with administrative privileges.
    goto end
)

rem Get script dir
set SCRIPT_DIR=%~dp0

rem Get target dir
set TARGET_DIR=%USERPROFILE%
cd %TARGET_DIR%

rem Delete old vimrc if it exists
del .vimrc >nul 2>&1

rem Create hardlink to new vimrc
mklink /H ".vimrc" %SCRIPT_DIR%vimrc"

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

:end
