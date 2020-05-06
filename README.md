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

- `PipelineResource`s are deprecated, ~~need a newer version of tekton then is available via the operator~~ need canary version (0.11.3)
  - git resources are easy enough, what do i do about images/image streams
- 0.12.0 of tekton coming out soonish, will have some breaking changes
  - cel interceptor functions (`split()` to `body.blah.split()`)
  - Will have PVCTemplate for pipeline runs, rather than manually creating a pvc
- May have to tweak handling of github push events as i'm currently just mocking what I think is correct
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

- tekton task s2i
  - no imagestream support
  - pulls images from external registries (unless we use an imported version, so more local?)
  - needs privileges?

## Questions

- How do I do some other basic things like trigger different pipelines for different branches
  - **Answer:** Interceptors
- How do I secure the webhook so that only repos I own can trigger it?
  - **Answer:** Use the gitub interceptor with a secret, and the CEL interpreter to select based on info in the webhook body (e.g. specific repos)
- How do I run a command like this: `oc rsh dc/mongodb bash -c 'mongo -u $MONGODB_USER -p $MONGODB_PASSWORD $MONGODB_DATABASE --quiet --eval "db.ratings.find()"'` - I am having problem with different things being escaped
  - Was an example in an openshift-pipelines tutorial task

- I don't really see the point of triggerbindings, don't we already map vars in triggertemplate?
  - Maybe the templates are meant to be more reusable? Can't really see it though.

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

- [x] Deploy to a different env from pipeline
- [ ] Deploy ratings database k8s resources from separate repo
- [ ] Build ratings service from original repo
- [ ] Deploy ratings k8s resources from separate repo[]
- [ ] Basic proof of concept with bookinfo-mongodb
- [ ] Wait for k8s events to complete (build, deployment etc.)
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
