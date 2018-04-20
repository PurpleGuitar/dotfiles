FROM debian:latest

# Install packages and populate command-not-found db
RUN apt update \
 && apt upgrade -y \
 && apt install -y \
    apt-utils \
    bash-completion \
    boxes \
    ccze \
    colortest \
    command-not-found \
    curl \
    diffstat \
    exuberant-ctags \
    figlet \
    firefox-esr \
    gcj-jdk \
    git \
    golang-go \
    htop \
    jq \
    libgit2-dev \
    libxml2-utils \
    locales \
    make \
    man-db \
    ncdu \
    pandoc \
    procps \
    python \
    python-pip \
    python3 \
    python3-pip \
    ranger \
    texlive \
    texlive-latex-extra \
    tig \
    tmux \
    tree \
    uuid-runtime \
    vim-gtk \
    wget \
    xclip \
    xterm \
 && apt update \
 && update-command-not-found

# Configure timezone and locale
RUN echo $TZ > /etc/timezone \
 && dpkg-reconfigure -f noninteractive tzdata \
 && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
 && echo 'LANG="en_US.UTF-8"'>/etc/default/locale \
 && dpkg-reconfigure --frontend=noninteractive locales \
 && update-locale LANG=en_US.UTF-8
ENV TZ=America/New_York
ENV LANG=en_US.UTF-8

# Setup Python3 packages
RUN pip3 install \
    coverage \
    markdown2ctags \
    pylint \
    requests \
    xmlrunner

# Setup Node.js
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - \
 && apt-get install -y nodejs

# Set up my dotfiles and configure vim
WORKDIR /root/working
RUN git clone http://github.com/PurpleGuitar/dotfiles \
 && echo "set viminfo+=n/root/working/.viminfo" >> /root/.vimrc-local \
 && cd dotfiles \
 && ./install.sh \
 && cd /root \
 && rm -rf dotfiles-backup*
COPY [".bashrc-local", "/root/.bashrc-local"]

# Copy fonts and X defaults
WORKDIR /root
COPY ["Xdefaults", "/root/working/.Xdefaults"]
COPY ["gvimrc", "/root/working/.gvimrc"]
RUN chmod 600 /root/working/.Xdefaults \
 && chmod 600 /root/working/.gvimrc \
 && ln -s working/.Xdefaults \
 && ln -s working/.gvimrc

# Persist vim dir between sessions
WORKDIR /root/
RUN mv .vim working/ \
 && ln -s working/.vim

# Set up w3m tool and persist settings between sessions
WORKDIR /root/working
COPY ["w3m_keymap", "/root/working/.w3m/keymap"]
RUN chmod 600 /root/working/.w3m/keymap \
 && cd /root \
 && ln -s working/.w3m

# Persist bash history between sessions
WORKDIR /root/working
RUN touch .bash_history \
 && cd /root \
 && ln -s working/.bash_history

# Persist ssh keys between sessions
WORKDIR /root/working
RUN mkdir .ssh \
 && chmod 600 .ssh \
 && cd /root \
 && ln -s working/.ssh

# Setup persistent working area
VOLUME ["/root/working"]

# Start in home dir
WORKDIR /root
