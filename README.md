# Infrastructure as Code

## hardware hierarchy

```
├─── hypervisor (proxmox-ve)
│  ├─── kubernetes (k3s) master nodes
│    ├─── control plane
│    ├─── etcd
│  ├─── kubernetes (k3s) worker nodes
│    ├─── containers
│  │─── pfSense (firewall)
```

```
├─── storage-server (truenas)
```
### 1. Setup Proxmox

### 2. Deploy virtual machines with Terraform on Proxmox
