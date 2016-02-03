FROM debian:jessie
ENV HOME /root

## Expose ports.
EXPOSE 22

MAINTAINER Javi Merino <merino.jav@gmail.com>
WORKDIR /tmp
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y ssh git-sh git
CMD /usr/sbin/sshd -D

## Setup service
# Setup a git user and SSH
RUN groupadd -g 987 git
RUN useradd -g git -u 987 --home-dir /git --system --shell /usr/bin/git-shell git
RUN sed -i -e 's/.*LogLevel.*/LogLevel VERBOSE/' /etc/ssh/sshd_config
RUN sed -i -e 's/#?UsePAM.*/UsePAM no/' /etc/ssh/sshd_config

# Create PrivSep directory
RUN mkdir /var/run/sshd && chmod 0755 /var/run/sshd

## Clean up
WORKDIR /
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
