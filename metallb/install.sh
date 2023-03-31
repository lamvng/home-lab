namespace=metallb

# Add Helm repo
helm repo add metallb https://metallb.github.io/metallb

# Install Metallb through Helm
helm install metallb metallb/metallb --create-namespace --namespace $namespace -f metallb/values.yaml

# Configuration
kubectl apply -f metallb/ip-pool-config.yaml

# Verify created IP pool
kubectl -n metallb get ipaddresspools.metallb.io
kubectl -n metallb get l2advertisements.metallb.io
