export ns=default
alias k='kubectl -n $ns'
alias kdo='k --dry-run=client -o yaml'
alias kdor='kdo --restart=Never'
alias kgpo='k get pod -o yaml '
alias kdpo='k get deployment -o yaml '


source <(kubectl completion bash)
complete -F __start_kubectl k
complete -F __start_kubectl kdo
complete -F __start_kubectl kdor
complete -F __start_kubectl kgpo
complete -F __start_kubectl kdpo

alias kt='k run --rm -it busybox --image=busybox --restart=Never'
alias ktw='k run --rm -it busybox --image=busybox --restart=Never -- wget -O- --timeout 2'
alias knt='k describe nodes | grep -i taint  -A3'

alias kaf='kubectl apply -f '
alias kdf='kubectl delete -f '
alias kdfq='kubectl delete --force --grace-period 0 -f '
alias kga='kubectl api-resources --verbs=list  -o name | xargs -n 1 kubectl get --show-kind  2>/dev/null'
alias jointoken='kubeadm token create --print-join-command'

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

function showsubj () {
admin user: "/CN=kubernetes-admin/O=system:masters"
}

function certinfo () {
cat << EOF
Certificate locations in:
- /var/lib/kubelet/pki
	- crt (server) <hostname>
	- client O = system:nodes, CN = system:node:<hostname>

- /etc/kubernetes/pki
	- O = system:masters, CN = kube-apiserver-etcd-client
	- O = system:masters, CN = kube-apiserver-kubelet-client
	- CN = kube-apiserver
	DNS:<hostname>, DNS:kubernetes, DNS:kubernetes.default, DNS:kubernetes.default.svc, DNS:kubernetes.default.svc.cluster.local, IP Address:10.96.0.1, IP Address:172.31.6.58
	- CN = kubernetes
	- CN = front-proxy-ca - Issuer: CN = front-proxy-ca
	- CN = front-proxy-client - Issuer: CN = front-proxy-ca

- /etc/kubernetes/pki/etcd
	- CN = etcd-ca - Issuer: CN = etcd-ca
	- O = system:masters, CN = kube-etcd-healthcheck-client - Issuer: CN = etcd-ca
	-(peer) CN = <hostname> - Issuer: CN = etcd-ca
	DNS:<hostname>, DNS:localhost, IP Address:172.31.6.58, IP Address:127.0.0.1, IP Address:0:0:0:0:0:0:0:1
	-(server) CN = <hostname> - Issuer: CN = etcd-ca
	DNS:<hostname>, DNS:localhost, IP Address:172.31.6.58, IP Address:127.0.0.1, IP Address:0:0:0:0:0:0:0:1

- /etc/kubernetes/*.conf : echo -n ""| base64 --decode | openssl x509 -noout -text
	CN = system:kube-scheduler
	CN = system:kube-controller-manager
	O = system:masters, CN = kubernetes-admin


# CA
openssl genrsa -out ca.key 2048
openssl req -new -key ca.key -out ca.csr -subj "/CN=KUBERNETES-CA"
openssl x509 -req -in ca.csr -signkey ca.key -CAcreateserial -days 1000 -out ca.crt

#Admin
openssl genrsa -out admin.key 2048
openssl req -new -key admin.key -out admin.csr -subj "/CN=kube-admin/O=system:masters"
openssl x509 -req -in admin.csr -CA ca.key -CAkey ca.key -out admin.crt

system:kube-scheduler
system:kube-controller-manager
system:kube-proxy

#Api Server 
/etc/ssl/openssl.cnf
[req]  
req_extensions = v3_req  
[v3_req]  
#Basic Constraints
#basicConstraints        = critical, CA:TRUE
basicConstrants = CA:FALSE  
keyUsage = nonRepudiation,digitalSignature, keyEncipherment  
#Extended Key Usage:
extendedKeyUsage        = serverAuth
#extendedKeyUsage        = clientAuth
subjectAltName = @alt_names  
[alt_names]  
DNS.1 = kubernetes  
DNS.2 = kubernetes.default  
DNS.3 = kubernetes.default.svc  
DNS.4 = kubernetes.default.svc.cluster.local  
IP.1 = 10.96.0.1  
IP.2 = 172.17.0.87


openssl genrsa -out apiserver.key 2048
openssl req -new -key apiserver.key -out apiserver.csr -subj "/CN=kube-apiserver"
openssl x509 -req -in apiserver.csr -CA ca.key -CAkey ca.key -out apiserver.crt
EOF
}



