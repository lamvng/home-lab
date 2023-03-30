# Install K3S without Traefik and ServiceLB
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server --disable traefik --disable servicelb" sh -

# Copy kubeconfig file
cp /etc/rancher/k3s/k3s.yaml $HOME/.kube/k3s

# Modify permission
chown $USER:$USER $HOME/.kube/k3s
