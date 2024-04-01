kubeadm init --pod-network-cidr=10.244.0.0/16 \
             --apiserver-cert-extra-sans=127.0.0.1 \
             --cri-socket=unix://var/run/cri-dockerd.sock \
             --kubernetes-version=v1.28.8

export KUBECONFIG=/etc/kubernetes/admin.conf
kubectl apply -f /etc/kubernetes/flannel.yml
