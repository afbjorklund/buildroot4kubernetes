kubeadm init --pod-network-cidr=10.244.0.0/16 \
             --apiserver-cert-extra-sans=127.0.0.1 \
             --kubernetes-version=v1.25.0

export KUBECONFIG=/etc/kubernetes/admin.conf
kubectl apply -f /etc/kubernetes/flannel.yml
