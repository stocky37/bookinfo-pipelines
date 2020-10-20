# OpenShift Pipelines (Tekton) Demo 

This repo contains kubernetes resources to configure a demo of OpenShift Pipelines

## Prerequisites
- OpenShift >= 4.3
- OpenShift Pipelines >= 1.1 (Tekton v0.14)

## Getting Started

```sh
oc apply -Rf ./k8s
```

## Running Pipelines

Use the provided script to manually trigger a GitHub-like webhook that triggers the build:

```sh
./bin/trigger.sh
```

## To Do
- volume claim for deploy pipeline
- mount maven cache