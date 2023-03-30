namespace=metallb

# Add Helm repo
helm repo add metallb https://metallb.github.io/metallb

# Install Metallb through Helm
helm install metallb metallb/metallb --create-namespace --namespace $namespace -f metallb/values-metallb.yaml

# Configuration
