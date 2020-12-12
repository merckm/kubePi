# Basic setup of Raspberry
Install 64bit OS (Ubuntu 64 Bit 20.10 Server)
This installation follws the article 
https://opensource.com/article/20/6/kubernetes-raspberry-pi

## Setup before first boot
On PC edit an add WLAN configuration

the newly images system should mount as system-boot
On that drive there is a file called

network-config

In this file uncomment the wlan settings and configre for your environment (SSID and Password)
If you already booted the system configure using the file: /etc/netplan/50-cloud-init.yaml

check network connectivity

ip a

## Set keyboard layout for console and timezone
On console do the following:

sudo dpkg-reconfigure keyboard-configuration
sudo setupcon
sudo timedatectl set-timezone Europe/Berlin

Use on screen menu to set Keyboard layout.
Reboot

## Set host name
sudo hostnamectl set-hostname <hostname>
hostnamectl

edit /etc/hosts
Add at least a row for 127.0.0.1 <hostname>

## Turn off swap ????
Remove swap as it is not supported with ubernetes

    sudo dphys-swapfile swapoff && \
    sudo dphys-swapfile uninstall && \
    sudo update-rc.d dphys-swapfile remove

To test that swap is realy off

    sudo swapon --summary

## Install Docker

  sudo apt install -y docker.io
  sudo docker info

# Create or replace the contents of /etc/docker/daemon.json to enable the systemd cgroup driver

$ sudo cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

## Append the cgroups and swap options to the kernel command line
# Note the space before "cgroup_enable=cpuset", to add a space after the last existing item on the line
sudo sed -i '$ s/$/ cgroup_enable=cpuset cgroup_enable=memory cgroup_memory=1 swapaccount=1/' /boot/firmware/cmdline.txt


## Let iptables see bridge traffic
# Enable net.bridge.bridge-nf-call-iptables and -iptables6
    cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
    net.bridge.bridge-nf-call-ip6tables = 1
    net.bridge.bridge-nf-call-iptables = 1
    EOF

    sudo sysctl --system

## Install Kubernetes packages for Ubuntu

### Add the packages.cloud.google.com atp key
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

### Add the Kubernetes repo
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

### Install kubeadm, kubelet and kubectl

sudo apt update && sudo apt install -y kubelet kubeadm kubectl

sudo apt-mark hold kubelet kubeadm kubectl


## Reboot your system

sudo reboot
