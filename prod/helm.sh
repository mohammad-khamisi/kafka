helm version

helm install strimzi oci://quay.io/strimzi-helm/strimzi-kafka-operator \
  --namespace kafka --create-namespace \
  --set watchNamespaces="{kafka}" \
  --set resources.requests.memory=256Mi \
  --set resources.limits.memory=384Mi

kubectl get pods -n kafka
