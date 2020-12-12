
# Init Control plane node

# Generate a bootstrap token to authenticate nodes joining the cluster
TOKEN=$(sudo kubeadm token generate)
echo $TOKEN

sudo kubeadm init  --token=${TOKEN} --kubernetes-version=v1.19.0 --pod-network-cidr=10.244.0.0/16

# Create .kube directroy

    mkdir -p $HOME/.kube
    sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config > kube-flannel.yml
    sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Deploy Flanel CNI

 curl -sSL https://raw.githubusercontent.com/coreos/flannel/v0.12.0/Documentation/kube-flannel.yml
 kubectl apply -f kube-flannel.yml

#Download calica yaml. Change pod CIDR to 10.100.0.0/16 and apply
#
#    wget https://docs.projectcalico.org/v3.11/manifests/calico.yaml
#    nano calico yaml
#    kubectl apply -f calico.yaml
