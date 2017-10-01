#!/bin/bash
kubeadm reset
rm -rf /var/lib/cni
rm -rf /run/flannel
rm -rf /etc/cni
ifconfig cni0 down
brctl delbr cni0  # May not be installed
