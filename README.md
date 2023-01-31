# Setup Kubernetes

### Prepare 2 VMs (kubemaster and kubenode) with the same parametrs:
Requirements:
  - 4 CPU
  - 8 GB RAM
  - Ubuntu (only for this task)
  
In this repo you can find the Terraform code to perform vm creation

![image](https://user-images.githubusercontent.com/109740456/215793161-83562dbd-2a5c-469d-8658-d7984b82a3b2.png)


![image](https://user-images.githubusercontent.com/109740456/215792942-4b94ed4a-5019-406b-b33e-d70a32db891e.png)

### Start the setup

__Connect to VMs using command:__ 
```
ssh -i ~/.ssh/<name-of-private-ssh-key> <user>@<host-ip>
```
__Run commands in two VMs (kubemaster and kubenode)__ \
Commands:
 ```
sudo apt update
sudo apt upgrade -y
```

Edit the hosts file with the command:
```
sudo nano /etc/hosts
```
![Знімок екрана_20230131_160026](https://user-images.githubusercontent.com/109740456/215794527-617f9951-5f26-42f2-8010-702089acd345.png)

Put your private IP address and hostname

Save and exit

__Install the first dependencies with:__
```
sudo apt install curl apt-transport-https -y
```
__Next, add the necessary GPG key with the command:__
```
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
```
__Add the Kubernetes repository with:__
```
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
```
__Update apt:__
```
sudo apt update
```
__Install the required software with the command:__
```
sudo apt -y install vim git curl wget kubelet kubeadm kubectl
```
__Place kubelet, kubeadm, and kubectl on hold with:__
```
sudo apt-mark hold kubelet kubeadm kubectl
```
![image](https://user-images.githubusercontent.com/109740456/215795307-5899f14b-afe4-4ddc-8df6-747356f93730.png)

__Start and enable the kubelet service with:__
```
sudo systemctl enable --now kubelet
```
__Next, we need to disable swap on both kubemaster. Open the fstab file for editing with:__
```
sudo nano /etc/fstab
```
__Save and close the file. You can either reboot to disable swap or simply issue the following command to finish up the job:__
```
sudo swapoff -a
```
__Enable Kernel Modules and Change Settings in sysctl:__
```
sudo modprobe overlay
sudo modprobe br_netfilter
```
__Change the sysctl settings by opening the necessary file with the command:__
```
sudo nano /etc/sysctl.d/kubernetes.conf
```
__Look for the following lines and make sure they are set as you see below:__
```
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
```
__Save and close the file. Reload sysctl with:__
```
sudo sysctl --system
```
__Install containerd__

__Install the necessary dependencies with:__
```
sudo apt install curl gnupg2 software-properties-common apt-transport-https ca-certificates -y
```
__Add the GPG key with:__
```
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
```
__Add the required repository with:__
```
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
```
__Install containerd with the commands:__
```
sudo apt update
sudo apt install containerd.io -y
```
__Change to the root user with:__
```
sudo su
```
__Create a new directory for containerd with:__
```
mkdir -p /etc/containerd
```
__Generate the configuration file with:__
```
containerd config default>/etc/containerd/config.toml
```
__Exit from the root user with:__
```
exit
```
__Restart containerd with the command:__
```
sudo systemctl restart containerd
```
__Enable containerd to run at startup with:__
```
sudo systemctl enable containerd
```
__Initialize the Master Node__

__Pull down the necessary container images with:__
```
sudo kubeadm config images pull
```
>NOTE!:

__Command only for kubemaster :__

__Now, using the kubemaster IP address initialize the master node with:__
```
sudo kubeadm init --pod-network-cidr=192.168.0.0/16
```
![Знімок екрана_20230131_161347](https://user-images.githubusercontent.com/109740456/215796837-e266b59b-b116-460c-a207-ed13eabf4c6f.png)

__Finally, you need to create a new directory to house a configuration file and give it the proper permissions which is done with the following commands:__
```
mkdir -p $HOME/.kube
sudo cp -f /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```
__List Kubernetes Nodes:__
```
kubectl get nodes
```
![Знімок екрана_20230131_161451](https://user-images.githubusercontent.com/109740456/215797073-f37b7ca4-0d72-4513-9982-8b44bf5e26ef.png)

>NOTE!:

__Command only for kubenode :__

__Connect kubenode to kubemaster__
```
sudo su
kubeadm join <master-ip>:6443 --token ut36yh.qd0aeqwaciay05l6 --discovery-token-ca-cert-hash sha256:11111111111111111111111111111111111111111111111111111111111111
```
>NOTE!:
__Comeback to kubemaster :__

__Install network:__
```
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/tigera-operator.yaml
curl https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/custom-resources.yaml -O
kubectl create -f custom-resources.yaml
```
__Wait when all pods will be ready and run:__
```
kubectl get nodes -o wide
``` 
![Знімок екрана_20230131_163900](https://user-images.githubusercontent.com/109740456/215797818-8dd2277c-0d9a-4353-aed3-84150a14f1b6.png)




