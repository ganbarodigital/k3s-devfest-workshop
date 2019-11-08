# Welcome To The Workshop!

## Introduction

This Git repo - and these instructions - are for my K3S workshop at DevFest Cymru 2019. We'll be following them during the workshop.

The workshop is an introduction to K3S:

_Many of us use Docker containers for development, but we're not ready to take the leap to running them in production using full-fat Kubernetes (K8S). What if there was a halfway house - a way to get started with Kubernetes at a very small scale? One that doesn't stop you migrating to a larger, managed Kubernetes setup as you grow?_

_In this guided workshop, Stuart will introduce you to Rancher's K3S: a Kubernetes setup so small you can realistically run it on a £10-a-month VPS. He'll show you how to get your first site up and running, and show you what to keep in mind for when you're ready to migrate to full-fat Kubernetes such as Google's Kubernetes Engine (GKE)._

If you've come across this repo in the future, Kubernetes et al has probably moved on a bit, and these instructions are probably somewhat out-of-date.

## K3S vs K8S

__Kubernetes (K8S for short)__ is _a container orchestration system_ designed to run and manage containers at an industrial scale.  It originally started as a project inside Google, and today it is an open-source project run by the Cloud Native Computing Foundation.

In a short period of time, it has become the _de facto_ standard for running containers in prod.

We've published a couple of YouTube videos that explain what it is and how it works:

* [What Is Kubernetes?](https://www.youtube.com/watch?v=i2DobK3M9Hg&list=PLAXvd3M1ib-Y9A-c3cSZ8oMw_2mOPFv-H&index=3&t=0s)
* [Thinking In Kubernetes](https://www.youtube.com/watch?v=Uctnr7mhLzM&list=PLAXvd3M1ib-Y9A-c3cSZ8oMw_2mOPFv-H&index=5&t=0s)

(Throughout these instructions, you'll see us use standard Kubernetes terms like 'pod' and 'controller'. These are explained in the What Is Kubernetes video above.)

__K3S__ (it isn't short for anything) is a Kubernetes distribution; a bit like how you get different Linux distributions. K3S is aimed at _low resource_ environments like the Raspberry Pi, local dev environments, and cheap VPS's. It is an open-source project published by Rancher.

It's a great option if you want to run your Docker containers in prod by starting small. And, when you're ready, you can lift and shift from K3S to full-fat hosted K8S services like Google's Kubernetes Engine (GKE for short).

## You Need A VPS or VM

These instructions assume you already have either:

* a working VM locally running Ubuntu 18.04 LTS,
* _or_ a cheap VPS hosted somewhere.

All the instructions are written for Ubuntu 18.04.3 LTS, as of November 6th, 2019. If you're running a different Linux distribution, it's on you to translate the instructions to suit.

There is a [Vagrantfile](./Vagrantfile) provided in this Git repo, and that's what Stuart is running on his laptop during this workshop. If you're having problems with the VM or VPS you've brought to the workshop, and you're used to working with Vagrant, you're very welcome to give it a try - but don't be surprised if the venue's WiFi or broadband can't cope if everyone tries it at once.

(If you're running this at home or at work after the workshop, you should be fine :) )

## Don't Worry If You Don't Complete All The Steps During The Workshop

Kubernetes is radically different from anything you've ever used before - even if you're used to running containers under Docker. There's a lot to cover, just to get your first site up and running. You may not manage to complete these instructions during the time we have available today.

We've written these instructions so that you can take them away and follow them again at your own pace.

## How Can We Help?

If you are interested in containerising your apps, and running them on cheap VPS's in prod using K3S, why not hire us to help you do so? Send an email to Stuart at `hello@ganbarodigital.com` to start the conversation :)

## Table of Contents <!-- omit in toc -->

- [Introduction](#introduction)
- [K3S vs K8S](#k3s-vs-k8s)
- [You Need A VPS or VM](#you-need-a-vps-or-vm)
- [Don't Worry If You Don't Complete All The Steps During The Workshop](#dont-worry-if-you-dont-complete-all-the-steps-during-the-workshop)
- [How Can We Help?](#how-can-we-help)
- [Step 0: Prep](#step-0-prep)
  - [0a. Become Root](#0a-become-root)
  - [0b. Install Operating System Tools](#0b-install-operating-system-tools)
  - [0c. Clone This Git Repo](#0c-clone-this-git-repo)
  - [0d. Do You Need A Swap File?](#0d-do-you-need-a-swap-file)
- [Step 1: Install And Run K3S](#step-1-install-and-run-k3s)
  - [1a. Install Docker](#1a-install-docker)
  - [1b. Test That Docker Is Working](#1b-test-that-docker-is-working)
  - [1c. Download K3S](#1c-download-k3s)
  - [1d. Start K3S](#1d-start-k3s)
  - [1e. Download kubectl](#1e-download-kubectl)
  - [1f. Copy kubectl Config File](#1f-copy-kubectl-config-file)
  - [1g. Setup Bash Completion](#1g-setup-bash-completion)
  - [1h. Prove kubectl Is Working](#1h-prove-kubectl-is-working)
- [Step 2: First Website: Wordpress](#step-2-first-website-wordpress)
  - [Underlying Principle: Local Storage](#underlying-principle-local-storage)
  - [2a. Create The Storage For MySQL](#2a-create-the-storage-for-mysql)
  - [2b. Install MySQL For Wordpress](#2b-install-mysql-for-wordpress)
  - [2c. Test MySQL](#2c-test-mysql)
  - [Underlying Principle: Port Mapping Creates Security Issues](#underlying-principle-port-mapping-creates-security-issues)
  - [2d. Remove MySQL Port Mapping](#2d-remove-mysql-port-mapping)
  - [2e. Create The Storage For Wordpress](#2e-create-the-storage-for-wordpress)
  - [2f. Install Wordpress](#2f-install-wordpress)
  - [2g. Testing Wordpress](#2g-testing-wordpress)
  - [2h. Add An Entry To Your Hosts File](#2h-add-an-entry-to-your-hosts-file)
- [Step 3: Firewalls Are A Must-Have](#step-3-firewalls-are-a-must-have)
  - [3a. Install A Firewall](#3a-install-a-firewall)
  - [3b. Setup The Firewall Rules](#3b-setup-the-firewall-rules)
  - [3c. Switch On The Firewall](#3c-switch-on-the-firewall)
  - [What Does The Firewall Do?](#what-does-the-firewall-do)
- [Step 4: Adding Support For Multiple Websites](#step-4-adding-support-for-multiple-websites)
  - [4a. Stop Our Wordpress Site](#4a-stop-our-wordpress-site)
  - [4b. Restart K3S w/ Ingress Support](#4b-restart-k3s-w-ingress-support)
  - [4d. Route Traffic To Wordpress](#4d-route-traffic-to-wordpress)
  - [4e. Test Ingress](#4e-test-ingress)
  - [4f. Setup A Second Site](#4f-setup-a-second-site)
  - [So What Have We Done?](#so-what-have-we-done)
- [Step 5: Running Our Own Docker Images](#step-5-running-our-own-docker-images)
  - [Underlying Principle: Containers And Secure Registries aka Why Docker?](#underlying-principle-containers-and-secure-registries-aka-why-docker)
  - [5a. Build A Docker Image](#5a-build-a-docker-image)
  - [5b. Deploy The Docker Image](#5b-deploy-the-docker-image)
  - [5c. Test The Deployment](#5c-test-the-deployment)
- [Conclusion](#conclusion)

## Step 0: Prep

We need to do a few things first, before we start running K3S.

### 0a. Become Root

Login to your VPS or VM, and run:

```bash
sudo su -
```

_For the rest of this README, whenever you see commands to run, __always__ run on them on your VPS or VM as the `root` user._

### 0b. Install Operating System Tools

Run this command, to make sure you have the command-line tools that we use in this README:

```bash
apt-get install -y wget git
```

### 0c. Clone This Git Repo

Clone this Git repo:

```bash
# make sure you're in the right place
cd /root

# clone the repo
git clone https://github.com/ganbarodigital/k3s-devfest-workshop
```

### 0d. Do You Need A Swap File?

How much memory does your VM or VPS have? Run this command:

```bash
free -h
```

It will show you something like this:

```
              total        used        free      shared  buff/cache   available
Mem:           985M        653M         72M        2.7M        259M        196M
```

If you've got less than 1.5GB of memory in your VM / VPS, you'll need to add a swap file:

```bash
# create the swap file on disk
dd if=/dev/zero of=/mnt/1GB.swap bs=1024 count=1048576

# 'format' it to work as swap space
mkswap /mnt/1GB.swap

# make it secure!
chmod 600 /mnt/1GB.swap

# start using it as swap space
swapon /mnt/1GB.swap
```

## Step 1: Install And Run K3S

### 1a. Install Docker

We're going to use Docker as the underlying container engine.

* We'll tell K3S to use Docker as our preferred container engine.
* We'll use the Kubernetes' standard CLI commands to start and stop containers.

_The pay-off for this comes when we get to [Step 5](#step-5-running-our-own-docker-images) at the end of this workshop!_

Run these commands:

```bash
# make sure APT has everrything needed to support TLS
apt-get install -y apt-transport-https ca-certificates curl software-properties-common

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
apt-get install -y docker-ce docker-ce-cli containerd.io
```

### 1b. Test That Docker Is Working

Now that Docker is installed, let's test it!

Run this command:

```bash
docker run hello-world
```

Docker will download the `hello-world:latest` image, and then print this message:

```
Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (amd64)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://hub.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/get-started/
```

At this point, we're ready to get K3S up and running :)

### 1c. Download K3S

Run these commands to download the K3S binary:

```bash
# make sure you are in the right place
cd /root/k3s-devfest-workshop

# download the binary
#
# K3S is distributed as a single binary
wget https://github.com/rancher/k3s/releases/download/v0.10.2/k3s

# make it executable
chmod 755 ./k3s
```

### 1d. Start K3S

Run these commands:

```bash
# make sure you are in the right place
cd /root/k3s-devfest-workshop/step1-k3s

# start K3S manually
./start-k3s.sh
```

This will start the K3S server in the background, and write all of its log messages out to [k3s.log](./k3s.log). You can use tools like `tail -f` to see what K3S is doing at any time.

```bash
# make sure you are in the right place
cd /root/k3s-devfest-workshop

# watch the K3S log file
tail -f ./k3s.log
```

In a production system, you'd setup K3S as a `systemd` service. There are plenty of instructions online on how to do that if you ever decide to go ahead and use K3S in anger.

### 1e. Download kubectl

`kubectl` is the main CLI tool for controlling Kubernetes.

Run these commands to download and install the tool:

```bash
wget https://storage.googleapis.com/kubernetes-release/release/v1.16.2/bin/linux/amd64/kubectl
chmod 755 ./kubectl
mv ./kubectl /usr/local/sbin
```

_We put `kubectl` into `/usr/local/sbin` so that you can just type `kubectl` to run it._

### 1f. Copy kubectl Config File

Out of the box, `kubectl` does not know where to find K3S, or how to authenticate against it. K3S publishes a config file that you can use. It just needs to be copied into the place where `kubectl` expects it to be.

Run these commands:

```bash
mkdir /root/.kube
cp /etc/rancher/k3s/k3s.yaml /root/.kube/config
```

### 1g. Setup Bash Completion

Command-line completion for `kubectl` is an absolute must-have. It will save you so much time!

Run these commands:

```bash
# install the command-line completion instructions
kubectl completion bash > /etc/bash_completion.d/kubectl

# log out of the root shell
exit

# become `root` again, to pick up the new completions
sudo su -
```

### 1h. Prove kubectl Is Working

Let's quickly check that everything is okay so far, before we start deploying containers onto K3S.

Run this command:

```bash
kubectl get pods --all-namespaces
```

You should see something like this:

```
NAMESPACE     NAME                                      READY   STATUS    RESTARTS   AGE
kube-system   coredns-57d8bbb86-rbjdq                   1/1     Running   0          14s
kube-system   local-path-provisioner-58fb86bdfd-zzwqh   1/1     Running   0          14s
```

The exact names will be different. Kubernetes generates unique, pseudo-random names for every 'pod' that you start.

## Step 2: First Website: Wordpress

For our first website, we're going to setup a vanilla Wordpress instance. And we're going to run it in a way that's equivalent to using Docker containers with port mapping.

__Don't do this in a production system.__ It's as flawed, insecure and downright dangerous as using Docker containers with port mapping.

It gives us a starting point that mimics what people actually do with Docker. It gives us something we can greatly - and easily - improve shortly :)

### Underlying Principle: Local Storage

In case you weren't aware - __always treat containers as READ-ONLY systems__. If they need to write data anywhere, you need to create some storage and mount it as a volume (or two) into the container.

With K3S, we do that by mounting a folder from your VM / VPS's filesystem into the container, using what is called Local storage.

* The folder has to exist on your VM / VPS's filesystem; Kubernetes will not create it for you.
* You have to use `nodeAffinity` in your _persistent volume_ config, otherwise Kubernetes will not allow you to mount the folder into your container.

We'll cover both of these in the steps below.

On full-fat Kubernetes, you never use Local storage. Paid-for solutions like Google's GKE come with their own persistent volume solutions. It's one of the things you have to change if/when you outgrow a self-hosted K3S system.

### 2a. Create The Storage For MySQL

Run this command:

```bash
# create the folder
mkdir -p /var/lib/k3s/default/wordpress-mysql-data
```

_In this example, `default` is the name of the Kubernetes namespace we are going to run MySQL in, and `wordpress-mysql-data` is the name of the `PersistentVolume` we are going to store MySQL's data on._

_You can use whatever folder structure you want. We find it easier to stick with a structure that maps directly onto the configuration we load into Kubernetes._

### 2b. Install MySQL For Wordpress

To install MySQL, we use the `kubectl` command to send some YAML configs up to Kubernetes. These configs describe our _desired state_. Kubernetes will then figure out what it needs to do to achieve what we've asked for - if it can.

__NOTE__ the instruction to edit the file [002-mysql-data-pv.yaml](./step2-first-website/001-mysql/002-mysql-data-pv.yaml) _before_ you run these commands!

```bash
# make sure you are in the right place
cd /root/k3s-devfest-workshop/step2-first-website/001-mysql

# edit the file 002-mysql-data-pv.yaml
#
# change the string 'ubuntu-bionic' to the hostname of
# YOUR VPS or VM
#
# if you forget to do this, your deployment will hang!

# send the MySQL objects to K3S
kubectl apply -f .
```

Kubernetes needs to go away and make all that happen. You can watch what is going on by running this command:

```bash
watch kubectl get pods
```

After a few minutes, you should see this:

```
NAME                READY   STATUS    RESTARTS   AGE
wordpress-mysql-0   1/1     Running   0          74s
```

When you do, MySQL is ready to test.

### 2c. Test MySQL

Run this command to install the official CLI client:

```bash
# install a MySQL client
apt-get install -y mysql-client
```

Once the client is installed, run this command:

```bash
# connect to the database
#
# when prompted, the password is 'password'
mysql -h 127.0.0.1 -P 30006 -u wordpress -p
```

Once you're in, you should see the following.

```
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 2
Server version: 5.7.28 MySQL Community Server (GPL)

Copyright (c) 2000, 2019, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql>
```

You can type `show databases;` to see that we already have an empty `devfest` database, ready for Wordpress to populate.

```
mysql> show databases;

show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| devfest            |
+--------------------+
2 rows in set (0.02 sec)

mysql> quit
Bye
```

_Question: Why is it port 30006, and not the usual port of 3306?_

Kubernetes' port-mapping is called _NodePorts_. By default, NodePorts are limited to the range 30000-32767 on the host machine. You can see the mapping in the YAML file [step2-first-website/001-mysql/006-mysql-nodeport.yaml](step2-first-website/001-mysql/006-mysql-nodeport.yaml).

### Underlying Principle: Port Mapping Creates Security Issues

Btw, if you VM or VPS has a public IP address, right now _anyone_ can attempt to connect to MySQL on port 30006. Any port you open up like this is open to the world. That's how port-mapping in Kubernetes is designed and intended to work.

(You can test this for yourself right now. Find the IP address of your VPS or VM, and try connecting to MySQL on it from another machine. Scary, right?)

Port-mapping is (mostly) a legacy feature - just like Docker's port-mapping is. You can get away with it on a private machine, but it's best to learn safe habits as soon as possible, and to adopt those habits no matter where you are working.

Let's finish the work to get this first website up and running, and then we'll look at how to make your VPS or VM a bit more secure.

### 2d. Remove MySQL Port Mapping

Even though it's on a non-standard port, we can't leave MySQL open like this. We've tested that MySQL is working. We don't need the port mapping any more.

Run this command to delete the port-mapping.

```bash
# this deletes the port-mapping configuration
kubectl delete service wordpress-mysql-nodeport
```

If you try to access MySQL via the port-mapping now:

```bash
mysql -h 127.0.0.1 -P 30006 -u wordpress -p
```

... you should see this error:

```
ERROR 2003 (HY000): Can't connect to MySQL server on '127.0.0.1' (111)
```

You can still access MySQL by using its Kubernetes Cluster IP:

```bash
mysql -h `kubectl get service wordpress-mysql -o jsonpath="{.spec.clusterIP}"` -u wordpress -p
```

and you can see all of the assigned IP addresses by running this command:

```bash
kubectl get service --all-namespaces
```

### 2e. Create The Storage For Wordpress

The process for installing Wordpress is very similar to how we installed MySQL.

Wordpress needs somewhere to write the Wordpress PHP code (which it auto-updates) and any uploaded plugins, themes and media files.

Run this command:

```bash
# create the folder
mkdir -p /var/lib/k3s/default/wordpress-html
```

### 2f. Install Wordpress

Use `kubectl` to tell Kubernetes our _desired state_ for Wordpress:

__NOTE__ the instruction to edit the file [002-wordpress-html-pv.yaml](./step2-first-website/002-wordpress/002-wordpress-html-pv.yaml) _before_ you run these commands!

```bash
# make sure you are in the right place
cd /root/k3s-devfest-workshop/step2-first-website/002-wordpress

# edit the file 002-wordpress-html-pv.yaml
#
# change the string 'ubuntu-bionic' to the hostname of
# YOUR VPS or VM
#
# if you forget to do this, your deployment will hang!

# send the Wordpress objects to K3S
kubectl apply -f .
```

Then watch as Kubernetes makes it happen:

```bash
watch kubectl get pods
```

You'll see something like this at first:

```
NAME                READY   STATUS              RESTARTS   AGE
wordpress-mysql-0   1/1     Running             0          100s
wordpress-tbbhz     0/1     ContainerCreating   0          32s
```

And once Kubernetes has finished doing everything, you'll see something like this:

```
NAME                READY   STATUS    RESTARTS   AGE
wordpress-mysql-0   1/1     Running   0          2m27s
wordpress-tbbhz     1/1     Running   0          79s
```

Once again, the exact names will be different. Kubernetes generates unique, pseudo-random names for every 'pod' that you start.

### 2g. Testing Wordpress

Point your web browser at the IP address of your VM or VPS. (If you are using the Vagrantfile in this Git repo, point your browser at `http://192.168.33.10`) (Make sure you include the `http://` bit when you type the address into the browser, otherwise it'll probably go off and do a Google search instead!)

You should see the Install Wordpress screen:

![wordpress-install.png](./wordpress-install.png)

__DO NOT COMPLETE THE INSTALL YET. IT ISN'T SAFE TO DO SO.__. We need to access Wordpress via a virtual hostname, before we can complete the Wordpress install.

### 2h. Add An Entry To Your Hosts File

_In production, we'd setup a DNS entry for our website. For this workshop, an entry in our `hosts` file is good enough._

On the machine where your web browser is, add an entry for `wordpress.default.test` to that machine's `hosts` file:

* on Linux, this will be the file `/etc/hosts`
* on MacOS, the file is `/private/etc/hosts`
* on Windows 10, the file is `C:\Windows\System32\drivers\etc\hosts`

You'll need to put in the IP address of the VM or VPS where K3S is running. If you're using the `Vagrantfile` included in this Git repo, that IP address is `192.168.33.10`.

Here's what my `hosts` file looks like.

```
##
# Host Database
#
# localhost is used to configure the loopback interface
# when the system is booting.  Do not change this entry.
##
127.0.0.1	localhost
255.255.255.255	broadcasthost
::1             localhost

192.168.33.10 wordpress.default.test
```

Once you've saved your `hosts` file, point your web browser at [http://wordpress.default.test](http://wordpress.default.test). You should see the Wordpress installer appear once again.

__NOW__ it is safe to complete the Wordpress install wizard.

## Step 3: Firewalls Are A Must-Have

We can't go any further without putting a firewall onto your VM or VPS for safety.

### 3a. Install A Firewall

Run this command:

```bash
# install Ubuntu's firewall software
apt-get install -y ufw
```

This install's Canonical's own `ufw` firewall software. It's basic, but it'll do the job we need - and lots of people have written articles about how to use it.

### 3b. Setup The Firewall Rules

Before we switch the firewall on, we need to tell it what rules we want it to enforce.

Run these commands:

```bash
# this should be the default, but just in case
ufw default deny incoming

# keep SSH access, prevent excessive connections
ufw allow 22
ufw limit 22

# keep HTTP/HTTPS access to our hosted website
ufw allow 80
ufw allow 443

# allow K3S to talk to the pods
ufw allow in on cni0
```

### 3c. Switch On The Firewall

Run this command:

```bash
# switch on the firewall
ufw enable
```

You should see this prompt. Enter `y` to switch on the firewall.

```
Command may disrupt existing ssh connections. Proceed with operation (y|n)? y
Firewall is active and enabled on system startup
```

### What Does The Firewall Do?

The firewall does a couple of things:

1. any NodePorts you create (deliberately, or accidentally) are no longer available from the outside world,
2. any ports opened by Kubernetes (such as port 8472 for its software-based virtual network) are also no longer available from the outside world

It leaves the following ports open:

* port 22 for SSH access
* ports 80 & 443 for HTTP & HTTPS access

## Step 4: Adding Support For Multiple Websites

In Step 2, we configured our website to sit directly on port 80 of our VM or VPS. But what if we want to run multiple websites on our VM or VPS?

In this step, we're going to reconfigure K3S so that we can run as many websites as our VM or VPS can handle.

### 4a. Stop Our Wordpress Site

First thing we need to do is to stop our Wordpress deployment. It's currently listening on ports 80 and 443, and we need to free up those ports to enable Ingress support.

Run this command:

```bash
# stop our current Wordpress instance
kubectl delete deployment wordpress
```

Run this command to watch K3S stopping the Wordpress pod:

```bash
watch kubectl get pods
```

At first, you might see something like this:

```
NAME                        READY   STATUS        RESTARTS   AGE
wordpress-mysql-0           1/1     Running       0          4m36s
wordpress-7f566b9ff-thkj2   0/1     Terminating   0          2m12s
```

and when Wordpress is no longer running, you'll see this:

```
NAME                READY   STATUS    RESTARTS   AGE
wordpress-mysql-0   1/1     Running   0          5m1s
```

### 4b. Restart K3S w/ Ingress Support

Ingress is a network routing solution for Kubernetes. Officially, it only supports HTTP and HTTPS.

K3S comes with a built-in Ingress feature that's built on [Traefik](https://traefik.io). Until now, we've been running K3S with Ingress switched off. It's time to switch it on!

Run these commands:

```bash
# make sure you're in the right place
cd /root/k3s-devfest-workshop/step4-virtual-hosting/001-ingress

# stop our existing K3S server
kill `ps -ef | grep "./k3s server" | grep -v grep | awk '{ print $2 }'`

# start K3S with Ingress enabled
./start-k3s-with-ingress.sh
```

Run this command, to see K3S starting up again:

```bash
tail -f /root/k3s-devfest-workshop/k3s.log
```

Run this command, to watch the progress as K3S installs Traefik:

```bash
watch kubectl get pods --all-namespaces
```

After a few minutes, you should see something like this:

```
NAMESPACE     NAME                                      READY   STATUS      RESTARTS   AGE
kube-system   coredns-57d8bbb86-5v58q                   1/1     Running     0          7m36s
kube-system   local-path-provisioner-58fb86bdfd-scx4m   1/1     Running     0          7m36s
default       wordpress-mysql-0                         1/1     Running     0          6m55s
kube-system   helm-install-traefik-k94vr                0/1     Completed   0          59s
kube-system   svclb-traefik-qkfq4                       3/3     Running     0          35s
kube-system   traefik-65bccdc4bd-lpjs9                  1/1     Running     0          35s
```

There are two new pods running:

* `svclb-traefik` - the service load balancer for Traefik
* `traefik` - the Ingress Controller

### 4d. Route Traffic To Wordpress

We need to start Wordpress again (we deleted the container back in [Step 4a](#4a-stop-our-wordpress-site)), and we need to create an Ingress route for our Wordpress site.

Run these commands:

```bash
# make sure you're in the right place
cd /root/k3s-devfest-workshop/step4-virtual-hosting/002-wordpress

# send the revised Wordpress config up to Kubernetes
kubectl apply -f .
```

Run this command to watch Wordpress start again:

```bash
kubectl get pods
```

You'll see something like this:

```
NAME                         READY   STATUS    RESTARTS   AGE
wordpress-mysql-0            1/1     Running   0          13m
wordpress-664bf6f8db-xks6j   1/1     Running   0          75s
```

### 4e. Test Ingress

Point your web browser at [http://wordpress.default.test](http://wordpress.default.test). You should see Wordpress appear once again.

### 4f. Setup A Second Site

Let's quickly setup a second, completely independent, Wordpress site.

Run this command:

```bash
# create the folders for our local volumes
mkdir -p /var/lib/k3s/second-site/wordpress-mysql-data
mkdir -p /var/lib/k3s/second-site/wordpress-html

# make sure we're in the right place
cd /root/k3s-devfest-workshop/step4-virtual-hosting/003-second-site

# edit the files:
#
# * 002-mysql-data-pv.yaml
# * 012-wordpress-html-pv.yaml
#
# change the string 'ubuntu-bionic' to the hostname of
# YOUR VPS or VM
#
# if you forget to do this, your deployment will hang!

# send the Wordpress objects to K3S
kubectl apply -f .
```

Run this command to watch the second Wordpress instance spinning up:

```
watch kubectl get pods -n second-site
```

Once both pods are running, add an entry in your `hosts` file for `wordpress.second-site.test`. Here's mine (on MacOS) for reference:

```
##
# Host Database
#
# localhost is used to configure the loopback interface
# when the system is booting.  Do not change this entry.
##
127.0.0.1	localhost
255.255.255.255	broadcasthost
::1             localhost

192.168.33.10 wordpress.default.test
192.168.33.10 wordpress.second-site.test
```

Point your web browser at [http://wordpress.second-site.test](http://wordpress.second-site.test), and you'll see the second copy of Wordpress is now up and running.

(You might see a 'Bad Gateway' error message until the Ingress Controller has caught up with the new instructions!)

You can now switch between [http://wordpress.default.test](http://wordpress.default.test) and [http://wordpress.second-site.test](http://wordpress.second-site.test).

They are:

* completely independent sites,
* running in different containers,
* with their own database servers,
* with their own local storage

controlled and managed by a single K3S setup.

### So What Have We Done?

* We have restarted K3S, and told it to use its _Ingress Controller_ and _Service LoadBalancer_.
* We have reconfigured our original Wordpress deployment, so that it no longer listens on port 80 of your K3S machine.
* We have configured the _Ingress Controller_ to send requests for `wordpress.default.test` to our original Wordpress deployment. You'll find that config in the file [./step4-virtual-hosting/002-wordpress/006-wordpress-ingress.yaml](./step4-virtual-hosting/002-wordpress/006-wordpress-ingress.yaml).
* We have deployed a second, independent Wordpress / MySQL pair into the namespace `second-site`.

This is where Kubernetes starts to make more sense than Docker: when you want to run multiple, independent systems on the same VM, VPS or bare metal machine.

## Step 5: Running Our Own Docker Images

To finish the hands-on portion of the workshop, we're going to build and deploy our own Docker image onto K3S.

### Underlying Principle: Containers And Secure Registries aka Why Docker?

Kubernetes - whether full fat, or slimmed right down like K3s - is (at heart) another way to download and run Docker images from container registries. While there's a lot of third-party images already available (and we've used some of them in this workshop today), you will end up making and deploying your own Docker images sooner or later.

_And when you do, you'll discover the hell that is private container registries._

The long and short of it is that a container registry is either:

* on `localhost`, or
* has to be available via HTTPS, cannot use self-signed TLS certificates

You can't easily run your own private container registry (for example) inside your private company network. And if you run it somewhere else (e.g. you buy one from Docker Hub or from AWS), you're stuck with uploading and downloading images over your external Internet link - with the costs and bandwidth requirements that brings. That can be very painful.

One way around that pain is to build your Docker images directly on the VPS or VM where K3S is running. It's a trade-off, and it only works for small-scale operations. But it is an option.

And that's why we're running Docker on the VPS or VM.

### 5a. Build A Docker Image

```bash
# make sure you are in the right place
cd /root/k3s-devfest-workshop/step5-your-docker-images/001-docker-image

# create the docker image
docker build -t my-private-image:latest .
```

Verify that the image has been built:

```bash
docker image ls
```

You should see something like this:

```
REPOSITORY                       TAG                 IMAGE ID            CREATED             SIZE
my-private-image                 latest              6e64c3d3c796        7 seconds ago       126MB
wordpress                        apache              c3a1256d5af5        2 weeks ago         537MB
nginx                            latest              540a289bab6c        2 weeks ago         126MB
mysql                            5.7                 cd3ed0dfff7e        3 weeks ago         437MB
rancher/local-path-provisioner   v0.0.11             9d12f9848b99        5 weeks ago         36.2MB
coredns/coredns                  1.6.3               c4d3d16fe508        2 months ago        44.3MB
traefik                          1.7.14              f12ee21b2b87        2 months ago        84.4MB
rancher/klipper-lb               v0.1.2              897ce3c5fc8f        5 months ago        6.1MB
rancher/klipper-helm             v0.1.5              c1e4f72eb676        7 months ago        83.2MB
hello-world                      latest              fce289e99eb9        10 months ago       1.84kB
k8s.gcr.io/pause                 3.1                 da86e6ba6ca1        22 months ago       742kB
```

### 5b. Deploy The Docker Image

```bash
# make sure you are in the right place
cd /root/k3s-devfest-workshop/step5-your-docker-images/002-deployment

# send the K8S objects up to Kubernetes
kubectl apply -f .
```

Run this command to watch the new pod spinning up:

```
watch kubectl get pods -n private-image
```

### 5c. Test The Deployment

Once both pods are running, add an entry in your `hosts` file for `nginx.private-image.test`. Here's mine (on MacOS) for reference:

```
##
# Host Database
#
# localhost is used to configure the loopback interface
# when the system is booting.  Do not change this entry.
##
127.0.0.1	localhost
255.255.255.255	broadcasthost
::1             localhost

192.168.33.10 wordpress.default.test
192.168.33.10 wordpress.second-site.test
192.168.33.10 nginx.private-image.test
```

Point your web browser at [http://nginx.private-image.test](http://nginx.private-image.test), and you'll see the second copy of Wordpress is now up and running.

## Conclusion

If you're already using containers in your dev environments, K3S is a good way to get started with running containers in your test, staging and production environments.

* You can run it on a single machine - no need to worry about managing (or paying for) a cluster
* You use the standard Kubernetes tool `kubectl` to manage your deployments
* It can all be automated using Ansible - grab me for more details!

And, if/when you outgrow K3S, it's very straight forward to quickly migrate from a self-hosted K3S to full-fat Kubernetes like Google's GKE.

If you'd like help with any of this, we're available to hire. Send us an email at 'hello@ganbarodigital.com' to start the conversation :)

## References <!-- omit in toc -->

[start-k3s.sh](step1-k3s/start-k3s.sh)