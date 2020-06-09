FROM fedora:31

MAINTAINER James Harrington

RUN dnf update -y
RUN dnf install bind-utils findutils iputils telnet \
traceroute net-tools procps-ng tcpdump iperf iperf3 -y

# Expose port for iPerf server
EXPOSE 5001

CMD tail -f /dev/null
