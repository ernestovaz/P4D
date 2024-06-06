FROM ubuntu:latest

RUN apt update -y
RUN apt install -y net-tools iproute2 python3 python3-scapy ethtool iperf vim
COPY send.py receive.py /
