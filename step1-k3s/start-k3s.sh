#! /usr/bin/env bash

./k3s \
  server \
  --no-deploy=servicelb \
  --no-deploy=traefik \
  --kubelet-arg="address=0.0.0.0" \
  --kube-proxy-arg="nodeport-addresses=127.0.0.0/8" \
  --kube-controller-arg="pod-eviction-timeout=0m30s" \
  --docker > ./k3s.log 2>&1 &
