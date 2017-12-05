# Abort if not running interactively
[ -z "$PS1" ] && return


# History Options
export HISTCONTROL=ignorespace:ignoredups:erasedups
export HISTFILESIZE=5000
shopt -s histappend


# Aliases
alias ls='ls -hF --color=tty' # classify files in colour
alias grep='grep --color=auto' # Show grep matches in color
alias cmatrix='cmatrix -b'    # Always use bold for cmatrix -- looks extra awesome
alias h='history'
alias reboot-required='if [ -f /var/run/reboot-required ]; then echo "Yes, reboot required" ; else echo "No, reboot not required" ; fi'
alias in-vim-shell='if [[ $(env | grep VIMRUNTIME) ]]; then echo "Yes, running in a Vim shell" ; else echo "No, not running in a Vim shell" ; fi'
alias xt='xterm -e "tmux -2" &'


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


# Use local man directory if it exists
if [ -d $HOME/.local/share/man ]; then
    MANPATH=$HOME/.local/share/man:$MANPATH
    export MANPATH
fi


# Load bashrc prompt
if [ -f ~/.bashrc-prompt ]; then
    source ~/.bashrc-prompt
fi


# Load local bashrc script if it exists
if [ -f ~/.bashrc-local ]; then
    source ~/.bashrc-local
fi


# Launch tmux if available
if command -v tmux>/dev/null; then
    if [ ! -z "$PS1" ]; then # unless shell not loaded interactively, run tmux
        [[ ! $TERM =~ screen ]] && [ -z $TMUX ] && exec tmux -2 new-session
        # If in TMUX, show MOTD if we haven't already
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
