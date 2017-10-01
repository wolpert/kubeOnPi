== Getting Kubernetes on Raspberry Pi

==== Image setup

 - wget https://github.com/hypriot/image-builder-rpi/releases/download/v1.5.0/hypriotos-rpi-v1.5.0.img.zip

 - unzip hypriotos-rpi-v1.5.0.img.zip

 - curl -O https://raw.githubusercontent.com/hypriot/flash/master/$(uname -s)/flash
 - chmod +x flash

 - flash -n kmaster-01 hypriotos-rpi-v1.5.0.img  # Flashing img to sdcard. Name = kmaster-01

 

==== Set up master and node

    - sudo su
    - curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg |sudo apt-key add -

    - cat <<EOF > /etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF

    - sudo apt-get update && \
sudo apt-get upgrade -y && \
sudo apt-get install kubeadm -y && \
sudo apt-get autoclean && \
sudo apt-get autoremove -y && \
sudo reboot

==== Kubernetes install (master)

    - sudo kubeadm init --config kubeadm.yaml  #Yaml from workshop
    - mkdir -p $HOME/.kube
    - sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
    - sudo chown $(id -u):$(id -g) $HOME/.kube/config
    - kubectl apply -f https://git.io/weave-kube-1.6
    - # On node, execute kubeadm join from kubeadmin init output

    - curl -sSL https://rawgit.com/coreos/flannel/v0.7.1/Documentation/kube-flannel-rbac.yml | kubectl create -f -
    - curl -sSL https://rawgit.com/coreos/flannel/v0.7.1/Documentation/kube-flannel.yml | sed "s/amd64/arm/g" | kubectl create -f -

    - kubectl --namespace kube-system get svc,deployment,rc,rs,pods,nodes  # Check for everything running


==== Node cleanup:

    - kubeadm reset
    - rm -rf /var/lib/cni
    - rm -rf /run/flannel
    - rm -rf /etc/cni
    - ifconfig cni0 down
    - brctl delbr cni0  # May not be installed
