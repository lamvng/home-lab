# Home Lab

## Purpose

Hosting [Firefly III](https://github.com/firefly-iii/firefly-iii), a personal finance manager app.

## Technical Context

- The stack is hosted on a laptop, which may be turned on and off regularly.
- The Firefly III database is the most critical component. It is backed up regularly to local disk and to Google Drive.
- The rest of the stack can be torn down and set up from scratch without issue.

## Solution and Implementation Choices

- Homelab hosted on a laptop.
- Choosing Kubernetes in favor of potential future investment in additional hardware. At the current scale, the stack could also be run without issues using Docker on a single node.
- K3S for a lightweight and ready-to-use Kubernetes distribution.
- Traefik as the ingress controller, since it is packed with K3s and requires no additional maintenance effort.
- ArgoCD for GitOps-based deployment.

# Bootstrap

Set up Pyenv: https://github.com/pyenv/pyenv?tab=readme-ov-file#linuxunix

Install a newer Python version and create a virtualenv:

```
pyenv_latest=$(pyenv latest -k 3)
pyenv install $pyenv_latest
pyenv local $pyenv_latest
python -m venv $HOME/homelab_venv
```




Set up the cluster:

# On-demand commands or cron jobs

```
ansible-playbook ansible/playbooks/bootstrap.yml --ask-become-pass
```

Backup Firefly DB:

```shell
ansible-playbook ansible/playbooks/firefly_db_backup_restore.yml --ask-become-pass --tags backup
```

Restore Firefly DB:

```shell
ansible-playbook ansible/playbooks/firefly_db_backup_restore.yml --ask-become-pass --tags restore
```

Remove K3S:

```shell
ansible-playbook ansible/playbooks/remove_k3s.yml --ask-become-pass
```
