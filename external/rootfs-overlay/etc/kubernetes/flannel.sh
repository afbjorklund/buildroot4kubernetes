kubeadm init --pod-network-cidr=10.244.0.0/16 \
             --kubernetes-version=v1.23.5

export KUBECONFIG=/etc/kubernetes/admin.conf
kubectl apply -f /etc/kubernetes/flannel.yml
