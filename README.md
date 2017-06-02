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

Then run install.sh. The following sections are only needed if you run into
issues or want to install manually.

### .profile

A simple .profile is included in case your system doesn't automatically
call .bashrc.

Setup (Windows)
---------------

Run `install.bat` as an administrator. This will hardlink a few files from
your home directory to point to your dotfiles directory.

Note that Windows sometimes unlinks the files without warning. The
checklinks.bat and recover.bat files can help diagnose and figure out which
version of the files are correct. Then you can run install.bat again to
relink them.

If you just want to link the files and not (re-)install Vim, you can use
the --no-vim argument, e.g.: `install.bat --no-vim`
