FROM debian:12.2

# set environment variables for tzdata
ARG TZ=America/New_York
ENV TZ=${TZ}

# include manual pages and documentation
ARG DEBIAN_FRONTEND=noninteractive

# install all remaining packages for Weenix
RUN apt-get update && apt-get -y install\
    gcc-12\
    cscope\
    nasm\
    make\
    build-essential\
    grub2-common\
    xorriso\
    genisoimage\
    xterm\
    gdb-multiarch\
    mesa-utils\
    libgl1-mesa-glx\
    grub-pc-bin\
    python3\
    python3-pip\
    python3-pyelftools\
    qemu-system-x86\
    cmake

# install useful interactive programs
RUN apt-get update && apt-get -y install\
  sudo\
  vim\
  git\
  wget\
  nano

# Clean up temporary files
WORKDIR /
RUN rm -rf /tmp/*

# set up default locale
RUN apt-get update && apt-get install -y locales \
    && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
    && locale-gen en_US.UTF-8 \
    && update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8
  
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

# remove unneeded .deb files
RUN rm -r /var/lib/apt/lists/*

# set up passwordless sudo for user cs1670-user
RUN useradd -m -s /bin/bash cs1670-user && \
  echo "cs1670-user ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers.d/cs1670-init

# create binary reporting version of dockerfile
RUN (echo '#\!/bin/sh'; echo 'if test "x$1" = x-n; then echo 12; else echo 12.arm64; fi') > /usr/bin/cs1670-docker-version; chmod ugo+rx,u+w,go-w /usr/bin/cs1670-docker-version

# git build arguments
ARG USER=CS1670 User
ARG EMAIL=nobody@example.com

# configure your environment
USER cs1670-user
RUN git config --global user.name "${USER}" && \
  git config --global user.email "${EMAIL}" && \
  (echo "(custom-set-variables"; echo " '(c-basic-offset 4)"; echo " '(indent-tabs-mode nil))") > ~/.emacs && \
  (echo "set expandtab"; echo "set shiftwidth=4"; echo "set softtabstop=4") > ~/.vimrc && \
  (echo "if test -f /run/host-services/ssh-auth.sock; then"; echo "  sudo chown cs1670-user:cs1670-user /run/host-services/ssh-auth.sock"; echo "fi") > ~/.bash_profile && \
  echo ". ~/.bashrc" >> ~/.bash_profile && \
  echo "export PATH=/usr/x86_64-linux-gnu/bin:\$PATH" >> ~/.bashrc && \
  rm -f ~/.bash_logout && \
  echo "add-auto-load-safe-path ~" > ~/.gdbinit

WORKDIR /home/cs1670-user
CMD ["/bin/bash", "-l"]

# Initial version of this Dockerfile by Todd Morrill, CS 61 DCE student
