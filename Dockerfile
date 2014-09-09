
FROM base/devel

RUN \
    echo 'en_GB.UTF-8 UTF-8' > /etc/locale.gen && echo 'LANG="en_GB.UTF-8"' > /etc/locale.conf && locale-gen &&\
    pacman -Syyu &&\
    pacman -S --noconfirm base-devel wget curl libyaml openssh ctags subversion s3cmd git vim tmux ack jre8-openjdk &&\
    mkdir -p /root/src &&\
    cd /root/src &&\
    echo "%wheel        ALL=NOPASSWD: ALL" >> /etc/sudoers &&\
    wget -O ruby-install-0.4.3.tar.gz https://github.com/postmodern/ruby-install/archive/v0.4.3.tar.gz &&\
    tar -xzvf ruby-install-0.4.3.tar.gz &&\
    cd ruby-install-0.4.3/ &&\
    make install &&\
    cd /root/src &&\
    wget -O chruby-0.3.8.tar.gz https://github.com/postmodern/chruby/archive/v0.3.8.tar.gz &&\
    tar -xzvf chruby-0.3.8.tar.gz &&\
    cd chruby-0.3.8/ &&\
    make install &&\
    mkdir /opt/container_bin/ &&\
    /usr/bin/ssh-keygen -A &&\
    sed -i -e 's/^UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config &&\
    useradd -m -g users -G wheel -s /bin/bash --home-dir /home/developer developer &&\
    echo 'root:root' | chpasswd &&\
    echo 'developer:developer' | chpasswd &&\
    cd /

ADD files/chruby.sh /etc/profile.d/chruby.sh

ADD files/container_prepare /opt/container_bin/container_prepare
RUN chmod -R +x /opt/container_bin
ENV PATH /opt/container_bin/:$PATH

EXPOSE 22

CMD container_prepare && /usr/bin/sshd -D
