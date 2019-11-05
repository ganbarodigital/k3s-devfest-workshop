# Welcome To The Workshop!

## Table of Contents <!-- omit in toc -->

- [Welcome To The Workshop!](#welcome-to-the-workshop)
  - [Step 0: Prep](#step-0-prep)
    - [Create Somewhere To Work](#create-somewhere-to-work)
    - [Install Operating System Tools](#install-operating-system-tools)
  - [Step 1: Install Docker](#step-1-install-docker)
  - [Step 1: Install K3S](#step-1-install-k3s)
    - [Download K3S](#download-k3s)
    - [Download Start Script](#download-start-script)
  - [Start K3S](#start-k3s)

## Step 0: Prep

### Create Somewhere To Work

SSH into your VPS (or open a Terminal window if you are working in a local VM) and run:

```bash
sudo su -
```

Once you are the `root` user:

```bash
mkdir devfest-k3s
cd devfest-k3s
```

### Install Operating System Tools

You're going to need some CLI tools today. 

```bash
# if you are on Ubuntu
apt-get install -y wget
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

## Step 1: Install K3S

### Download K3S

Download K3S by running

```bash
# download the binary
wget https://github.com/rancher/k3s/releases/download/v0.10.2/k3s

# make it executable
chmod 755 ./k3s
```

### Download Start Script

```bash
# download the shell script
wget ...

# make it executable
chmod 755 ./start-k3s.sh
```

## Start K3S

```bash
./start-k3s.sh
```