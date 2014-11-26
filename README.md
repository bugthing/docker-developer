docker-developer
================

Docker container to use for web development. It should be a nice portable enviroment
containing a configured vim, ruby, nodejs and other typical development type stuff.

## Usage

1. Fire up the container

    docker run -d -t -p 9920:22 -v /local/storage:/home/developer bugthing/docker-developer

2. connect in via ssh

    ssh -A -p 9920 developer@localhost  # password is 'developer'

3. start developing..

  3.1 - Setup your dot file
    gem install dotty
    dotty add dotty https://github.com/bugthing/dotty.git

  3.2 - Setup vim
    git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    vim +PluginInstall +qall

### Install a ruby

ruby-install and chruby are provided for custom rubys

    ruby-install ruby 2.0.0-p481
    source /usr/local/share/chruby/chruby.sh
    chruby ruby-2.0.0-p481


## Build image

    docker build -t bugthing/developer .
