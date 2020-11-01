export ns=default
alias k='kubectl -n $ns'
alias kdo='k --dry-run=client -o yaml'
alias kdor='kdo --restart=Never'
alias kgo='k -o yaml get' 
alias kgop='k get pod -o yaml '
alias kgod='k get deployment -o yaml '
alias kgos='k get service -o yaml '

source <(kubectl completion bash)
complete -F __start_kubectl k
complete -F __start_kubectl kdo
complete -F __start_kubectl kdor
complete -F __start_kubectl kgo
complete -F __start_kubectl kgop
complete -F __start_kubectl kgod
complete -F __start_kubectl kgos

alias kgp='k get pods'
alias kgpwl='k get pods -o wide --show-labels'
alias kgpw='k get pods -o wide'
alias kgpl='k get pods'
alias kgd='k get deployments -o wide'
alias kgs='k get services -o wide'
alias kge='k get endpoints'

alias cdm='cd /etc/kubernetes/manifests'
alias cdk='cd /var/lib/kubelet/pki '
alias ds='docker ps -a | grep '
alias dl=' docker logs '


function kgi () {
k get all -o wide 
k get ep
k get po --show-labels
}

alias helpjp='kubectl get nodes -o jsonpath='{.items[*].status.addresses[?(@.type=="InternalIP")].address}''
alias helpcc="k get deployment -o custom-columns=DEPLOYMENT:.metadata.name,CONTAINER_IMAGE:.spec.template.spec.containers[].image,READY_REPLICAS:.status.readyReplicas,NAMESPACE:.metadata.namespace --sort-by=.metadata.name | awk '{print $1,$2,$3,$4}'" 
alias helpnc='nc -z -v -w 2 serviceip serviceport'

function patchpv () {
kubectl patch pv "${1}" -p '{"spec":{"claimRef": null}}'
}

alias ju='journalctl -u '
alias kubeletsvc='ls /etc/systemd/system/kubelet.service.d'

alias kt='k run --rm -it busybox --image=busybox:1.28 --restart=Never'
alias ktw='k run --rm -it busybox --image=busybox:1.28 --restart=Never -- wget -O- --timeout 2'
alias ktn='k run --rm -it busybox --image=busybox:1.28 --restart=Never -- nc -z -v -w 2 '
alias knt='k describe nodes | grep -i taint  -A3'

alias kaf='kubectl apply -f '
alias kdf='kubectl delete -f '
alias kdfq='kubectl delete --force --grace-period 0 -f '
alias kga='kubectl api-resources --verbs=list  -o name | xargs -n 1 kubectl get --show-kind  2>/dev/null'
alias jointoken='kubeadm token create --print-join-command'

alias installweave="kubectl apply -f 'https://cloud.weave.works/k8s/net?k8s-version=`kubectl version | base64 | tr -d '\n'`'"
alias installflannel='kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml'
alias installms='kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/download/v0.3.7/components.yaml'

function installcalico () {
echo kubeadm init --pod-network-cidr=192.168.0.0/16
echo kubectl create -f https://docs.projectcalico.org/manifests/tigera-operator.yaml
echo kubectl create -f https://docs.projectcalico.org/manifests/custom-resources.yaml
}


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
    openssl x509 -text -noout -in "${1}" |  grep -E "Issuer|Not|Key Usage|Basic Constraints|Subject Alternative" -A1
}

# podcidr
function podcidr () {
cat << EOF
kubectl get nodes -o jsonpath='{.items[*].spec.podCIDR}'
kubectl cluster-info dump | grep -m 1 cluster-cidr   #using kube-proxy
grep cidr /etc/kubernetes/manifests/kube-*
kubeadm config view | grep Subnet
ps -ef | grep cluster-cidr
CALICO_KUBECONFIG=~/.kube/config DATASTORE_TYPE=kubernetes calicoctl get ippool -o wide
EOF
}

# check expired certs in current folder
alias cx='ls *.crt | grep "\.crt$" | xargs -I{} openssl x509 -issuer -enddate -noout -in {}'
alias cc='ls *.crt | grep "\.crt$" | xargs -I{} openssl x509 -text -noout -in {} |  grep -E "Issuer|Not|Key Usage|Basic Constraints|Subject Alternative" -A1'

alias checkcerts='kubeadm alpha certs check-expiration'
alias admconf='kubeadm config view > kubeadm.conf'
alias renewcerts='kubeadm alpha certs renew all --config kubeadm.conf'

#certificate signing process
alias ak='openssl genrsa -out '
function bk () {
openssl rsa -in "${1}" -pubout  -out "${2}"
}
function getcsr () {
openssl req -new -key "${1}"  -subj \"${2}\" -out "${3}"
}

function getcrt () {
openssl x509 -req -in "${1}" -CA ca.key -CAkey ca.key -out "${2}"
}

function getcacrt () {
openssl x509 -req -in "${1}" -signkey ca.key -CAcreateserial -days 1000 -out "${2}" 
}
