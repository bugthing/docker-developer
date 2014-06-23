FROM base/devel
RUN pacman -Sy --noconfirm wget curl vim libyaml openssh
RUN cd / && \
    wget -O ruby-install-0.4.3.tar.gz https://github.com/postmodern/ruby-install/archive/v0.4.3.tar.gz && \
    tar -xzvf ruby-install-0.4.3.tar.gz && \
    cd ruby-install-0.4.3/ && \
    make install && \
    ruby-install ruby 2.0.0-p481
RUN cd / && \
    wget -O chruby-0.3.8.tar.gz https://github.com/postmodern/chruby/archive/v0.3.8.tar.gz && \
    tar -xzvf chruby-0.3.8.tar.gz && \
    cd chruby-0.3.8/ && \
    make install
RUN cd / && mkdir /opt/nodejs && \
    curl http://nodejs.org/dist/v0.10.29/node-v0.10.29-linux-x64.tar.gz | tar xzvf - --strip-components=1 -C "/opt/nodejs/"
ENV PATH /opt/rubies/ruby-2.0.0-p481/bin:/opt/nodejs/bin:$PATH
ENV HOME /root
RUN gem install dotty && dotty add dotty https://github.com/bugthing/dotty.git && dotty bootstrap dotty
RUN pacman -Sy --noconfirm ctags git subversion s3cmd
RUN mkdir ~/temp && chmod 777 ~/temp
RUN vim -es <<<BundleInstall
