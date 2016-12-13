# Abort if not running interactively
[ -z "$PS1" ] && return


# History Options
export HISTCONTROL=ignorespace:ignoredups:erasedups
export HISTFILESIZE=5000
shopt -s histappend


# Aliases
alias ls='ls -hF --color=tty' # classify files in colour
alias cmatrix='cmatrix -b'    # Always use bold for cmatrix -- looks extra awesome
alias h='history'
alias apt-check='/usr/lib/update-notifier/apt-check --human-readable'
alias reboot-required='if [ -f /var/run/reboot-required ]; then echo "Yes, reboot required" ; else echo "No, reboot not required" ; fi'
alias in-vim-shell='if [[ $(env | grep VIMRUNTIME) ]]; then echo "Yes, running in a Vim shell" ; else echo "No, not running in a Vim shell" ; fi'
alias screen-saver='tmux resize-pane -Z ; tmux set -g status off ; tty-clock -rS ; tmux set -g status on ; tmux resize-pane -Z'

# Enable programmable completion features
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# Google from the command line
# From: http://superuser.com/a/47216
google() {
    search=""
    for term in $*; do
        search="$search%20$term"
    done
    lynx "http://google.com/search?q=$search" #for startpage result
}

# Load z if available
# z allows you to jump to frecently used directories
# https://github.com/rupa/z
Z_SCRIPT=~/repos/z/z.sh
if [ -f $Z_SCRIPT ]; then
    . $Z_SCRIPT
else
    z() {
        echo "z not found (expected $Z_SCRIPT)."
        echo "Get it from https://github.com/rupa/z"
    }
fi

# Ignore tty stop and start codes
if tty --quiet; then
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
        [[ ! $TERM =~ screen ]] && [ -z $TMUX ] && exec tmux new-session -A -s main
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
