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
local-zone: "k3s.lan" redirect
local-data: "k3s.lan 86400 IN A 192.168.1.240"
```
