#!/bin/bash
# Runs the docket pihone instance connecting to OpenDNS servers.
# This instance has an IP of 10.1.1.1 and connects to the host via
# macvlan bridge
sudo podman run -d \
     --name pihole \
     --cap-add="NET_ADMIN,NET_RAW" \
     -e WEBPASSWORD=a1b2c3d4 \
     -e DNS1=208.67.222.222 \
     -e DNS2=208.67.220.220 \
     -e FTLCONF_LOCAL_IPV4=10.1.1.1 \
     -v "./pihole:/etc/pihole:z" \
     -v "./dnsmasq.d:/etc/dnsmasq.d:z" \
     -p 53:53/tcp \
     -p 53:53/udp \
     -p 67:67/udp \
     -p 80:80/tcp \
     --net=pmvlan \
     --ip=10.1.1.1 \
     --restart=unless-stopped \
     --hostname phpod \
     -e TZ="Americas/Chicago" \
     docker.io/pihole/pihole:latest
