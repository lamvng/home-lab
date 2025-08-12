# Ansible playbooks

Bootstrap: Install K3S, and ArgoCD.

```shell
ansible-playbook ansible/playbooks/bootstrap.yml --ask-become-pass
```

Backup Firefly DB dump:

```shell
ansible-playbook ansible/playbooks/firefly_db_backup.yml --ask-become-pass
```
