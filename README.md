# Home Lab

## Purpose

Hosting [Firefly III](https://github.com/firefly-iii/firefly-iii), a personal finance manager app.

## Technical Context

- The stack is hosted on a laptop, which may be turned on and off regularly.
- The Firefly III database is the most critical component. It is backed up regularly to local disk and to Google Drive.
- The rest of the stack can be torn down and set up from scratch without issue.

## Solution and Implementation Choices

- Homelab hosted on a laptop.
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




# On-demand commands or cron jobs

Set up the cluster:

```shell
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

# Debt

## K3S fails to start after the host IP changes

### Symptom

Whenever the wireless interface changes (eg. laptop is carried elsewhere, or DHCP allocates a different IP when the host is rebooted), K3S fails to start with the following error:

```
network policy controller: error getting node subnet: failed to find interface with specified node ip
```

### Bug

It turns out that Flannel picks the controller interface as the first visible interface. K3S then stores the IP in their DB. Whenever the allocated IP is changed, K3S would break.

Some inspiration:

- https://dev.to/shankar_t/my-k3s-pi-cluster-died-after-a-reboot-a-troubleshooting-war-story-m93
- https://stackoverflow.com/questions/66449289/is-there-any-way-to-bind-k3s-flannel-to-another-interface
