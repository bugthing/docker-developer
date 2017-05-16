docker-developer
================

Docker container to use for web development. Intended to be a portable dev enviroment
containing vim, tmux and other typical development type stuff.

## My Usage

1. Fire up the container

    docker run -d --name developer --restart always --net host -e DOCKER_HOST=0.0.0.0:4243 -v /container-volumes/developer-home:/home/developer bugthing/docker-developer

2. Configure my desktop machine to start a container and execute docker command to get inside the container

    docker exec -it developer bash

## First time usage

0. Configure your shell

    /opt/nvm/install.sh
    source ~/.nvm/nvm.sh
    source /usr/local/share/chruby/chruby.sh

1. Install a ruby version

    ruby-install ruby 2.3.4

    PKG_CONFIG_PATH=/usr/lib/openssl-1.0/pkgconfig ruby-install ruby 2.3.4

2. Install a NodeJS version

    nvm install 6.10.0

3. Grab my dotfiles

    gem install dotty
    dotty add default https://github.com/bugthing/dotty.git

4. Setup vim

```
    git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    vim +PluginInstall +qall
```

## Services

The container uses supervisor to start a number of services with in the container

### Cron

Scheduled tasks

### SSH

SSH access to the container

### VNC

There is an x11vnc server available for use, just ensure you start the container with the correct
port exposed. Add the following switch

    -p 9590:5900

Then you can connect via VNC to:

    vnc rdp://0.0.0.0:9590

