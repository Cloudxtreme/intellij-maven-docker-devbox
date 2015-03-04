FROM java:openjdk-8-jdk
MAINTAINER Tom Barlow <tomwbarlow@gmail.com>

RUN apt-get update
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get install -y \
	build-essential \
	gcc \
	make \
	libncurses5-dev \
	locales \
	gnutls-bin \
	curl \
	wget \
	tmux \
	less \
	mercurial \
	sudo

RUN useradd dev
RUN echo "ALL            ALL = (ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN echo "Defaults env_keep = \"http_proxy https_proxy HTTP_PROXY HTTPS_PROXY ftp_proxy FTP_PROXY NO_PROXY no_proxy\"" >> /etc/sudoers
RUN cp /usr/share/zoneinfo/Europe/Dublin /etc/localtime && \
    echo "en_IE.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen && \
    dpkg-reconfigure locales && \
    /usr/sbin/update-locale LANG=en_IE.UTF-8
ENV LC_ALL en_IE.UTF-8

ENV HOME /home/dev
WORKDIR ${HOME}
COPY . ${HOME}/.dotfiles
RUN (cd ${HOME}/.dotfiles && git submodule init && git submodule update --recursive)

RUN chsh -s /bin/bash dev
RUN ln -sf $HOME/.dotfiles/tmux.conf $HOME/.tmux.conf

RUN wget -O ${HOME}/idea.tar.gz http://download.jetbrains.com/idea/ideaIC-14.0.3.tar.gz && \
    tar zxvf ${HOME}/idea.tar.gz && \
    mv ${HOME}/idea-IC-139.1117.1/bin/idea.sh ${HOME}/idea-IC-139.1117.1/bin/idea && \
    rm ${HOME}/idea.tar.gz
ENV PATH ${HOME}/idea-IC-139.1117.1/bin:${PATH}

# Maven
RUN wget -O ${HOME}/maven.tar.gz http://www.webhostingjams.com/mirror/apache/maven/maven-3/3.2.5/binaries/apache-maven-3.2.5-bin.tar.gz && \
    tar zxvf ${HOME}/maven.tar.gz && \
    rm ${HOME}/maven.tar.gz
ENV M2_HOME ${HOME}/apache-maven-3.2.5
ENV PATH ${M2_HOME}/bin:${PATH}

# SBS Development Certificates
ADD cacerts.jks ${HOME}/certs/cacerts.jks

# Docker
RUN wget https://get.docker.io/builds/Linux/x86_64/docker-latest -O /usr/local/bin/docker && \
    chmod +x /usr/local/bin/docker

RUN echo "export PATH=${PATH}" >> ${HOME}/.profile
RUN chown -R dev:dev ${HOME} && \
    groupadd -g 1002 docker && \
    usermod -aG docker dev

# vim
RUN hg clone https://vim.googlecode.com/hg/ /tmp/vim
RUN (cd /tmp/vim && ./configure --prefix=/usr/local --enable-gui=no --without-x --disable-nls --enable-multibyte --with-tlib=ncurses --enable-pythoninterp --with-features=huge && make install)

USER dev
CMD ["/bin/bash"]

