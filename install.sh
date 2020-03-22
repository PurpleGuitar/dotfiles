#!/bin/bash

# Abort on any error.
set -e

# Initialize arguments
SETUP_VIM="true"

# Check options
while [ "$#" -gt 0 ]; do
    case "$1" in
        --no-vim) SETUP_VIM="false"; shift 1;;
        -h|--help)
            echo "Installs dotfiles.";
            echo "--no-vim: Don't set up .vim directory"
            exit 0;;
        -*) echo "unknown option: $1" >&2; exit 1;;
        *) echo "unknown argument: $1" >&2; exit 1;;
    esac
done

# Check for required tools.
REQUIRED_TOOLS="realpath git tmux vim"
for REQUIRED_TOOL in $REQUIRED_TOOLS
do
    command -v $REQUIRED_TOOL >/dev/null 2>&1 || { echo >&2 "$REQUIRED_TOOL must be installed before running this script."; exit 1; }
done

# Target directory, usually the user's home dir.
# Change this variable for testing.
TARGET_DIR=$HOME

# Source directory, usually the directory the script is in.
SCRIPT_FILENAME=`realpath $0`
SCRIPT_DIR=`dirname $SCRIPT_FILENAME`

# Create backup directory
TIMESTAMP=`date +"%Y-%m-%d_%H-%M-%S"`
BACKUP_DIR="$TARGET_DIR/dotfiles-backup-$TIMESTAMP"
mkdir $BACKUP_DIR

# Function to backup file if it exists
backup_if_exists()
{
    if [ -e $1 ] ; then
       mv $1 $BACKUP_DIR
       echo "Backed up $1"
    fi
}

# Backup and link to regular dotfiles
cd $TARGET_DIR
mkdir -p .config
FILES="\
    Xresources \
    bashrc \
    bashrc-prompt \
    gitconfig \
    gvimrc \
    inputrc \
    profile \
    tmux.conf \
    vimrc \
    vimrc-plugins \
    w3m \
    config/autokey \
    "
for FILENAME in $FILES
do
    SCRIPT_DIR_FILENAME=$SCRIPT_DIR/$FILENAME
    TARGET_DIR_FILENAME=$TARGET_DIR/.$FILENAME
    backup_if_exists $TARGET_DIR_FILENAME
    ln -s $SCRIPT_DIR_FILENAME .$FILENAME
    echo "Created link to $SCRIPT_DIR_FILENAME"
done

# Vim
if [ "$SETUP_VIM" = "true" ] ; then
    echo "Setting up .vim directory..."
    VIM_DIR=$TARGET_DIR/.vim
    if [ -d $VIM_DIR ] ; then
       mv $VIM_DIR $BACKUP_DIR
       echo "Backed up $VIM_DIR"
    fi
    mkdir -p $VIM_DIR/bundle
    cd $VIM_DIR/bundle
    git clone https://github.com/VundleVim/Vundle.vim.git
    git clone https://github.com/PurpleGuitar/vim-croz-colorscheme.git
    cd $TARGET_DIR
    vim -T dumb "+set nomore" "+PluginInstall" "+qall"
else
    echo "Skipping setup of .vim directory..."
fi

# Done
echo "Done."
