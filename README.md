```
tkn pipeline start maven \
    --workspace name=source,claimName=example-app-src \
    --workspace name=maven-settings,emptyDir="" \
    --use-param-defaults
```