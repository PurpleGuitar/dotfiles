# Abort if not running interactively
[ -z "$PS1" ] && return


# ==============================================================================
# Start in TMUX if available
# ==============================================================================

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
# export BASHRC_NO_TMUX="true" # Disable automatic tmux session
if [[ -z ${BASHRC_NO_TMUX} ]]; then
    if command -v tmux >/dev/null 2>&1; then
        if [ ! -z "$PS1" ]; then
            TTY_TMUX_PANE=$(tmux_pane_id)
            [ -z $TTY_TMUX_PANE ] && exec tmux -2 new-session
            if [ "$TMUX_PANE" == "%0" ] && [ ${SHLVL} -eq 1 ]; then
                if [ -f /run/motd.dynamic ]; then
                    cat /run/motd.dynamic
                fi
                if [ -f /etc/motd ]; then
                    cat /etc/motd
                fi
                if [ -f ~/.motd ]; then
                    cat ~/.motd
                fi
            fi
            if [ $(tmux display-message -p '#{window_panes}') -gt 1 ]; then
                # If we're showing more than one pane, show the pane border statuses
                tmux set pane-border-status top
            fi
        fi
    fi
fi

# ==============================================================================
# Check OS
# ==============================================================================
if grep -qEi "(Microsoft|WSL)" /proc/version &> /dev/null ; then
    export IS_WSL=1
else
    export IS_WSL=0
fi

# ==============================================================================
# Aliases
# ==============================================================================

# classify files in colour
alias ls='ls -hF --color=tty'

# Always use color for tree, sort dirs first
alias tree='tree -C --dirsfirst'
alias tree1='tree -C --dirsfirst -L 1'
alias tree2='tree -C --dirsfirst -L 2'
alias tree3='tree -C --dirsfirst -L 3'

# Simplify du
alias du0='du --human-readable --max-depth 0'
alias du1='du --human-readable --max-depth 1'
alias du2='du --human-readable --max-depth 2'

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
alias colortest-truecolor='awk '\''BEGIN{ s="/\\/\\/\\/\\/\\"; s=s s s s s s s s; for (colnum = 0; colnum<77; colnum++) { r = 255-(colnum*255/76); g = (colnum*510/76); b = (colnum*255/76); if (g>255) g = 510-g; printf "\033[48;2;%d;%d;%dm", r,g,b; printf "\033[38;2;%d;%d;%dm", 255-r,255-g,255-b; printf "%s\033[0m", substr(s,colnum+1,1); } printf "\n"; }'\''' # from: https://gist.github.com/XVilka/8346728
alias htopu='htop -u $(whoami)'
alias lga='git lga --color=always | less -RS'
alias wlga='watch -c "git lga --color=always"'
alias reboot-required='if [ -f /var/run/reboot-required ]; then echo "Yes, reboot required" ; else echo "No, reboot not required" ; fi'
alias tka='tmux kill-session -a'
alias vim-in-shell='if [[ $(env | grep VIMRUNTIME) ]]; then echo "Yes, running in a Vim shell" ; else echo "No, not running in a Vim shell" ; fi'
alias vimtemp='VIMTEMPFILE=$(mktemp /tmp/vimtemp-XXXXXX.txt) && echo "This temp file will be deleted after you exit Vim." > ${VIMTEMPFILE} && vim ${VIMTEMPFILE} && rm ${VIMTEMPFILE}'
alias sqlite='sqlite3'

# Opening files
if [ -n ${WSL_DISTRO_NAME} ]; then
    alias xo='explorer.exe'
    alias start='explorer.exe'
else
    alias xo='xdg-open'
    alias start='xdg-open'
fi

# Angband aliases to run in console mode, and play games across machines
alias ang4='angband -mgcu -- -n4'
alias ang6='angband -mgcu -- -n6'
alias angbig='angband -mgcu -- -b'
alias angdiff='ls -l /var/games/angband/save ~/dropbox/Craig/games/angband/save ~/.angband/Angband ~/dropbox/Craig/games/angband/prefs'
alias angsave='cp -p /var/games/angband/save/* ~/dropbox/Craig/games/angband/save ; cp -p ~/.angband/Angband/* ~/dropbox/Craig/games/angband/prefs'
alias angload='cp -p ~/dropbox/Craig/games/angband/save/* /var/games/angband/save ; cp -p ~/dropbox/Craig/games/angband/prefs/* ~/.angband/Angband'


# ==============================================================================
# Command History
# ==============================================================================

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


# ==============================================================================
# Other Stuff
# ==============================================================================

# Use local bin dir
export PATH=~/.local/bin:${PATH}

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

# Override window title
pwt() {
    export PROMPT_WINDOW_TITLE=$*
}


# ==============================================================================
# Bashrc helpers
# ==============================================================================

# Load local bashrc script if it exists
if [ -f ~/.bashrc-local ]; then
    source ~/.bashrc-local
fi

# Load bashrc prompt
# (We load this after .bashrc-local so that it can set prompt preferences.)
if [ -f ~/.bashrc-prompt ]; then
    source ~/.bashrc-prompt
fi


# ==============================================================================
# Set Xterm defaults if xrdb exists
# ==============================================================================
# (We load this after .bashrc-local since it often sets the DISPLAY variable.)
if command -v xrdb> /dev/null 2>&1 && [ "$DISPLAY" ]; then
    xrdb -merge ~/.Xresources
    if [ -f ~/.Xresources-local ]; then
        xrdb -merge ~/.Xresources-local
    fi
fi
