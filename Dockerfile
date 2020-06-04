FROM fedora:31

MAINTAINER James Harrington

RUN dnf update -y
RUN dnf install bind-utils findutils iputils telnet traceroute net-tools procps-ng tcpdump iperf -y

CMD tail -f /dev/null
