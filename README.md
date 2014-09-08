docker-developer
================

Docker container to use for web development. It should be a nice portable enviroment
containing a configured vim, ruby, nodejs and other typical development type stuff.

## Usage

1. Fire up the container .. 

    docker run -d -t -p 9920:22 -v /local/storage:/home/developer bugthing/docker-developer

2. connect in via ssh ..

    ssh -A -p 9920 developer@localhost  # password is 'developer'

3. start developing..


## Build

    docker build -t bugthing/developer .
