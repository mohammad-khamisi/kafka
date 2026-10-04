helm version

kubectl create namespace kafka

# check the chart and the keys you can override
helm show chart  oci://quay.io/strimzi-helm/strimzi-kafka-operator --version 1.2.0
helm show values oci://quay.io/strimzi-helm/strimzi-kafka-operator --version 1.2.0

helm install strimzi-operator \
  oci://quay.io/strimzi-helm/strimzi-kafka-operator \
  --version 1.2.0 \
  --namespace kafka \
  -f operator-values.yaml

kubectl -n kafka rollout status deploy/strimzi-cluster-operator
kubectl get crd | grep strimzi
