# Add charts
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add stable https://charts.helm.sh/stable/
helm repo update

# Install chart
helm install rancher-monitoring prometheus-community/kube-prometheus-stack --namespace monitoring --create-namespace -f monitoring/values.yaml
