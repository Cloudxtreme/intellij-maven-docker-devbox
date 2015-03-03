FROM java:openjdk-8-jdk
MAINTAINER Tom Barlow <tomwbarlow@gmail.com>

RUN apt-get update
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get install -y \
	locales \
	gnutls-bin \
	curl \
	wget \
	tmux \
	sudo

RUN useradd dev
RUN echo "ALL            ALL = (ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN cp /usr/share/zoneinfo/Europe/Dublin /etc/localtime && \
    echo "en_IE.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen && \
    dpkg-reconfigure locales && \
    /usr/sbin/update-locale LANG=en_IE.UTF-8
ENV LC_ALL en_IE.UTF-8

ENV HOME /home/dev
WORKDIR ${HOME}

RUN wget -O ${HOME}/idea.tar.gz http://download.jetbrains.com/idea/ideaIC-14.0.3.tar.gz && \
    tar zxvf ${HOME}/idea.tar.gz && \
    mv ${HOME}/idea-IC-139.1117.1/bin/idea.sh ${HOME}/idea-IC-139.1117.1/bin/idea
    rm ${HOME}/idea.tar.gz
ENV PATH ${HOME}/idea-IC-139.1117.1/bin:${PATH}

# Maven
RUN wget -O ${HOME}/maven.tar.gz http://www.webhostingjams.com/mirror/apache/maven/maven-3/3.2.5/binaries/apache-maven-3.2.5-bin.tar.gz && \
    tar zxvf ${HOME}/maven.tar.gz && \
    rm ${HOME}/maven.tar.gz
ENV M2_HOME ${HOME}/apache-maven-3.2.5
ENV PATH ${M2_HOME}/bin:${PATH}

# latest docker binary
RUN wget https://get.docker.io/builds/Linux/x86_64/docker-latest -O /usr/local/bin/docker && \
    chmod +x /usr/local/bin/docker

RUN chown -R dev:dev ${HOME} && \
    groupadd -g 1002 docker && \
    usermod -aG docker dev

USER dev
CMD ["/bin/bash"]
