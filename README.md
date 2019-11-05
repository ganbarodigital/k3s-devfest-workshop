# Welcome To The Workshop!

## Table of Contents <!-- omit in toc -->

- [Welcome To The Workshop!](#welcome-to-the-workshop)
  - [Step 0: Prep](#step-0-prep)
    - [Create Somewhere To Work](#create-somewhere-to-work)
    - [Install Operating System Tools](#install-operating-system-tools)
    - [Clone This Repo](#clone-this-repo)
  - [Step 1: Install Docker](#step-1-install-docker)
  - [Step 2: Install K3S](#step-2-install-k3s)
    - [Download K3S](#download-k3s)
    - [Start K3S](#start-k3s)
    - [Download kubectl](#download-kubectl)
    - [Copy kubectl Config File](#copy-kubectl-config-file)
    - [Prove kubectl Is Working](#prove-kubectl-is-working)
  - [Step 3: Install CoreDNS For Kubernetes](#step-3-install-coredns-for-kubernetes)

## Step 0: Prep

### Create Somewhere To Work

SSH into your VPS (or open a Terminal window if you are working in a local VM) and run:

```bash
sudo su -
```

Once you are the `root` user, clone this repo:

```bash
git clone https://github.com/ganbarodigital/k3s-devfest-workshop
cd k3s-devfest-workshop
```

### Install Operating System Tools

You're going to need some CLI tools today. 

```bash
# if you are on Ubuntu
apt-get install -y wget
```

### Clone This Repo

Still as the `root` user:

```bash
git clone https://github.com/ganbarodigital/k3s-devfest-workshop
cd k3s-devfest-workshop
```

The rest of these instructions assume that you've done these steps first :)

## Step 1: Install Docker

We're going to use Docker.

```bash
# make sure APT has everrything needed to support TLS
apt-get install apt-transport-https ca-certificates curl software-properties-common

# add the signing key for the Docker repo
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

# add the Docker repo
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

# download the repo's package index
apt-get update

# install Docker
apt-get install docker-ce docker-ce-cli containerd.io
```

## Step 2: Install K3S

### Download K3S

Download K3S by running

```bash
# make sure you are in the right place
cd /root/k3s-devfest-workshop/step2-k3s

# download the binary
wget https://github.com/rancher/k3s/releases/download/v0.10.2/k3s

# make it executable
chmod 755 ./k3s
```

### Start K3S

```bash
# make sure you are in the right place
cd /root/k3s-devfest-workshop/step2-k3s

# start K3S manually
./start-k3s.sh
```

At this point, you will need to open a second Terminal window (or SSH connection).

### Download kubectl

```bash
wget https://storage.googleapis.com/kubernetes-release/release/v1.16.2/bin/linux/amd64/kubectl
chmod 755 ./kubectl
mv ./kubectl /usr/local/sbin
```

### Copy kubectl Config File

```bash
mkdir /root/.kube
cp /etc/rancher/k3s/k3s.yaml /root/.kube/config
```

### Prove kubectl Is Working

```bash
kubectl get pods --all-namespaces
```

You should see something like this:

```
NAMESPACE     NAME                                      READY   STATUS    RESTARTS   AGE
kube-system   local-path-provisioner-58fb86bdfd-7zr6g   1/1     Running   0          33m
```

## Step 3: Install CoreDNS For Kubernetes

```bash
# make sure you are in the right place
cd /root/k3s-devfest-workshop/step3-coredns

# send the CoreDNS objects to K3S
kubectl apply -f ./coredns.yaml
```

```bash
kubectl -n kube-system get pods
```

```
NAME                                      READY   STATUS    RESTARTS   AGE
local-path-provisioner-58fb86bdfd-7zr6g   1/1     Running   0          40m
coredns-64bd8d7fdf-vs998                  1/1     Running   0          18s
```

