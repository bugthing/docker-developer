
FROM base/devel

RUN \
    echo 'en_GB.UTF-8 UTF-8' > /etc/locale.gen && echo 'LANG="en_GB.UTF-8"' > /etc/locale.conf && locale-gen &&\
    pacman -Sy --noconfirm wget curl vim libyaml openssh ctags git subversion s3cmd &&\
    cd / &&\
    wget -O ruby-install-0.4.3.tar.gz https://github.com/postmodern/ruby-install/archive/v0.4.3.tar.gz &&\
    tar -xzvf ruby-install-0.4.3.tar.gz &&\
    cd ruby-install-0.4.3/ &&\
    make install &&\
    cd / &&\
    wget -O chruby-0.3.8.tar.gz https://github.com/postmodern/chruby/archive/v0.3.8.tar.gz &&\
    tar -xzvf chruby-0.3.8.tar.gz &&\
    cd chruby-0.3.8/ &&\
    mkdir /opt/container_bin/ &&\
    make install &&\
    ssh-keygen -A &&\
    useradd -m -g users -G wheel -s /bin/bash developer &&\
    echo -e "developer\ndeveloper" | passwd developer

USER developer
ENV HOME /home/developer
RUN \
    mkdir ~/temp ~/src ~/build ~/dev ~/bin && chmod 777 ~/temp &&\
    curl http://nodejs.org/dist/v0.10.29/node-v0.10.29-linux-x64.tar.gz | tar xzvf - --strip-components=1 -C ~/build/ &&\
    ruby-install ruby 2.0.0-p481 &&\
    echo 'alias devprep="gem install dotty && rm -rf ~/.bash* && dotty add dotty https://github.com/bugthing/dotty.git && git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim && vim +PluginInstall +qall"' >> /home/developer/.bashrc
ENV PATH $HOME/.rubies/ruby-2.0.0-p481/bin:$HOME/build/bin:$PATH

# root again and add container prepare script..
USER root
ADD files/container_prepare /opt/container_bin/container_prepare
RUN chmod -R +x /opt/container_bin
ENV PATH /opt/container_bin/:$PATH

CMD container_prepare && /usr/bin/sshd -D
