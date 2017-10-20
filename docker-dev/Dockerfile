FROM debian:latest

# Install packages and populate command-not-found db
RUN apt update && apt install -y \
    bash-completion \
    colortest \
    command-not-found \
    git \
    htop \
    locales \
    man-db \
    pandoc \
    tmux \
    tree \
    vim-gtk \
    xclip \
    xterm \
 && apt update \
 && update-command-not-found

# Configure timezone and locale
ENV TZ=America/New_York
RUN echo $TZ > /etc/timezone && \
    dpkg-reconfigure -f noninteractive tzdata && \
    sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    echo 'LANG="en_US.UTF-8"'>/etc/default/locale && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8

# Copy fonts and X defaults
COPY ["Inconsolata for Powerline.otf", "/usr/share/fonts/"]
COPY [".Xdefaults", "/root/.Xdefaults"]
COPY [".gvimrc", "/root/.gvimrc"]

# Set up my dotfiles
WORKDIR /root
RUN git clone http://github.com/PurpleGuitar/dotfiles
WORKDIR /root/dotfiles
RUN ./install.sh
WORKDIR /root
RUN rm -rf dotfiles-backup*
