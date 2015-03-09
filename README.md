IntelliJ and Maven Java Development Environment in a Docker Container
---------------------------------------------------------------------

This Docker image is based off the official library java openjdk image which runs Debian.  I have extended it to contain an IntelliJ IDEA installation and Maven.  These will then run under a `dev` user.

Usage
-----
	$ xhost +
	$ export DISPLAY=:0.0
	$ docker build -t java-devbox .
	$ docker run -it -e DISPLAY \
		-v /tmp/.X11-unix:/tmp/.X11-unix \
		java-devbox

This should drop you into a bash shell, from here I would usually start `tmux` and create a new window to run `idea`.

X11 Forwarding
--------------
One of the things I've been doing is running this container on a Linux server, I then ssh into the server with a client with XForwarding support (e.g. Putty/XMing).  In order allow for XForwarding over the network, you'll probably need to run the container with a couple of additional parameters/flags:

        $ docker run -it -e DISPLAY \
                -v /tmp/.X11-unix:/tmp/.X11-unix \
                -v ~/.Xauthority:/home/dev/.Xauthority \
                --net=host \
                java-devbox

`~/.Xauthority` needs to be mounted as a volume for authentication, and the `--net=host` parameter is used as `localhost` in a default docker container is namespaced away from `localhost` for the actual Docker host.
