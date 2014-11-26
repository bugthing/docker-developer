
FROM base/archlinux

RUN \
    echo 'en_GB.UTF-8 UTF-8' > /etc/locale.gen && echo 'LANG="en_GB.UTF-8"' > /etc/locale.conf && locale-gen &&\
    (yes | pacman -Syyu) &&\
    pacman -S --noconfirm base-devel libyaml postgresql-libs \
      openssh subversion git vim tmux \
      pkgfile ctags s3cmd ack wget curl \
      jre8-openjdk nodejs python perl sqlite \
      phantomjs docker firefox xorg-server-xvfb x11vnc xorg-xinit xorg-server xterm  \
      &&\
    \
    mkdir -p /root/src &&\
    cd /root/src &&\
    echo "%wheel        ALL=NOPASSWD: ALL" >> /etc/sudoers &&\
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
    mkdir /opt/container_bin &&\
    \
    useradd -m -g users -G wheel -s /bin/bash --home-dir /home/developer developer &&\
    echo 'developer:developer' | chpasswd &&\
    su - developer -c 'GEMDIR=`ruby -e "print Gem.user_dir"`; echo "PATH=$GEMDIR/bin:$PATH" >> ~/.bashrc' &&\
    \
    ssh-keygen -A &&\
    sed -i -e 's/^UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config &&\
    echo 'root:root' | chpasswd &&\
    \
    cp /etc/skel/.xinitrc /home/developer/.xinitrc &&\
    echo "exec xterm" >> /home/developer/.xinitrc &&\
    chown developer:users /home/developer/.xinitrc &&\
    cd /

ADD files/sshd_config /etc/ssh/sshd_config
ADD files/chruby.sh /etc/profile.d/chruby.sh

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

ADD files/container_prepare /opt/container_bin/container_prepare
RUN chmod -R +x /opt/container_bin
ENV PATH /opt/container_bin/:$PATH

EXPOSE 22 80 443 5900 8080 8081 8082 8083 8084 8085 8086 8087 8088 8089

CMD container_prepare &&\
    /usr/bin/sshd -D
