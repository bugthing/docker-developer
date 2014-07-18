docker-developer
================

Docker container to use for web development. It should be a nice portable enviroment
containing a configured vim, ruby, nodejs and other typical development type stuff.

## Build

    docker build -t developer .

## Fire up the container and connect in via ssh ..

    docker run -d -p 9980:5200 -p 9920:22 -t developer /bin/bash

    ssh -A -p 9920 developer@localhost  # password is 'developer'

