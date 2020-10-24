export ns=default
alias k='kubectl -n $ns'
alias kdo='k --dry-run=client -o yaml'
alias kdor='kdo --restart=Never'
alias kaf='kubectl apply -f '
alias kdf='kubectl delete -f '
alias kt='k run --rm -it busybox --image=busybox --restart=Never'
alias ktw='k run --rm -it busybox --image=busybox --restart=Never -- wget -O- --timeout 2'
source <(kubectl completion bash)
complete -F __start_kubectl k
complete -F __start_kubectl kdo
complete -F __start_kubectl kdor
alias knt='k describe nodes | grep -i taint  -A3'
alias e='ETCDCTL_API=3 etcdctl --endpoints=https://127.0.0.1:2379 --cacert /etc/kubernetes/pki/etcd/ca.crt --cert /etc/kubernetes/pki/etcd/server.crt --key /etc/kubernetes/pki/etcd/server.key '
alias es='e snapshot save '
alias er='e --data-dir /var/lib/etcdfb snapshot restore '

