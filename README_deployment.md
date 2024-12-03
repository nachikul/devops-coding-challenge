# Local Kubernetes Environment with Minikube, Terraform, and Helm

This guide covers the steps to install Minikube, Terraform, and Helm, configure Docker or Podman for Minikube, load a localhost image into Minikube, set the Minikube registry search, and deploy resources using Terraform.

---

## Prerequisites
Ensure you have the following installed:
- A supported hypervisor (e.g., VirtualBox, Hyper-V, Docker, etc.)
- Kubernetes CLI (`kubectl`)
- Curl or Wget for downloading installation scripts

---

## 1. Install Minikube

### Using Curl:
bash
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube ```

### Start Minikube
minikube start --driver=docker/podman


### Install Terraform

curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform

### Install Helm
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

### Build The Image
docker build -t springbootrest:latest .

### Save the image
docker save springbootrest:latest -o springbootrest.tar

### To solve the localhost repository error
minikube image load springbootrest.tar

