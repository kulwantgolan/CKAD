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

#etcd backup and restore
alias e='ETCDCTL_API=3 etcdctl --endpoints=https://127.0.0.1:2379 --cacert /etc/kubernetes/pki/etcd/ca.crt --cert /etc/kubernetes/pki/etcd/server.crt --key /etc/kubernetes/pki/etcd/server.key '
alias es='e snapshot save '
alias er='e --data-dir /var/lib/etcdfb snapshot restore '
alias ek='e get / --prefix --keys-only '
alias eh='e endpoint health'

# individaully check certificate details
function icd () {
    openssl x509 -text -noout -in "${1}" 
}
function ic () {
    openssl x509 -text -noout -in "${1}" |  grep -E "Issuer|Not|Key Usage|Subject Alternative" -A1
}

# check expired certs in current folder
alias cx='ls *.crt | grep "\.crt$" | xargs -I{} openssl x509 -issuer -enddate -noout -in {}'
alias cc='ls *.crt | grep "\.crt$" | xargs -I{} openssl x509 -text -noout -in {} |  grep -E "Issuer|Not|Key Usage|Subject Alternative" -A1'

