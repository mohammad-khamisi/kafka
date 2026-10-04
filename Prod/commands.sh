#------------------------verifications-----------------------------
kubectl config current-context
kubectl get nodes -o custom-columns='NAME:.metadata.name,TAINTS:.spec.taints[*].key'
docker info | grep -i "total memory"
uname -m
helm version --short
curl -sI https://quay.io | head -1
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
