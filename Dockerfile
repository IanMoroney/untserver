FROM steamcmd/steamcmd:ubuntu-18

STOPSIGNAL SIGTERM

##############BASE IMAGE##############

####Labels####
LABEL maintainer="ian moroney"
LABEL build_version="version: 0.1"

#####Dependencies####

# LinuxGSM dependencies
RUN dpkg --add-architecture i386 && \
	apt update -y && \
	apt install -y --no-install-recommends \
		nano \
		iproute2 \
		curl \
		wget \
		file \
		bzip2 \
		gzip \
		unzip \
		bsdmainutils \
		python3 \
		util-linux \
		ca-certificates \
		binutils \
		bc \
		jq \
		tmux \
		lib32gcc1 \
		lib32stdc++6 \
		libstdc++6 \
		libstdc++6:i386 \
		telnet \
		expect \
		netcat \
		locales \
		libgdiplus \
		cron \
		tclsh \
		cpio \
		libsdl2-2.0-0:i386 \
		xz-utils

# Install gamedig
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash - ; \
	apt install -y nodejs && npm install -g gamedig

# Install latest su-exec
RUN  set -ex; \
		\
		curl -o /usr/local/bin/su-exec.c https://raw.githubusercontent.com/ncopa/su-exec/master/su-exec.c; \
		\
		fetch_deps='gcc libc-dev'; \
		apt-get install -y --no-install-recommends $fetch_deps; \
		gcc -Wall \
				/usr/local/bin/su-exec.c -o/usr/local/bin/su-exec; \
		chown root:root /usr/local/bin/su-exec; \
		chmod 0755 /usr/local/bin/su-exec; \
		rm /usr/local/bin/su-exec.c; \
		\
		apt-get purge -y --auto-remove $fetch_deps

# Clear unused files
RUN apt clean && \
    rm -rf \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/*
		
#####Dependencies####

# Create user and fix permissions - chown shouldn't be necessary check adduser command
RUN adduser --home /home/untserver --disabled-password --shell /bin/bash --disabled-login --gecos "" untserver
RUN cp -R /root/.steam /home/untserver/.steam
RUN chown -R untserver:untserver /home/untserver

##Need use xterm for LinuxGSM##
ENV PUID=1000 PGID=1000 TimeZone=Europe/London HOME=/home/untserver LANG=en_US.utf8 TERM=xterm DEBIAN_FRONTEND=noninteractive \
	START_MODE=0 \
	VERSION=stable

# Base dir
WORKDIR /home/untserver

# Download LinuxGSM scripts
RUN wget -O linuxgsm.sh https://linuxgsm.sh && chmod +x linuxgsm.sh && su-exec untserver bash linuxgsm.sh untserver

##############BASE IMAGE##############

# Add files
COPY --chmod=755 install.sh user.sh /home/untserver/
COPY --chmod=755 scripts/ /home/untserver/scripts

##############EXTRA CONFIG##############
#Ports
EXPOSE 27015 27015/UDP 27016/UDP 8082 8081 8080

#Shared folders to host
VOLUME /home/untserver/serverfiles/ /home/untserver/.steam/ /home/untserver/log/ /home/untserver/lgsm/backup/ /home/untserver/lgsm/config-lgsm/untserver/
##############EXTRA CONFIG##############

ENTRYPOINT ["/home/untserver/user.sh"]