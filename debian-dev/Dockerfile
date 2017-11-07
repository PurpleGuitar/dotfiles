FROM debian:latest

# Install packages and populate command-not-found db
RUN apt update && apt install -y \
    apt-utils \
    bash-completion \
    colortest \
    command-not-found \
    git \
    htop \
    jq \
    locales \
    make \
    man-db \
    pandoc \
    python \
    python-pip \
    python3 \
    python3-pip \
    tmux \
    tree \
    vim-gtk \
    wget \
    xclip \
    xterm \
 && apt update \
 && update-command-not-found

# Setup Python3 packages
RUN pip3 install --upgrade pip \
 && pip3 install pylint \
 && pip3 install requests

# Configure timezone and locale
RUN echo $TZ > /etc/timezone \
 && dpkg-reconfigure -f noninteractive tzdata \
 && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
 && echo 'LANG="en_US.UTF-8"'>/etc/default/locale \
 && dpkg-reconfigure --frontend=noninteractive locales \
 && update-locale LANG=en_US.UTF-8
ENV TZ=America/New_York
ENV LANG=en_US.UTF-8

# Set up my dotfiles
WORKDIR /root
RUN git clone http://github.com/PurpleGuitar/dotfiles \
 && cd dotfiles \
 && ./install.sh \
 && cd /root \
 && rm -rf dotfiles-backup*
VOLUME ["/root/dotfiles"]

# Copy fonts and X defaults
WORKDIR /usr/share/fonts
RUN wget https://raw.githubusercontent.com/powerline/fonts/master/Inconsolata/Inconsolata%20for%20Powerline.otf \
 && wget https://raw.githubusercontent.com/powerline/fonts/master/UbuntuMono/Ubuntu%20Mono%20derivative%20Powerline.ttf
COPY [".Xdefaults", "/root/.Xdefaults"]
COPY [".gvimrc", "/root/.gvimrc"]
COPY [".bashrc-local", "/root/.bashrc-local"]

# Start in home dir
WORKDIR /root
