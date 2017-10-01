# Getting Kubernetes on Raspberry Pi

## Image setup
```shell
wget https://github.com/hypriot/image-builder-rpi/releases/download/v1.5.0/hypriotos-rpi-v1.5.0.img.zip
unzip hypriotos-rpi-v1.5.0.img.zip
curl -O https://raw.githubusercontent.com/hypriot/flash/master/$(uname -s)/flash
chmod +x flash
flash -n kmaster-01 hypriotos-rpi-v1.5.0.img  # Flashing img to sdcard. Name = kmaster-01
```
Then reset the password on the node, add in your ssh key, etc.

## Master/node setup
```shell
ssh pirate@kmaster-01
passwd # old password hypriot
mkdir .ssh && chmod 700 .ssh && cd .ssh
echo "<your ssh key>" > authorized_keys
chmod 600 authorized_keys
cd
git clone https://github.com/wolpert/kubeOnPi
sudo ./kubeOnPi/kubernetes-install.sh
```
The node will reboot.

## Setting up kubernetes on the master
```shell
sudo kubeadm init --config kubeOnPi/kubeadm.yaml  #Yaml from kubeadm-workshop
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
kubectl apply -f https://git.io/weave-kube-1.6
# On node, execute kubeadm join from kubeadmin init output

curl -sSL https://rawgit.com/coreos/flannel/v0.7.1/Documentation/kube-flannel-rbac.yml | kubectl create -f -
curl -sSL https://rawgit.com/coreos/flannel/v0.7.1/Documentation/kube-flannel.yml | sed "s/amd64/arm/g" | kubectl create -f -

kubectl --namespace kube-system get svc,deployment,rc,rs,pods,nodes  # Check for everything running
```

## Node cleanup:
```shell
sudo ./kubeOnPi/kubernetes-cleanup.sh
```
Note that I get an error that brctl is not installed. Its cool.

This cleanup was taken from here: https://stackoverflow.com/questions/41359224/kubernetes-failed-to-setup-network-for-pod-after-executed-kubeadm-reset/41372829#41372829

## Links
 - https://github.com/luxas/kubeadm-workshop
 - https://blog.hypriot.com/post/setup-kubernetes-raspberry-pi-cluster/
 - https://kubernetes.io/docs/setup/
