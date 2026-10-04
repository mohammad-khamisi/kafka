# part 1
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

# part 2

kubectl apply -f 01-kafka-nodepool.yaml -f 02-kafka.yaml

kubectl -n kafka wait kafka/my-cluster --for=condition=Ready --timeout=900s

kubectl -n kafka get kafka,kafkanodepool
kubectl -n kafka get pods -l strimzi.io/cluster=my-cluster -o wide
kubectl -n kafka get pvc
