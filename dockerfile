FROM debian
MAINTAINER Rishandi

ENV DEBIAN_FRONTEND noninteractive

RUN apt update && \
    apt upgrade -qy && \
    apt install -qy \
        libstdc++5 \
        libncurses5 \
        vim \
&& \
    mkdir -p /home/firebird && \
    cd /home/firebird

COPY firebirdss_2.1.7.18553-1_amd64.deb /home/firebird/firebird.deb
#COPY firebirdss_2.1.4.18393-1_amd64.deb /home/firebird/firebird.deb

RUN cd /home/firebird && \
    dpkg -i *.deb && \
    cd / && \
    rm -rf /home/firebird && \
    
    rm -rf /var/lib/apt/lists/*

COPY firebird.conf /opt/firebird/firebird.conf
COPY security2.fdb /opt/firebird/security2.fdb

RUN sudo mkdir /mnt/ramdisk
RUN sudo mount -t tmpfs -o rw,size=4G tmpfs /mnt/ramdisk

EXPOSE 3050/tcp
EXPOSE 3051/tcp
EXPOSE 3052/tcp

ENTRYPOINT /opt/firebird/bin/fbguard
