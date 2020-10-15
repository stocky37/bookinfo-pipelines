```
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