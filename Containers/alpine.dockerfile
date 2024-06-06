FROM alpine:latest

RUN apk add net-tools iproute2 scapy ethtool iperf
COPY send.py receive.py /scripts/
