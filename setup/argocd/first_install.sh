helm repo add argo https://argoproj.github.io/argo-helm
helm install --namespace argocd --create-namespace --argo argo/argo-cd

# Port forward
kubectl port-forward svc/argo-argocd-server -n argocd 9090:443 --address=0.0.0.0

# Get initial admin password
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
