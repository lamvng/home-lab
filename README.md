# Home Lab

## Overview

The original requirement: an application to track spending, income, and savings, and assess financial health without sharing sensitive data with third parties.

- Hosting [Firefly III](https://github.com/firefly-iii/firefly-iii), a personal finance management application, for daily use.
  - Automating database backup and encryption to Google Drive.
- Creating a Grafana dashboard for global spending/revenue analysis and financial health visibility. See the dashboard on https://github.com/lamvng/firefly-iii-dashboard.
- Hosting open LLM models (Gemma 4 and Qwen 3.5) via Ollama, with agents to simplify interactions with Firefly:
  - Registering transactions using natural language.
  - Performing personal financial analysis.

## Technical Stack

- Bare-metal setup is automated by [Ansible](https://docs.ansible.com/).
- [K3s](https://k3s.io/) as the Kubernetes distribution.
- [Argo CD](https://argoproj.github.io/cd/) for GitOps Kubernetes deployments.
- [Traefik](https://traefik.io/traefik) with [Gateway API](https://kubernetes.io/docs/concepts/services-networking/gateway/) for application proxy.
- [Sealed Secrets](https://github.com/bitnami-labs/sealed-secrets) for storing secrets in Git.
- [Grafana](https://grafana.com/) for visualization.
- [Cert Manager](https://cert-manager.io/) for certificate management.
- [rclone](https://rclone.org/) for database backup and encryption to Google Drive.
- [Ollama](https://ollama.com/) for LLM hosting.
- [Gemma 4](https://deepmind.google/models/gemma/gemma-4/) and [Qwen 3.5](https://qwen.ai/blog?id=qwen3.5) as the models used.

## Operational Context

- The stack is hosted on a laptop, which may be turned on and off regularly.
- The Firefly III database is the most critical component. It is backed up regularly to local disk and to Google Drive.
- The rest of the stack can be torn down and set up from scratch without issues.

# Works

- [x] Set up the bare-metal stack (prerequisite packages & K3s).
- [x] Set up Argo CD.
- [x] Set up Cert Manager.
- [x] Install Firefly III stack.
- [x] Migrate all financial history.
- [x] Set up Ollama and test open LLM models.
- [x] Make K3s see the GPU.
- [x] Set up Grafana.
- [x] Create a dashboard for financial insights.
- [x] Fix a bug where K3s crashes at startup because of node IP changes.
- [x] Migrate to Gateway API.
  - [ ] Migrate Ollama to Gateway API: Waiting for upstream MR https://github.com/otwld/ollama-helm/pull/249.
  - [ ] Enhancement: Manage certificates separately per application with `ListenerSet` instead of a giant wildcard certificate attached in the `Gateway` resource. See [ListenerSet](https://gateway-api.sigs.k8s.io/guides/listener-set/) and [Cert Manager design document](https://github.com/cert-manager/cert-manager/blob/master/design/20250703.gatewayapi-listenerset.md). Blocked because Traefik does not support ListenerSet yet (see [issue](https://github.com/traefik/traefik/issues/12626)).
- [x] Introduce UV as package manager.
- [x] Use `kubernetes` module for related bootstrapping Ansible tasks.
- [x] Introduce proper secret management.
- [x] Automate uploading backups to Google Drive.
- [ ] Create an AI agent to simplify Firefly transactions management.
- [ ] Fix a bug where adding the user to the `k3s_admin` group requires logging out and logging back in to take effect, hence crashing the playbook.

# Bootstrap

Install prerequisite packages:

```shell
sudo apt install curl git
curl -Lssf https://astral.sh/uv/install.sh | sh
```

Clone the repo:

```shell
sudo mkdir /opt/repos
sudo chown $USER:$USER /opt/repos
git clone git@github.com:lamvng/home-lab.git /opt/repos/home-lab
```

Set up dependencies:

```shell
uv sync
```

Set up the laptop:

```shell
uv run ansible-playbook ansible/playbooks/setup_laptop.yml --ask-become-pass
```

Set up the cluster:

```shell
uv run ansible-playbook ansible/playbooks/bootstrap.yml --ask-become-pass
```

Set up `rclone` for Google Drive. following [this tutorial](https://rclone.org/drive/#making-your-own-client-id).

# Automated scripts

## Regular scripts

Start K3s and configure KUBECONFIG:

```
k3s-start.sh
```

Backup Firefly database to local disk and Google Drive, restore and test the backed up dump, and terminate K3s:

```
k3s-clean.sh
```

Backup Firefly DB on-demand. The command will also back up the most recent dumps on Google Drive.

```shell
uv run ansible-playbook ansible/playbooks/firefly_db_backup_restore.yml --ask-become-pass --tags backup
```

Restore Firefly DB on-demand. The command download the dumps from Google Drive and restore.

```shell
uv run ansible-playbook ansible/playbooks/firefly_db_backup_restore.yml --ask-become-pass --tags restore
```

Remove K3S:

```shell
uv run ansible-playbook ansible/playbooks/remove_k3s.yml --ask-become-pass
```
