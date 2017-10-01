#!/bin/bash

# Execute by calling sudo on this file. Run once after node install

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg |sudo apt-key add -

cat <<EOF > /etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF

apt-get update && \
    apt-get upgrade -y && \
    apt-get install kubeadm -y && \
    apt-get autoclean && \
    apt-get autoremove -y && \
    reboot
