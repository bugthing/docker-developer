docker-developer
================

Docker container to use for web development. It should be a nice portable enviroment
containing a configured vim, ruby, nodejs and other typical development type stuff.

## Fire up the container and connect in via ssh ..

    docker run -d -t -p 9980:5200 -p 9920:22 -t bugthing/docker-developer

    ssh -A -p 9920 developer@localhost  # password is 'developer'

## Build

    docker build -t bugthing/developer .
