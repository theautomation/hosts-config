# Infrastructure as Code

## hardware hierarchy

```
├───────── hypervisor (proxmox-ve)
│  ├────── kubernetes (k3s) master nodes
│    ├──── control plane
│    ├──── etcd
│  ├────── kubernetes (k3s) worker nodes
│    ├──── containers
│  │────── pfSense (firewall)
```

```
├─── storage-server (truenas)
```
### 1. Setup Proxmox

### 2. Deploy virtual machines with Terraform on Proxmox

### 3. Add A record in pfSense
Add A record in pfSense to bind a domainname for redirecting internal traffic into k3s private ingress controller.
```
local-zone: "k8s.lan" redirect
local-data: "k8s.lan 86400 IN A 192.168.1.240"
```

### 4. Setup Kubeconfig for remote access to the cluster

```mkdir -p ~/.kube/ \
&& scp coen@192.168.1.11:/etc/rancher/k3s/k3s.yaml ~/.kube/config \
&& sed -i 's/127.0.0.1/192.168.1.11/g' ~/.kube/config```