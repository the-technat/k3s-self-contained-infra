apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
- clusterissuer-le-staging.yaml
- clusterissuer-le.yaml
- dummy-ingress.yaml
