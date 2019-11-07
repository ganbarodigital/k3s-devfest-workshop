#! /usr/bin/env bash

./k3s \
  server \
  --no-deploy=servicelb \
  --no-deploy=traefik \
  --kube-controller-arg="pod-eviction-timeout=0m30s" \
  --docker > ../k3s.log 2>&1 &
