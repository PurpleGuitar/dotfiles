dotfiles
========

Craig's configuration files

Setup
-----

Create a simlink to each file you want from your home directory.


.profile
--------

A simple .profile is included in case your system doesn't
automatically call .bashrc.


tmux
----

Two different .tmux.conf files are given, depending on whether your install
of tmux is pre-2.1 or 2.1+.  (The format of the mouse commands changed in
2.1 and breaks backward compatibility.)  There is also a tmux.conf.common
file, included by tmux.conf, that contains commands common to both
versions.

To find out what version of tmux you're running, execute:
$ tmux -V

To use these config files, do the following:

- cd ~
- ln -s /path/to/repo/.tmux.conf.21plus .tmux.conf
- ln -s /path/to/repo/.tmux.conf.common .tmux.conf.common

If you're running an older version of tmux (e.g. Ubuntu runs 1.8 as of this
writing), replace "21plus" with "pre21".
