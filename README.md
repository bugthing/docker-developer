docker-developer
================

Docker container to use for web development. It should be a nice portable enviroment
containing a configured vim, ruby, nodejs and other typical development type stuff.

## Build
    docker build -t developer .

## Fire up the container
    docker run -i --rm=true -p 9980:5200 developer

