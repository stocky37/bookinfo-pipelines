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

```sh
tkn pipeline start maven \
    --namespace demo-tekton-cicd \
    --workspace name=source,claimName=greeting-service-src \
    --workspace name=maven-settings,emptyDir="" \
    --prefix-name greeting-service-ci \
    --param gitUrl=https://github.com/stocky37/greeting-service-quarkus.git \
    --param name=greeting-service \
    --param namespace=demo-tekton-cicd \
    --param deployNamespace=demo-tekton-app \
    --use-param-defaults
```


## To Do
- volume claim for deploy pipeline
- remove need to specify current namespace