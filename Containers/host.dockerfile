FROM alpine:latest

RUN apt update -y
RUN apt install -y net-tools iproute2 python3 python3-scapy ethtool iperf
