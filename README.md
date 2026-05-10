# Home Lab

## Overview

- Hosting [Firefly III](https://github.com/firefly-iii/firefly-iii), a personal finance management app.
- Creating a Grafana dashboard for global spending/revenue analysis and financial health visibility.
- Hosting a local LLM via Ollama, with agents to simplify interactions with Firefly:
  - Registering transactions using natural language
  - Performing personal financial analysis
- Other technical components: Argo CD, Cert Manager, GPU Operator...

## Technical Context

- The stack is hosted on a laptop, which may be turned on and off regularly.
- The Firefly III database is the most critical component. It is backed up regularly to local disk and to Google Drive.
- The rest of the stack can be torn down and set up from scratch without issues.

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

# On-demand commands or cron jobs

Set up the laptop:

```shell
uv run ansible-playbook ansible/playbooks/setup_laptop.yml --ask-become-pass
```

Set up the cluster:

```shell
uv run ansible-playbook ansible/playbooks/bootstrap.yml --ask-become-pass
```

Backup Firefly DB:

```shell
uv run ansible-playbook ansible/playbooks/firefly_db_backup_restore.yml --ask-become-pass --tags backup
```

Restore Firefly DB:

```shell
uv run ansible-playbook ansible/playbooks/firefly_db_backup_restore.yml --ask-become-pass --tags restore
```

Remove K3S:

```shell
uv run ansible-playbook ansible/playbooks/remove_k3s.yml --ask-become-pass
```

# TODO

- [x] Fix a bug where K3s crashes at startup because of node IP changes.
- [x] Migrate to Gateway API.
  - [ ] Migrate Ollama to Gateway API: Waiting for upstream MR https://github.com/otwld/ollama-helm/pull/249.
  - [ ] Enhancement: Manage certificates separately per application with `ListenerSet` instead of a giant wildcard certificate attached in the `Gateway` resource. See [ListenerSet](https://gateway-api.sigs.k8s.io/guides/listener-set/) and [Cert Manager design document](https://github.com/cert-manager/cert-manager/blob/master/design/20250703.gatewayapi-listenerset.md). Blocked because Traefik does not support ListenerSet yet (see [issue](https://github.com/traefik/traefik/issues/12626)).
- [x] Introduce UV as package manager.
- [x] Use `kubernetes` module for related bootstrapping Ansible tasks.
- [ ] Introduce proper secret management.
- [ ] Automate uploading backups to Google Drive.
  - [ ] Idea: Fire a webhook to trigger the backup job to Google Drive.
- [ ] Bug: Adding the user to the `k3s_admin` group requires logging out and logging back in to take effect.
