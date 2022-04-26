#!/bin/bash
sudo apt update > /dev/null
sudo apt upgrade -y > /dev/null
sudo apt install -y jq git curl wget

if [[ $HOSTNAME =~ ^k3s-master-* ]]
then
    # Master
    if [[ $HOSTNAME -eq 'k3s-master-01' ]]
    then
        echo "Installing k3s master and initializing the cluster..." && \
        curl -sfL https://get.k3s.io | K3S_TOKEN=${k3s_token} sh -s - --write-kubeconfig-mode=644 --cluster-init
    else
        echo "Installing k3s master and joining to cluster..." && \
        curl -sfL https://get.k3s.io | K3S_TOKEN=${k3s_token} sh -s - --write-kubeconfig-mode=644 --server=https://${k3s_cluster_init_ip}:6443
    fi

else
    # Worker
    echo "Installing k3s workers and joining to cluster..." && \
    curl -sfL https://get.k3s.io | K3S_TOKEN=${k3s_token} K3S_URL=https://${k3s_cluster_init_ip}:6443 sh -
fi
