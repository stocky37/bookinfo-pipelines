# Bookinfo Pipelines

```console

```

## Tekton CLI

```console
sudo dnf copr enable chmouel/tektoncd-cli
sudo dnf install tektoncd-cli -y
```

## Getting Started

```console
oc new-project bookinfo
oc new-project bookinfo-cicd
oc adm policy add-role-to-user edit system:serviceaccount:bookinfo-cicd:pipeline -n bookinfo
oc apply -Rf deploy
oc expose svc el-bookinfo # todo: get route object and put in deploy dir
oc create secret generic webhooks --from-literal=secret=password
```

## Notes

- Didn't get `ClusterTask`s until installed canary stream of the operator
- Uninstalling the operator does not clean up resources, clean up with:

    ```bash
    oc delete project openshift-pipelines
    oc get clusterroles -o name | grep tekton | xargs oc delete
    oc get crds -o name | grep tekton | xargs oc delete
    ```

- `PipelineResource` is deprecated, need a newer version of tekton then is available via the operator
- Can fake webhook using curl (`bin/webhook`) (for internal networks, or just to trigger pipeline for testing)
- Assuming secrets separate, to create insecure secrets to get it going, use:

    ```console
    oc create secret generic webhooks --from-literal=secret=password
    oc create secret generic mongodb -n bookinfo \
        --from-literal=database-user=mongodb \
        --from-literal=database-password=password \
        --from-literal=database-admin-password=admin \
        --from-literal=database-name=ratings
    ```

## Questions

- How do I do some other basic things like trigger different pipelines for different branches
  - **Answer:** Interceptors
- How do I secure the webhook so that only repos I own can trigger it?
  - **Answer:** Use the gitub interceptor with a secret, and the CEL interpreter to select based on info in the webhook body (e.g. specific repos)
- How do I run a command like this: `oc rsh dc/mongodb bash -c 'mongo -u $MONGODB_USER -p $MONGODB_PASSWORD $MONGODB_DATABASE --quiet --eval "db.ratings.find()"'` - I am having problem with different things being escaped

## General Pipelines

- k8s pipeline
  - apply build resources in bookinfo-cicd?
  - apply deploy resources in bookinfo
  - run same tests as app pipeline
- app pipeline
  - apply build resources in bookinfo-cicd?
  - build: `oc start-build <app> --follow`
  - deploy: `oc tag <app>:latest <app>:prod`
  - test: run test (curl, oc rsh etc.)

## To Do

- [ ] Basic proof of concept with bookinfo-mongodb
- [ ] Wait for k8s events to complete (build, deployment etc.)
- [x] Deploy to a different env from pipeline
- [ ] Separate app & k8s resources pipelines
- [ ] Separate builds from deployments
- [ ] Build in tekton image or buildconfig
- [ ] Trigger pipeline from imagestream update?
- [ ] Deploy to multiple environments
- [ ] ~~Manual trigger for prod deployment (not available: [tektoncd/pipeline#233](https://github.com/tektoncd/pipeline/issues/233))~~


## Materials

- https://github.com/openshift/pipelines-tutorial/tree/master
- https://github.com/tektoncd/triggers/tree/master/docs
- https://github.com/tektoncd/pipeline/tree/master/docs
- https://bigkevmcd.github.io/kubernetes/tekton/pipeline/2020/02/05/cel-interception.html
- https://developer.github.com/v3/activity/events/types/#pushevent
