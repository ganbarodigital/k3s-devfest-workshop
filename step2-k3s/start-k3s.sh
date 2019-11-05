#! /usr/bin/env bash

./k3s \
  server \
  --no-deploy=servicelb \
  --no-deploy=traefik \
  --no-deploy=coredns \
  --kubelet-arg="address=0.0.0.0" \
  --kube-controller-arg="pod-eviction-timeout=0m30s" \
  --docker