function updatecluster () {

apt update
apt-cache madison kubeadm
apt-get install -y --allow-change-held-packages kubeadm=1.19.0-00

kubeadm version
kubectl drain "${1}"  --ignore-daemonsets
kubeadm upgrade plan
kubeadm upgrade apply v1.19.0
kubectl uncordon "${1}"

apt-get install -y --allow-change-held-packages kubelet=1.19.0-00 kubectl=1.19.0-00

# for more masters - sudo kubeadm upgrade node
sudo systemctl daemon-reload
sudo systemctl restart kubelet

# Workers
# check kubectl describe nodes | grep -i taint  -A3
# apt-get install -y --allow-change-held-packages kubeadm=1.19.0-00
# kubectl drain node01 --ignore-daemonsets
# kubeadm upgrade node
# apt-get install -y --allow-change-held-packages kubelet=1.19.0-00 kubectl=1.19.0-00
# sudo systemctl daemon-reload
# sudo systemctl restart kubelet
# kubectl uncordon node01

kubectl get nodes
}
