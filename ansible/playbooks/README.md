# Ansible playbooks

Bootstrap: Install K3S, and ArgoCD.

```shell
ansible-playbook ansible/playbooks/bootstrap.yml --ask-become-pass
```

Firefly:

```shell
ansible-playbook ansible/playbooks/firefly.yml --ask-become-pass
```
