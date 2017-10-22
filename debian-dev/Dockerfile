FROM debian:latest

# Install packages and populate command-not-found db
RUN apt update && apt install -y \
    bash-completion \
    colortest \
    command-not-found \
    git \
    htop \
    locales \
    make \
    man-db \
    pandoc \
    python \
    python-pip \
    python3 \
    tmux \
    tree \
    vim-gtk \
    xclip \
    xterm \
 && apt update \
 && update-command-not-found

# Upgrade Python packages
RUN pip install --upgrade pip \
 && pip install pyyaml

# Configure timezone and locale
RUN echo $TZ > /etc/timezone && \
    dpkg-reconfigure -f noninteractive tzdata && \
    sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    echo 'LANG="en_US.UTF-8"'>/etc/default/locale && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8
ENV TZ=America/New_York
ENV LANG=en_US.UTF-8

# Set up my dotfiles
WORKDIR /root
RUN git clone http://github.com/PurpleGuitar/dotfiles
WORKDIR /root/dotfiles
RUN ./install.sh
WORKDIR /root
RUN rm -rf dotfiles-backup*

# Copy fonts and X defaults
COPY ["Inconsolata for Powerline.otf", "/usr/share/fonts/"]
COPY [".Xdefaults", "/root/.Xdefaults"]
COPY [".gvimrc", "/root/.gvimrc"]
COPY [".bashrc-local", "/root/.bashrc-local"]

