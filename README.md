dotfiles
========

Craig's configuration files for Linux and Windows

Setup (Linux)
-------------

Make sure the following is already installed:

-   realpath (this may already be installed depending on your OS)
-   git
-   tmux
-   vim

Then run install.sh. You don't need to be in the `dotfiles` directory to
run the script; it will figure out the file paths on its own.

If you just want to link the files and not set up the .vim directory,
you can use the --no-vim argument, e.g.: `install.sh --no-vim`

### .profile

A simple .profile is included in case your system doesn't automatically
call .bashrc.

Setup (Windows)
---------------

Run `install.bat` as an administrator. This will hardlink a few files
from your home directory to point to your dotfiles directory. You don't
need to be in the `dotfiles\windows` directory to run the script; it
will figure out the file paths on its own.

Note that Windows sometimes unlinks the files without warning. The
`checklinks.bat` and `recover.bat` files can help diagnose and figure
out which version of the files are correct. Then you can run install.bat
again to relink them.

If you just want to link the files and not set up the .vim directory,
you can use the --no-vim argument, e.g.: `install.bat --no-vim`
