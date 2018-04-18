#!/bin/bash

# The Script Assumes that the master ID=0 and worker ID=1
# Enable AWS cloud provider on master node(s)
# If you have multiple masters/workers add their IDs below
for master in 0; do
	juju ssh $master "sudo snap set kube-apiserver cloud-provider=aws ; \
  sudo snap set kube-controller-manager cloud-provider=aws;"
  juju run --application kubernetes-master 'service snap.kube-apiserver.daemon restart'
  juju run --application kubernetes-master 'service snap.kube-controller-manager.daemon restart'
  juju ssh $master "ps -ef | grep kube-apiserver"
  juju ssh $master "ps -ef | grep kube-controller-manager"
done


# Enable AWS cloud provider on the Worker Node(s)
for worker in 1; do
  juju ssh $worker "sudo snap set kubelet cloud-provider=aws"
  juju run --application kubernetes-worker 'service snap.kubelet.daemon restart'
  juju ssh $worker "ps -ef | grep kubelet"
done