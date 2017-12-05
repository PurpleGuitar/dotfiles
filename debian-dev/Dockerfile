FROM debian:latest

# Install packages and populate command-not-found db
RUN apt update && apt install -y \
    apt-utils \
    bash-completion \
    ccze \
    colortest \
    command-not-found \
    curl \
    figlet \
    git \
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
    tig \
    tmux \
    tree \
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
 && pip3 install coverage \
 && pip3 install pylint \
 && pip3 install requests

# Setup Node.js
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - \
 && apt-get install -y nodejs

# Copy fonts and X defaults
WORKDIR /usr/share/fonts
RUN wget https://raw.githubusercontent.com/powerline/fonts/master/Inconsolata/Inconsolata%20for%20Powerline.otf \
 && wget https://raw.githubusercontent.com/powerline/fonts/master/UbuntuMono/Ubuntu%20Mono%20derivative%20Powerline.ttf
COPY [".Xdefaults", "/root/.Xdefaults"]
COPY [".gvimrc", "/root/.gvimrc"]
COPY [".bashrc-local", "/root/.bashrc-local"]
RUN chmod 600 /root/.Xdefaults \
 && chmod 600 /root/.gvimrc \
 && chmod 600 /root/.bashrc-local

# Set up my dotfiles
WORKDIR /root/working
COPY [".vimrc-local", "/root/.vimrc-local"]
RUN git clone http://github.com/PurpleGuitar/dotfiles \
 && cd dotfiles \
 && ./install.sh \
 && cd /root \
 && rm -rf dotfiles-backup*

# Set up z tool and persist dir list between sessions
WORKDIR /root/working
ENV _Z_DATA=/root/working/.z
RUN git clone https://github.com/rupa/z

# Persist bash history between sessions
WORKDIR /root/working
RUN touch .bash_history \
 && cd /root \
 && ln -s working/.bash_history
VOLUME ["/root/working"]

# Start in home dir
WORKDIR /root
