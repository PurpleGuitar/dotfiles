# Abort if not running interactively
[ -z "$PS1" ] && return


# =======
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

# Show grep in color if possible
grep --version --color=auto &> /dev/null
if [ $? -eq 0 ]; then
    alias grep='grep --color=auto'
fi

# Other aliases
alias htopu='htop -u $(whoami)'
alias vim-in-shell='if [[ $(env | grep VIMRUNTIME) ]]; then echo "Yes, running in a Vim shell" ; else echo "No, not running in a Vim shell" ; fi'
alias reboot-required='if [ -f /var/run/reboot-required ]; then echo "Yes, reboot required" ; else echo "No, reboot not required" ; fi'


# ===============
# Command History
# ===============

# History options
alias h='history'
shopt -s histappend
export HISTCONTROL=ignoreboth:erasedups
export HISTFILESIZE=5000
function history_cleanup() {
    # Read lines added by other terminals
    history -n
    # Write updated buffer to history file
    history -w
    # Remove duplicates from history file, keeping last copy of each command
    tac ${HISTFILE} | awk '!x[$0]++' | tac > /tmp/temphist
    cp /tmp/temphist ${HISTFILE}
    rm /tmp/temphist
    # Empty history buffer in memory
    history -c
    # Read history file afresh
    history -r
}


# ===========
# Other Stuff
# ===========

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


# =====================================
# Load local bashrc script if it exists
# =====================================
if [ -f ~/.bashrc-local ]; then
    source ~/.bashrc-local
fi


# ==================
# Load bashrc prompt
# ==================
# (We load this after .bashrc-local so that preferences can be set)
if [ -f ~/.bashrc-prompt ]; then
    source ~/.bashrc-prompt
fi


# =================================
# Set Xterm defaults if xrdb exists
# =================================

# (We load this after .bashrc-local since it often sets the DISPLAY variable.)
command -v xrdb> /dev/null 2>&1 && [ "$DISPLAY" ] && xrdb -merge ~/.Xresources


# ==========
# Tmux utils
# ==========

# Get tmux session for this tty
function tmux_session_id() {
    TTY=$(tty)
    for TTY_TMUX_SESSION in $(tmux list-sessions -F "#{session_name}" 2>/dev/null); do
        tmux list-panes -F "#{pane_tty} #{session_id}" -t "${TTY_TMUX_SESSION}"
    done | grep ${TTY} | awk '{print $2}'
}

# Get tmux pane for this TTY
# (we can't use $TMUX_PANE because it might have been set by a parent shell, not this tty.)
function tmux_pane_id() {
    TTY=$(tty)
    tmux list-panes -F "#{pane_tty} #{pane_id}" -t "${TMUX_SESSION}" | grep ${TTY} | awk '{print $2}'
}

# Start in tmux if available
if command -v tmux >/dev/null 2>&1; then
    if [ ! -z "$PS1" ]; then
        TTY_TMUX_PANE=$(tmux_pane_id)
        [ -z $TTY_TMUX_PANE ] && exec tmux -2 new-session
        if [ "$TMUX_PANE" == "%0" ]; then
            if [ -f /run/motd.dynamic ]; then
                cat /run/motd.dynamic
            fi
            if [ -f /etc/motd ]; then
                cat /etc/motd
            fi
        fi
    fi
fi
