FROM fedora:31

MAINTAINER James Harrington

RUN dnf update -y
RUN dnf install bind-utils iputils telnet traceroute net-tools -y

CMD tail -f /dev/null
