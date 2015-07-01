FROM debian:jessie
ENV HOME /root

## Expose ports.
EXPOSE 22

## Application specific part
MAINTAINER Javi Merino <merino.jav@gmail.com>
WORKDIR /tmp
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y ssh git-sh git sharutils
CMD /usr/sbin/sshd -D

## Setup service
# Setup a git user and SSH
RUN groupadd -g 987 git && useradd -g git -u 987 -d /git -m -r -s /usr/bin/git-shell git
RUN sed -i -e 's/.*LogLevel.*/LogLevel VERBOSE/' /etc/ssh/sshd_config
RUN sed -i -e 's/#?UsePAM.*/UsePAM no/' /etc/ssh/sshd_config
#Set a long random password to unlock the git user account
RUN usermod -p `dd if=/dev/urandom bs=1 count=30 | uuencode -m - | head -2 | tail -1` git

## Remove /etc/motd
RUN rm -rf /etc/update-motd.d /etc/motd /etc/motd.dynamic 
RUN ln -fs /dev/null /run/motd.dynamic

## Clean up
WORKDIR /
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

