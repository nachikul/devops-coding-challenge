# Deploying A Springboot App in a Local Kubernetes Environment with Minikube, Terraform, and Helm

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
docker tag springbootrest:latest ghcr.io/nachikul/springbootrest:latest
docker push ghcr.io/nachikul/springbootrest:latest

### Save the image

docker save springbootrest:latest -o springbootrest.tar

Only if you are facing issues pulling the image

### To solve the localhost repository error

minikube image load springbootrest.tar

Only if you are facing issues pulling the image

### Run a local mysql server

cd mysql-local-k8s
docker/podman pull mysql:8.0
bash deploy-mysql-k8s.sh

### Deploying using Terraform

cd terraform
terraform init
terraform plan ~var name=springbootrest ~var image=springbootrest ~var kubeconfig_path=~/.kube/config
terraform apply ~var name=springbootrest ~var image=springbootrest ~var kubeconfig_path=~/.kube/config

## Testing
kubectl port-forward svc/springbootrest 8080:8080

curl http://127.0.0.1:8080/user\?id\=1

Output -
Greetings from Crewmeister, Alice!%

curl http://127.0.0.1:8080/user -H "Content-Type: application/json" -d '{"name":"testuser"}'

Output -
Greetings from Crewmeister, testuser!%

curl http://127.0.0.1:8080/user\?id\=2

Output -
Greetings from Crewmeister, testuser!%
### Deploying using CI CD

Option 1 : Run the Jenkinsfile using a local Jenkins server

Option 2 : Run the Github actions ci-cd workflow ==> https://github.com/nachikul/devops-coding-challenge/actions/runs/12165221748/job/33928672947