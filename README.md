<img src="https://raw.githubusercontent.com/saveside/k8s/refs/heads/main/assets/honey-k8s.png" height="100">

---

## 🍯 What Is honeypot2?

A honey soaked Kubernetes configuration which provides simplicty and advanced usability with many services and tools

---

## TODO
- [ ] Make K0s deploying process fully automatic
- [ ] Fix K0s upgrade & install workflow using a template

---

## Architecture

### Cluster Overview

| Role               | Hostname   | Location       | OS     | CPU                     | RAM  | Machine |
|--------------------|------------|----------------|--------|-------------------------|------|---------|
| controller+worker  | queenbee   | Falkenstein    | Fedora | 4 Core AMD EPYC Rome    | 8 GB | CPX21   |
| worker             | honeybee   | Nuremberg      | Fedora | 4 Core Ampere Altra     | 8 GB | CAX21   |
| worker             | honeypie   | Falkenstein    | Fedora | 4 Core Ampere Altra     | 8 GB | CAX21   |

---

## Get Started — Deploy the Hive

### Prerequisites

- [Packer](https://developer.hashicorp.com/packer/install)
- [OpenTofu](https://opentofu.org/docs/intro/install/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/#kubectl)

### Setup
#### 1. Build server snapshot/image using Packer:

For AMD64 architecture:
```bash
cd tofu/packer
packer build -var-file=secrets.hcl hcloud.pkr.hcl
```

For ARM64 architecture:
```bash
cd tofu/packer
packer build -var-file=secrets.hcl hcloud-arm.pkr.hcl
```

#### 2. Deploy The Cluster
```sh
cd tofu/

# Create snapshot
cd packer/

# Set packer creds for yourself
vim secrets.hcl.example
mv secrets.hcl.example secrets.hcl

tofu plan -var-file=cluster.tfvars -var-file=secrets.tfvars -detailed-exitcode

# Set cluster secrets and variables for yourself
cd ..

vim secrets.tfvars.example
mv secrets.tfvars.example secrets.tfvars
vim cluster.tfvars

tofu init -upgrade && \
tofu apply -var-file=cluster.tfvars -var-file=secrets.tfvars -auto-approve

# Set K0s creds for yourself
cd ../templates

# Set creds for yourself
vim k0sctl.yaml.template
mv k0sct.yaml.template k0sctl.yaml

# Deploy
k0sctl apply --config k0sctl.yaml

mkdir -p $HOME/.kube
k0sctl kubeconfig --config k0sctl.yaml > $HOME/.kube/config
sudo chmod 0700 $HOME/.kube/config
```



---

Special thanks to these amazing bee-keepers who inspired this setup: 

- [Kreato's bouquet2 Repository](https://github.com/bouquet2/bouquet2/)
- [mt190502's K8s Repository](https://github.com/mt190502/k8s/)

---

Happy buzzing! 🐝
