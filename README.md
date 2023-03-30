# Home Lab
Playground to test out some DevOps tools and ideas.

## Components

- A local [K3S](https://k3s.io/) cluster.
  - Load Balancer: Metallb
  - Ingress Controller: Nginx
- A simple application with frontend, backend, and database.
- CI: Github Actions.
- GitOps: ArgoCD.
- Secret Management: Vault.
- Service Mesh: (Consul or Istio)