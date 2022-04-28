#!/bin/bash

if [[ $HOSTNAME =~ ^k3s-master-* ]]
then
    # Setup masters
    if [[ $HOSTNAME -eq 'k3s-master-01' ]]
    then
        # Add manifests
        mkdir -p /var/lib/rancher/k3s/server/manifests/
        mv /tmp/metallb-manifest.yaml /var/lib/rancher/k3s/server/manifests/metallb-manifest.yaml
        echo "Installing k3s master and initializing the cluster..." && \
        curl -sfL https://get.k3s.io | K3S_TOKEN=${k3s_token} sh -s - --write-kubeconfig-mode=644 --no-deploy servicelb --no-deploy traefik --no-deploy servicelb --cluster-init
    else
        echo "Installing k3s master and joining to cluster..." && \
        curl -sfL https://get.k3s.io | K3S_TOKEN=${k3s_token} sh -s - --write-kubeconfig-mode=644 --no-deploy servicelb --no-deploy traefik --no-deploy servicelb --server=https://${k3s_cluster_init_ip}:6443
    fi
    sleep 20 && echo "Installing k3s on $HOSTNAME done." && \
    kubectl get nodes
else
    # Setup workers
    echo "Installing k3s workers and joining to cluster..." && \
    curl -sfL https://get.k3s.io | K3S_URL=https://${k3s_cluster_init_ip}:6443 K3S_TOKEN=${k3s_token} sh -
fi
