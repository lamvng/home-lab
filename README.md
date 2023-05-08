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
- Monitoring: Rancher Monitoring (Prometheus, AlertManager, Grafana)

# Setup

## Argo CD

After the initial installation, we need to set up the application. Declarative setup is used in this scenario.

```
helm template application_cluster_management/ | kubectl apply -f -
```

## Local DNS entries

Since this lab is not hosted on public servers and no public domain name is configured, Some entries are required in `/etc/hosts` and 

- `/etc/hosts`
```
127.0.0.1 my.lab
127.0.0.1 grafana.my.lab
```
