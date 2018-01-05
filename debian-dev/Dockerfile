FROM debian:latest

# Install packages and populate command-not-found db
RUN apt update && apt install -y \
    apt-utils \
    bash-completion \
    ccze \
    colortest \
    command-not-found \
    curl \
    exuberant-ctags \
    figlet \
    git \
    golang-go \
    htop \
    jq \
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
RUN pip3 install --upgrade pip \
 && pip3 install \
         coverage \
         pylint \
         requests \
         xmlrunner

# Setup Node.js
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - \
 && apt-get install -y nodejs

# Copy fonts and X defaults
WORKDIR /usr/share/fonts
RUN wget https://raw.githubusercontent.com/powerline/fonts/master/Inconsolata/Inconsolata%20for%20Powerline.otf \
 && wget https://raw.githubusercontent.com/powerline/fonts/master/UbuntuMono/Ubuntu%20Mono%20derivative%20Powerline.ttf
COPY ["Xdefaults", "/root/.Xdefaults"]
COPY ["gvimrc", "/root/.gvimrc"]
RUN chmod 600 /root/.Xdefaults \
 && chmod 600 /root/.gvimrc

# Set up my dotfiles and configure vim
WORKDIR /root/working
RUN git clone http://github.com/PurpleGuitar/dotfiles \
 && echo "set viminfo+=n/root/working/.viminfo" >> /root/.vimrc-local \
 && cd dotfiles \
 && ./install.sh \
 && cd /root \
 && rm -rf dotfiles-backup*

# Persist vim dir between sessions
WORKDIR /root/
RUN mv .vim working/ \
 && ln -s working/.vim/

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

# Setup persistent working area
VOLUME ["/root/working"]

# Start in home dir
WORKDIR /root
