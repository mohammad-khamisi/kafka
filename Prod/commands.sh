#------------------------Strimzi Operator-----------------------------
kubectl create namespace kafka

helm install strimzi-operator \
  oci://quay.io/strimzi-helm/strimzi-kafka-operator \
  --version 1.2.0 \
  --namespace kafka \
  --set replicas=1
#------------------------verifications-----------------------------
kubectl apply -f 01-kafka-nodepools-lab.yaml -f 02-kafka-lab.yaml
kubectl -n kafka wait kafka/my-cluster --for=condition=Ready --timeout=1500s
kubectl apply -f 03-kafkauser.yaml -f 04-kafkatopic.yaml
#------------------------verifications-----------------------------
#------------------------verifications-----------------------------
#------------------------verifications-----------------------------
#------------------------verifications-----------------------------
#------------------------verifications-----------------------------
#------------------------verifications-----------------------------
#------------------------verifications-----------------------------
#------------------------verifications-----------------------------
#------------------------verifications-----------------------------
