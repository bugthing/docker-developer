
FROM base/devel

RUN \
    echo 'en_GB.UTF-8 UTF-8' > /etc/locale.gen && echo 'LANG="en_GB.UTF-8"' > /etc/locale.conf && locale-gen &&\
    (yes | pacman -Syyu) &&\
    pacman -S --noconfirm base-devel libyaml postgresql-libs \
      jre8-openjdk nodejs openssh \
      subversion git vim tmux     \
      ctags s3cmd ack wget curl   \
      phantomjs docker firefox xorg-server-xvfb    \
      &&\
    \
    mkdir -p /root/src &&\
    cd /root/src &&\
    echo "%wheel        ALL=NOPASSWD: ALL" >> /etc/sudoers &&\
    wget -O ruby-install-0.4.3.tar.gz https://github.com/postmodern/ruby-install/archive/v0.4.3.tar.gz &&\
    tar -xzvf ruby-install-0.4.3.tar.gz &&\
    cd ruby-install-0.4.3/ &&\
    make install &&\
    \
    cd /root/src &&\
    wget -O chruby-0.3.8.tar.gz https://github.com/postmodern/chruby/archive/v0.3.8.tar.gz &&\
    tar -xzvf chruby-0.3.8.tar.gz &&\
    cd chruby-0.3.8/ &&\
    make install &&\
    \
    mkdir /opt/container_bin &&\
    \
    useradd -m -g users -G wheel -s /bin/bash --home-dir /home/developer developer &&\
    echo 'developer:developer' | chpasswd &&\
    \
    ssh-keygen -A &&\
    sed -i -e 's/^UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config &&\
    echo 'root:root' | chpasswd &&\
    \
#    cd /root/src &&\
#    wget -O cower.tar.gz https://aur.archlinux.org/packages/co/cower/cower.tar.gz &&\
#    tar xzf cower.tar.gz &&\
#    cd cower &&\
#    makepkg --noconfirm --asroot -s &&\
#    pacman -U --noconfirm cower-*.pkg.tar.xz &&\
#    \
#    cd /root/src &&\
#    wget -O pacaur.tar.gz https://aur.archlinux.org/packages/pa/pacaur/pacaur.tar.gz &&\
#    tar xzf pacaur.tar.gz &&\
#    cd pacaur &&\
#    makepkg --noconfirm --asroot -s &&\
#    pacman -U --noconfirm pacaur-*.pkg.tar.xz &&\
#    \
    cd /

ADD files/sshd_config /etc/ssh/sshd_config
ADD files/chruby.sh /etc/profile.d/chruby.sh
ADD files/container_prepare /opt/container_bin/container_prepare
RUN chmod -R +x /opt/container_bin
ENV PATH /opt/container_bin/:$PATH

EXPOSE 22

CMD container_prepare && /usr/bin/sshd -D
