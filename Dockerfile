
# Start from a basic arch linux image
FROM base/archlinux

# Setup locale. Install packages. Setup sudo. Generate ssh key. Set root password. Add developer user. Add container_bin dir. Create xinit for developer
RUN \
    echo 'en_GB.UTF-8 UTF-8' > /etc/locale.gen && echo 'LANG="en_GB.UTF-8"' > /etc/locale.conf && locale-gen &&\
    (yes | pacman -Syyu) &&\
    pacman -S --noconfirm base-devel libyaml postgresql-libs libmariadbclient \
      pkgfile ctags s3cmd ack wget curl ack supervisor cronie rsync \
      openssh subversion git vim tmux \
      jre8-openjdk nodejs python perl sqlite \
      xorg-server xorg-server-xvfb openbox x11vnc xterm phantomjs docker firefox \
      &&\
    \
    ssh-keygen -A &&\
    echo 'root:root' | chpasswd &&\
    echo "%wheel        ALL=NOPASSWD: ALL" >> /etc/sudoers &&\
    \
    useradd -m -g users -G wheel -s /bin/bash --home-dir /home/developer developer &&\
    echo 'developer:developer' | chpasswd &&\
    su - developer -c 'GEMDIR=`ruby -e "print Gem.user_dir"`; echo "PATH=$GEMDIR/bin:$PATH" >> ~/.bashrc' &&\
    \
    mkdir /opt/container_bin


# From github - Install ruby-install. Install chruby.
RUN \
    mkdir -p /root/src &&\
    cd /root/src &&\
    wget -O ruby-install-0.5.0.tar.gz https://github.com/postmodern/ruby-install/archive/v0.5.0.tar.gz &&\
    tar -xzvf ruby-install-0.5.0.tar.gz &&\
    cd ruby-install-0.5.0/ &&\
    make install &&\
    \
    cd /root/src &&\
    wget -O chruby-0.3.9.tar.gz https://github.com/postmodern/chruby/archive/v0.3.9.tar.gz &&\
    tar -xzvf chruby-0.3.9.tar.gz &&\
    cd chruby-0.3.9/ &&\
    make install &&\
    \
    cd /

# From AUR - Install pacaur
RUN \
    cd /root/src &&\
    wget -O cower.tar.gz https://aur.archlinux.org/packages/co/cower/cower.tar.gz &&\
    tar xzf cower.tar.gz &&\
    cd cower &&\
    makepkg --noconfirm --asroot -s &&\
    pacman -U --noconfirm cower-*.pkg.tar.xz &&\
    \
    cd /root/src &&\
    wget -O pacaur.tar.gz https://aur.archlinux.org/packages/pa/pacaur/pacaur.tar.gz &&\
    tar xzf pacaur.tar.gz &&\
    cd pacaur &&\
    makepkg --noconfirm --asroot -s &&\
    pacman -U --noconfirm pacaur-*.pkg.tar.xz &&\
    \
    cd /

# Add some configs, set the container_prepare script
ADD files/sshd_config /etc/ssh/sshd_config
ADD files/chruby.sh /etc/profile.d/chruby.sh
ADD files/container_prepare /opt/container_bin/container_prepare
RUN chmod -R +x /opt/container_bin
ENV PATH /opt/container_bin/:$PATH

# Add service configs
ADD files/cron-supervisor.ini /etc/supervisor.d/cron.ini
ADD files/ssh-supervisor.ini /etc/supervisor.d/ssh.ini
ADD files/xvfb-supervisor.ini /etc/supervisor.d/xvfb.ini
ADD files/x11vnc-supervisor.ini /etc/supervisor.d/x11vnc.ini
ADD files/openbox-supervisor.ini /etc/supervisor.d/openbox.ini

# Expose port for ssh, web, vnc and some spares
EXPOSE 22 80 443 5900 8080 8081 8082 8083 8084 8085 8086 8087 8088 8089

# Run the prepare script and fire up supervisord
CMD container_prepare && /usr/bin/supervisord -n -c /etc/supervisord.conf
