FROM debian:jessie
ENV HOME /root

## Expose ports.
EXPOSE 22

MAINTAINER Javi Merino <merino.jav@gmail.com>
WORKDIR /tmp
RUN apt update && apt upgrade -y
RUN apt install -y ssh git-sh git sharutils
CMD /usr/sbin/sshd -D

## Setup service
# Setup a git user and SSH
RUN groupadd -g 987 git
RUN useradd -g git -u 987 -d /git -m -r -s /usr/bin/git-shell git
RUN sed -i -e 's/.*LogLevel.*/LogLevel VERBOSE/' /etc/ssh/sshd_config
RUN sed -i -e 's/#?UsePAM.*/UsePAM no/' /etc/ssh/sshd_config
#Set a long random password to unlock the git user account
RUN usermod -p `dd if=/dev/urandom bs=1 count=30 | uuencode -m - | head -2 | tail -1` git

# Create PrivSep directory
RUN mkdir /var/run/sshd && chmod 0755 /var/run/sshd

## Clean up
WORKDIR /
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
