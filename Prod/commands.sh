#------------------------Strimzi Operator-----------------------------
kubectl create namespace kafka

helm install strimzi-operator \
  oci://quay.io/strimzi-helm/strimzi-kafka-operator \
  --version 1.2.0 \
  --namespace kafka \
  --set replicas=1
#------------------------verifications-----------------------------
#------------------------verifications-----------------------------
#------------------------verifications-----------------------------
#------------------------verifications-----------------------------
#------------------------verifications-----------------------------
#------------------------verifications-----------------------------
#------------------------verifications-----------------------------
#------------------------verifications-----------------------------
#------------------------verifications-----------------------------
#------------------------verifications-----------------------------
