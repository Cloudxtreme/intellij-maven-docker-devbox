IntelliJ and Maven Java Development Environment in a Docker Container
---------------------------------------------------------------------

This Docker image is based off the official library java openjdk image which runs Debian.  I have extended it to contain an IntelliJ IDEA installation and Maven.  These will then run under a `dev` user.

Usage
-----
	$ xhost +
	$ export DISPLAY=:0.0
	$ docker build -t java-devbox .
	$ docker run -it -e DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix --name java-proj-1 java-devbox
