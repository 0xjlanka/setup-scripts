#!/bin/bash
# Creates a macvlan bridge on host connecting enp1s0 (10.1.0.XX/255.255.0.0)
# to 10.1.1.XX.
# In order for the gateway to work, the wifi router should be configured
# as 10.1.0.1/255.255.0.0 (or 10.1.0.1/16)

sudo ip link add macnetbr0 link enp1s0 type macvlan mode bridge
sudo ip addr add 10.1.1.2/16 dev macnetbr0
sudo ip link set macnetbr0 up
