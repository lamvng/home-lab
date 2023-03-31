namespace=metallb

# Add Helm repo
helm repo add nginx-stable https://helm.nginx.com/stable
helm repo update

# Install chart
# https://github.com/kubernetes/ingress-nginx/blob/main/charts/ingress-nginx/values.yaml
helm install nginx-ingress nginx-stable/nginx-ingress --create-namespace --namespace nginx-ingress
