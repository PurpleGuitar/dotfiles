# Abort if not running interactively
[ -z "$PS1" ] && return


# Aliases
# =======

# classify files in colour
alias ls='ls -hF --color=tty'

# Always use color for tree, sort dirs first
alias tree='tree -C --dirsfirst'

# Behave, kitty!
alias nyancat='nyancat --no-counter --no-title'

# cmatrix looks extra awesome with bold
alias cmatrix='cmatrix -b'

# Custom xterm that attaches to current tmux session
alias xt='xterm -e "tmux -u2" &'

# Show grep in color if possible
grep --version --color=auto &> /dev/null
if [ $? -eq 0 ]; then
    alias grep='grep --color=auto'
fi

# Other aliases
alias h='history'
alias htopu='htop -u $USER'
alias in-vim-shell='if [[ $(env | grep VIMRUNTIME) ]]; then echo "Yes, running in a Vim shell" ; else echo "No, not running in a Vim shell" ; fi'
alias reboot-required='if [ -f /var/run/reboot-required ]; then echo "Yes, reboot required" ; else echo "No, reboot not required" ; fi'


# Other Stuff
# ===========

# History options
export HISTCONTROL=ignorespace:ignoredups:erasedups
export HISTFILESIZE=5000
shopt -s histappend

# Enable programmable completion features
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# Disable Ctrl-S (TTY STOP) and Ctrl-Q (TTY START)
# It was causing problems with PuTTY
if [ -t 1 ]; then
    stty stop undef
    stty start undef
fi

# Use Vim.  Always.
export EDITOR=vim

# Correct some typos when using cd
shopt -s cdspell


# Load bashrc prompt
# ==================
if [ -f ~/.bashrc-prompt ]; then
    source ~/.bashrc-prompt
fi


# Load local bashrc script if it exists
# =====================================
if [ -f ~/.bashrc-local ]; then
    source ~/.bashrc-local
fi


# Set Xterm defaults if xrdb exists
# =================================
# (We load this after .bashrc-local since it often sets the DISPLAY variable.)
command -v xrdb> /dev/null 2>&1 && [ "$DISPLAY" ] && xrdb -merge ~/.Xresources


# Launch tmux if available
# ========================
if command -v tmux>/dev/null; then
    if [ ! -z "$PS1" ]; then # unless shell not loaded interactively, run tmux
        [[ ! $TERM =~ screen ]] && [ -z $TMUX ] && exec tmux -u2 new-session
        # Show motd if we haven't already
        if [ -z "$_motd_listed" ]; then
            case "$TMUX_PANE" in
                %0) if [ -f /run/motd.dynamic ]; then
                        cat /run/motd.dynamic
                    fi
                    if [ -f /etc/motd ]; then
                        cat /etc/motd
                    fi
                    export _motd_listed=yes
                    ;;
                *)  ;;
            esac
        fi
    fi
fi
