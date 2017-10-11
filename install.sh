# Abort on any error.
set -e

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
FILES="bashrc bashrc-prompt gitconfig inputrc vimrc vimrc-plugins profile tmux.conf.common"
for FILENAME in $FILES
do
    SCRIPT_DIR_FILENAME=$SCRIPT_DIR/$FILENAME
    TARGET_DIR_FILENAME=$TARGET_DIR/.$FILENAME
    backup_if_exists $TARGET_DIR_FILENAME
    ln -s $SCRIPT_DIR_FILENAME .$FILENAME
    echo "Created link to $SCRIPT_DIR_FILENAME"
done

# tmux
echo "Setting up tmux..."
TMUX_VERSION=`tmux -V`
if [[ "$TMUX_VERSION" < "tmux 2.1" ]] ; then
    echo "tmux is older (pre v2.1): $TMUX_VERSION"
    SCRIPT_DIR_FILENAME=$SCRIPT_DIR/tmux.conf.pre21
else
    echo "tmux is recent (post v2.1): $TMUX_VERSION"
    SCRIPT_DIR_FILENAME=$SCRIPT_DIR/tmux.conf.21plus
fi
FILENAME=tmux.conf
TARGET_DIR_FILENAME=$TARGET_DIR/.tmux.conf
backup_if_exists $TARGET_DIR_FILENAME
ln -s $SCRIPT_DIR_FILENAME .tmux.conf
echo "Created link to $SCRIPT_DIR_FILENAME"

# Vim
echo "Setting up vim..."
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

# Done
echo "Done."
