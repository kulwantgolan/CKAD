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
